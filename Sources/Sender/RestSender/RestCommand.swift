//
//  NetCommand.swift
 //  
//
//  Created by Real Estimation on 14.09.17.
//  Copyright © 2017 Real Estimation. All rights reserved.
//

import Foundation
import EVReflection


open class RestCommand<Context, Request: EVObject, Response: EVObject> : IRestCommand<Context>{

    public var request: Request = Request()
    public var response: Response!

    override func parseResponseFromJson(json: [AnyHashable: Any]?) -> Bool{
        if let json = json {
            response = Response(dictionary: json as NSDictionary)
            return false
        }
        return false
    }
    
    override func parseResponseFromJson(json: [Any]?) -> Bool{
        if let json = json {
            response = Response(dictionary: ["values":json] as NSDictionary)
            return false
        }
        return false
    }

    override func getSendData() -> [AnyHashable: Any]? {
        do {
            return try JSONSerialization.jsonObject(with: request.toJsonData(), options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
  
    open func onFakeResponse() -> Response? {
        return nil
    }
    
    override func fakeResponse() -> Any?{
        if let response = onFakeResponse(){
            self.response = response;
            return response;
        }
        return nil;
    }
}

extension RestCommand where Response: EVObject{

}
