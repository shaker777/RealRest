//
//  NetSender.swift
 //  
//
//  Created by Real Estimation on 14.09.17.
//  Copyright © 2017 Real Estimation. All rights reserved.
//

import Foundation
import BrightFutures
import Result


class RestSender<Context>: ISender {
    typealias CommandContext = Context
    
    // MARK: dependences
    var client: IRestClient = RestClient()
    var progressHud:IProgressHud = ProgressHud()

    // MARK: variables
    var waitingCommands: [IRestCommand<CommandContext>] = []
    var commandQueue: [IRestCommand<CommandContext>] = []
    var num: Int = 0
    var fakeQueue = DispatchQueue(label: "RestSenderFakeQueue")
    var serverUrl: String = ""
    public var headers: [String: String] = [:]
    
    init(serverUrl: String) {
        self.serverUrl = serverUrl;
    }

    func execute<T: ICommand>(_ command: T, context: CommandContext, showProgress: Bool) -> CommandFuture<T>.FutureT {

        guard let command = command as? IRestCommand<CommandContext> else {
            print("[ERROR] [RestSender] command is null")
            return CommandFuture<T>.FutureT()
        }

        num += 1
        command.num = num
        command.context = context
        command.showProgress = showProgress
        let progressKey = "\(type(of: command)) \(command.num)"

        commandQueue.append(command)

        let future = CommandFuture<T>.FutureT {[weak self, weak command] complete in
            command?.successCallback = {[weak self, weak command] in
                if let cmd = command {
                    self?.progressHud.dismiss(id: progressKey)
                    cmd.onSuccess()
                    if let command = command as? T{
                            complete(.success(command))
                    }else{
                        print("[ERROR] [RestSender] cannot convert command to \(type(of: T.self))")
                    }
                    self?.waitingCommands.remove(cmd)
                }
            }
            command?.errorCallback = {[weak self, weak command] error in
                if let cmd = command {
                    self?.progressHud.dismiss(id: progressKey)
                    cmd.onError(error: error)
                    self?.waitingCommands.remove(cmd)
                    complete(Result<T, T.CommandError>.init(error: error as! T.CommandError))
                    
                }
            }
        }

        send()
        return future
    }

    func send() {
        if (waitingCommands.isEmpty && commandQueue.isEmpty == false) {

            guard let command = commandQueue.first else {
                print("[ERROR] [RestSender] commandQueue is empty")
                return
            }
            commandQueue.remove(command)
            
            if (command.debugLog){
                print("[INFO] [RestSender] send \(type(of: command))(\(command.num)) : \(command.path) : \n \(String(describing: command.getSendData() as? AnyObject))")
            }else{
                print("[INFO] [RestSender] send \(type(of: command))(\(command.num)) : \(command.path)")
            }

            if command.check() {
                self.waitingCommands.append(command)
                command.onExecute()

                let requestUrl = "\(serverUrl)\(command.path)"
                //var headers: [String: String] = [:]
                let progressKey = "\(type(of: command)) \(command.num)"

                if (command.showProgress) {
                    progressHud.show(id: progressKey)
                }
                
                //Fake response
                if let fakeResponse = command.fakeResponse(){
                    fakeQueue.async {[weak self] in
                        if (command.debugLog){
                            print("[INFO] [RestSender] recieve \(type(of: command))(\(command.num) : \n \(fakeResponse))")
                        }else{
                            print("[INFO] [RestSender] recieve \(type(of: command))(\(command.num)")
                        }
                        DispatchQueue.main.sync {
                            command.success();
                            self?.send();
                        }
                    }
                    return;
                }
                
                //Original response
                client.send(url: requestUrl, data: command.getSendData(), headers: self.headers, method: command.method, callback: { [weak self] response in
                    if (command.debugLog){
                        print("[INFO] [RestSender] recieve \(type(of: command))(\(command.num) code:\(response.status_code) : \n \(response))")
                    }else{
                        print("[INFO] [RestSender] recieve \(type(of: command))(\(command.num) code:\(response.status_code))")
                    }

                    switch response.status_code {
                    case .ok:
                        if let jsonData = response.json {
                            _ = command.parseResponseFromJson(json: jsonData)
                            command.success()
                        } else {
                            print("[ERROR] [RestSender] deserealize \"data\" error")
                            command.error(error: RestCommandError(statusCode: response.status_code, response:[:]))
                            if (command.debugLog == false){
                                print("[INFO] [RestSender] recieve \(type(of: command))(\(command.num) code:\(response.status_code) : \n \(response))")
                            }
                        }
                    default:
                        if let jsonError = response.json {
                            command.error(error: RestCommandError(statusCode: response.status_code, response: jsonError))
                        } else {
                            command.error(error: RestCommandError(statusCode: response.status_code, response: [:]))
                        }
                    }
                    self?.send()
                })

            } else {
                print("[ERROR] [RestSender] command check error \(command.path)")
                command.error(error: RestCommandError(statusCode: .client_error, response: [:]))
            }
        }

    }
}
