//
//  RestResponse.swift
 //  
//
//  Created by Real Estimation on 18.09.17.
//  Copyright © 2017 Real Estimation. All rights reserved.
//

import Foundation
class RestResponse: CustomStringConvertible {
    var status_code: StatusCode
    var json: [AnyHashable: Any]?

    init (status_code: Int, json: [AnyHashable: Any]?) {
        if let statusCode = StatusCode(rawValue: status_code) {
            self.status_code = statusCode
        } else {
            self.status_code = .undefined
        }
        self.json = json
    }

    var description: String {
        if (json != nil) {
            return "Status : \(status_code) \n \(String(describing: json as AnyObject))"
        }
        return "\(status_code) - EMPTY"
    }

}
