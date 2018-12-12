//
//  ICommandExecuter.swift
 //  
//
//  Created by Real Estimation on 14.09.17.
//  Copyright © 2017 Real Estimation. All rights reserved.
//

import Foundation
import BrightFutures

public protocol ICommandExecutor {
    associatedtype CommandContext
    var commandContext: CommandContext? {get set}

    func execute<T: ICommand>(_ command: T) -> CommandFuture<T>.FutureT
    func execute<T: ICommand>(_ command: T, showProgress: Bool) -> CommandFuture<T>.FutureT
}
