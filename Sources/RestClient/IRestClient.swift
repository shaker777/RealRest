//
//  IRestClient.swift
 //  
//
//  Created by Real Estimation on 17.09.17.
//  Copyright © 2017 Real Estimation. All rights reserved.
//

import Foundation

public enum RestMethod {
    case get
    case post
    case delete
}

protocol IRestClient {
    func send(url: String, data: [AnyHashable: Any]?, headers: [String: String], method: RestMethod, callback: ((RestResponse) -> Void)?)
}
