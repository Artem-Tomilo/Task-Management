//
//  BaseError.swift
//  trainingtask
//
//  Created by Артем Томило on 11.01.23.
//

import Foundation

struct BaseError: Error {
    
    var message: String
    
    init(message: String) {
        self.message = message
    }
}
