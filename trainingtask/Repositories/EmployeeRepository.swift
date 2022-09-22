//
//  EmployeeRepository.swift
//  trainingtask
//
//  Created by Артем Томило on 21.09.22.
//

import UIKit

class EmployeeRepository {
    
    static let path = try! FileManager.default.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: true)
    static let jsonPath = path.appendingPathComponent("employees.json")
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    func saveEmployee(to array: [Employee]) {
        do {
            let data = try encoder.encode(array)
            try data.write(to: EmployeeRepository.jsonPath, options: Data.WritingOptions.atomic)
        } catch {
            print("Error encoding item array: \(error.localizedDescription)")
        }
    }
    
    func loadEmployees() -> [Employee] {
        var results = [Employee]()
        if let data = try? Data(contentsOf: EmployeeRepository.jsonPath) {
            do {
                results = try decoder.decode([Employee].self, from: data)
            } catch {
                print("Error decoding item array: \(error.localizedDescription)")
            }
        }
        return results
    }
}
