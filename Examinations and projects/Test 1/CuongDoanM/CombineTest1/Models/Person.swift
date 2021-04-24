//
//  Person.swift
//  CombineTest1
//
//  Created by Cuong Doan M. on 2/26/21.
//

import Foundation

final class Person: ObservableObject {
    
    @Published var name: String
    @Published var address: String
    
    init(name: String, address: String) {
        self.name = name
        self.address = address
    }
    
    func update(from person: Person) {
        name = person.name
        address = person.address
    }
    
    func copy() -> Person {
        return Person(name: name, address: address)
    }
    
    var isValid: Bool {
        return !name.isEmpty && !address.isEmpty
    }
}
