//
//  RestErrorHandler.swift
 //  
//
//  Created by Real Estimation on 19.09.17.
//  Copyright © 2017 Real Estimation. All rights reserved.
//

import Foundation

//class RestErrorHandler: IRestErrorHandler {
//
//    var alert: IAlert?
//    var screenNotification: IScreenNotification?
//    var logger: ILogger?
//    var session: ISession?
//
//    func handle(error: RestCommandError) {
//        if error.errorCode == .unauthorized{
//            session?.relogin();
//            return;
//        }
//        
//        
//        switch error.errorCode {
//        case .client_check_error:
//            Log.error("Check error")
//        default:
//            screenNotification?.error(title: "Unhandled error", message: "http: \(error.statusCode.rawValue)\ncode: \(error.errorCode.rawValue)")
//        }
//    }
//
//}
