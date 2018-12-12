//
//  Array+remove.swift
 //  
//
//  Created by Real Estimation on 14.09.17.
//  Copyright © 2017 Real Estimation. All rights reserved.
//

import Foundation
extension Array where Element:Equatable {
    public mutating func remove(_ item: Element ) {
        var index = 0
        while index < self.count {
            if self[index] == item {
                self.remove(at: index)
            } else {
                index += 1
            }
        }
    }

    public func array( removing item: Element ) -> [Element] {
        var result = self
        result.remove( item )
        return result
    }
    
    func removeDuplicates() -> [Element] {
        var result = [Element]()
        
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        
        return result
    }
    
}
