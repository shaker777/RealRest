//
//  IRestErrorHandler.swift
 //  
//
//  Created by Real Estimation on 19.09.17.
//  Copyright © 2017 Real Estimation. All rights reserved.
//

import Foundation

protocol IRestErrorHandler {
    func handle(error: RestCommandError)
}
