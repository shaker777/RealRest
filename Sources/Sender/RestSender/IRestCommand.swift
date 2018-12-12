//
//  IRestCommand.swift
 //  
//
//  Created by Real Estimation on 17.09.17.
//  Copyright © 2017 Real Estimation. All rights reserved.
//

import Foundation


open class IRestCommand<Context>: ICommand, Equatable {

    public typealias CommandError = RestCommandError
    public typealias CommandContext = Context
    
    public var num: Int = 0
    public var type: CommandType = CommandType.rest
    public var showProgress: Bool = false
    public var debugLog: Bool = false;
    public var context: CommandContext!

    public let path: String
    public let method: RestMethod

    public init (method: RestMethod, path: String) {
        self.method = method
        self.path = path
    }

    public init(method: RestMethod, path: String, id: String) {
        self.method = method
        self.path = path.replacingOccurrences(of: ":id", with: id)
    }

    public init(method: RestMethod, path: String, id: Int) {
        self.method = method
        self.path = path.replacingOccurrences(of: ":id", with: "\(id)")
    }

    var successCallback:(()->Void)?
    var errorCallback: ((RestCommandError)->Void)?

    //ICommand protocol
    open func check() -> Bool {return true}
    open func onExecute() {}
    open func onSuccess() {}
    open func onError(error: RestCommandError) -> Bool { return false }

    func success() {
        successCallback?()
        successCallback = nil
    }

    func error(error: RestCommandError) {
        errorCallback?(error)
        errorCallback = nil
    }

    public static func ==(lhs: IRestCommand, rhs: IRestCommand) -> Bool {
        return lhs.num == rhs.num
    }

    func getSendData() -> [AnyHashable: Any]? { return nil }
    func parseResponseFromJson(json: [AnyHashable: Any]?) -> Bool {return true}
    func parseResponseFromJson(json: [Any]?) -> Bool {return true}
    func fakeResponse() -> Any? {return nil}
}
