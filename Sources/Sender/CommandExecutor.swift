//
//  CommandExecuter.swift
 //  
//
//  Created by Real Estimation on 14.09.17.
//  Copyright © 2017 Real Estimation. All rights reserved.
//

import Foundation
import BrightFutures

//namespace
class Command {

}

open class CommandExecutor <CommandContext>: ICommandExecutor {
    var appSender: AppSender<CommandContext>
    var restSender: RestSender<CommandContext>
    public var commandContext: CommandContext?

    public init(serverUrl:String, context: CommandContext){
        appSender = AppSender<CommandContext>()
        restSender = RestSender<CommandContext>(serverUrl: serverUrl)
        self.commandContext = context;
    }
    
    open func setupHeaders(headers:[String:String]) {
        self.restSender.setHeaders = headers
    }
    
    open func execute<T: ICommand>(_ command: T) -> CommandFuture<T>.FutureT {
        return execute(command, showProgress: true)
    }

    
    open func execute<T: ICommand>(_ command: T, showProgress: Bool) -> CommandFuture<T>.FutureT {
        if command.type == CommandType.app {
            return (appSender.execute(command, context: commandContext!, showProgress: showProgress))
        }
        if command.type == CommandType.rest {
            return (restSender.execute(command, context: commandContext!, showProgress: showProgress))
        }
        return CommandFuture<T>.FutureT()
    }
    
    open func setRestUrl(_ url: String){
        restSender.serverUrl = url
    }
}
