//
//  AppSender.swift
 //  
//
//  Created by Real Estimation on 14.09.17.
//  Copyright © 2017 Real Estimation. All rights reserved.
//

import Foundation
import BrightFutures
import Result

class AppSender <Context>: ISender {
    typealias CommandContext = Context
    // MARK: dependences
    var progressHud: IProgressHud = ProgressHud()

    // MARK: variables
    var waitingCommands: Array<AppCommand<CommandContext>> = Array<AppCommand>()
    var num: Int = 0

    func execute<T: ICommand>(_ command: T, context: CommandContext, showProgress: Bool) -> CommandFuture<T>.FutureT {
        guard let appCommand = command as? AppCommand<CommandContext> else {
            print("[ERROR] [AppSender] command is null")
            return CommandFuture<T>.FutureT()
        }
        num += 1
        appCommand.num = num
        appCommand.context = context
        appCommand.showProgress = showProgress
        let progressKey = "\(type(of: command)) \(command.num)"


        print("[INFO] [AppSender] send \(num) \(type(of: command))")

        let future = CommandFuture<T>.FutureT {[weak self, weak appCommand] complete in
            appCommand?.successCallback = {[weak self, weak appCommand] in
                if let appCommand = appCommand {
                    appCommand.onSuccess()
                    self?.waitingCommands.remove(appCommand)
                    complete(.success(command))
                }
                self?.progressHud.dismiss(id: progressKey)
            }
            appCommand?.errorCallback = {[weak self, weak appCommand] in
                if let appCommand = appCommand {
                    _ = appCommand.onError(error: AppCommandError())
                    self?.waitingCommands.remove(appCommand)
                    complete(Result<T, T.CommandError>.init(error: AppCommandError() as! T.CommandError))
                }
                self?.progressHud.dismiss(id: progressKey)
            }
        }

        if (command.showProgress) {
            progressHud.show(id: progressKey)
        }
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 1/60.0, execute: {[weak self, weak appCommand] in
            if let appCommand = appCommand {
                if appCommand.check() {
                    self?.waitingCommands.append(appCommand)
                    appCommand.onExecute()
                } else {
                    appCommand.error()
                }
            }
        })
        return future
    }
}
