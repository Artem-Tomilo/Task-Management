//
//  Project.swift
//  trainingtask
//
//  Created by Артем Томило on 9.12.22.
//

import Foundation

struct Project: Codable, Equatable {
    var name: String
    var description: String
    var id: Int
    var idCounter = 0
    
    init(name: String, description: String) {
        self.name = name
        self.description = description
        self.id = self.idCounter
        self.idCounter += 1
    }
}
