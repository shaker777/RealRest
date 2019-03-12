//
//  RestCommandError.swift
 //  
//
//  Created by Real Estimation on 18.09.17.
//  Copyright © 2017 Real Estimation. All rights reserved.
//

import Foundation

open class RestCommandError: Error {
    let statusCode: StatusCode
    public let response:[AnyHashable:Any]

    public init(statusCode: StatusCode, response:[AnyHashable:Any]) {
        self.statusCode = statusCode
        self.response = response
    }
}
