//
//  ISender.swift
 //  
//
//  Created by Real Estimation on 14.09.17.
//  Copyright © 2017 Real Estimation. All rights reserved.
//

import Foundation
import BrightFutures

protocol ISender {
    associatedtype CommandContext
    
    func execute<T: ICommand>(_ command: T, context: CommandContext, showProgress: Bool) -> CommandFuture<T>.FutureT
}
