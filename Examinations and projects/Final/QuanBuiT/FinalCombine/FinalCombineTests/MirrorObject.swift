//
//  MirrorObject.swift
//  FinalCombineTests
//
//  Created by Quan Bui T on 2021-07-23.
//  Copyright © 2021 Monstar-Lab Inc. All rights reserved.
//

class MirrorObject {
    let mirror: Mirror

    init(subject: Any) {
        self.mirror = Mirror(reflecting: subject)
    }

    func extract<T>(variableName: StaticString = #function) -> T? {
        return mirror.descendant("\(variableName)") as? T
    }
}
