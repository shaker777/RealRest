//
//  AppCommand.swift
 //  
//
//  Created by Real Estimation on 14.09.17.
//  Copyright © 2017 Real Estimation. All rights reserved.
//

import Foundation

open class AppCommandError: Error {

}

open class AppCommand<Context>: ICommand, Equatable {
    public typealias CommandError = AppCommandError
    public typealias CommandContext = Context
    
    public var num: Int = 0
    public var type: CommandType = CommandType.app
    public var showProgress: Bool = false
    public var context: CommandContext!

    var successCallback:(()->Void)?
    var errorCallback:(()->Void)?

    //ICommand protocol
    open func check() -> Bool {return true}
    open func onExecute() {}
    open func onSuccess() {}
    open func onError(error: AppCommandError) -> Bool { return false }

    public init(){
        
    }
    
    public func success() {
        successCallback?()
        successCallback = nil
    }

    public func error() {
        errorCallback?()
        errorCallback = nil
    }

    public static func ==(lhs: AppCommand, rhs: AppCommand) -> Bool {
        return lhs.num == rhs.num
    }
}
