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
    let response:NSDictionary

    init(statusCode: StatusCode, response:NSDictionary) {
        self.statusCode = statusCode
        self.response = response
    }
}
