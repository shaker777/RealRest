//
//  RestObject.swift
//  Pods
//
//  Created by Real Estimation on 11/12/2018.
//

import Foundation
import EVReflection

open class RestObject: EVObject {
    override open func skipPropertyValue(_ value: Any, key: String) -> Bool {
        if let value = value as? String, value.isEmpty == true || value == "null" {
            print("Ignoring empty string for key \(key)")
            return true
        } else if let value = value as? NSArray, value.count == 0 {
            print("Ignoring empty NSArray for key\(key)")
            return true
        } else if value is NSNull {
            print("Ignoring NSNull for key \(key)")
            return true
        }
        return false
    }
}
