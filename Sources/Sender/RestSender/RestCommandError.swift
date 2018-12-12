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

    init(statusCode: StatusCode) {
        self.statusCode = statusCode
    }
}
