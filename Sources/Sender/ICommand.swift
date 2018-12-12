//
//  CommandProto.swift
 //  
//
//  Created by Real Estimation on 14.09.17.
//  Copyright © 2017 Real Estimation. All rights reserved.
//

import Foundation
import BrightFutures
import Result

//to fix templates
public protocol ICmd {}

public protocol ICommand: ICmd {
    associatedtype CommandError: Swift.Error
    associatedtype CommandContext

    var num: Int {get set}
    var type: CommandType {get set}
    var showProgress: Bool {get set}
    var context: CommandContext! {get set}

    func check() -> Bool

    func onExecute()
    func onSuccess()
    func onError(error: CommandError) -> Bool
}

public enum CommandType {
    case rest
    case app
}

open class CommandFuture<T: ICommand> {
    public typealias FutureT = Future<T, T.CommandError>
    public typealias ResultT = Result<T, T.CommandError>
}
