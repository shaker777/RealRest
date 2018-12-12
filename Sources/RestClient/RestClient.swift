//
//  RestClient.swift
 //  
//
//  Created by Real Estimation on 17.09.17.
//  Copyright © 2017 Real Estimation. All rights reserved.
//

import Foundation
import Alamofire

class RestClient: IRestClient {
    var alamoFireManager: SessionManager
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60 // seconds
        configuration.timeoutIntervalForResource = 60
        self.alamoFireManager = Alamofire.SessionManager(configuration: configuration)
    }

    func send(url: String, data: [AnyHashable: Any]?, headers: [String: String], method: RestMethod, callback: ((RestResponse) -> Void)? ) {
        let queue = DispatchQueue(label: "com.realestimation.rest_queue", qos: .utility, attributes: [.concurrent])

        var alamofireMethod = HTTPMethod.get
        var parametersEncoding: ParameterEncoding = URLEncoding.default;
        switch method {
        case .get:
            alamofireMethod = .get
        case .post:
            alamofireMethod = .post
            parametersEncoding = JSONEncoding.default
        case .delete:
            alamofireMethod = .delete
        }

        let sendData: [String: Any] = data as? [String: Any] ?? [:]
        
        alamoFireManager.request(url, method: alamofireMethod, parameters: sendData, encoding: parametersEncoding, headers: headers)
            .responseJSON(
                queue: queue,
                completionHandler: {response in
                    DispatchQueue.main.async {
                        if let status_code = response.response?.statusCode {
                            callback?(RestResponse(status_code: status_code, json: response.result.value as? [String: Any]))
                        } else {
                            print("[ERROR] [RestClient] status code is nil")
                            callback?(RestResponse(status_code: 0, json: nil))
                        }
                    }
            }
        )
    }

}
