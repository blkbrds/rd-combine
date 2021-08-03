//
//  Data.Ext.swift
//  Foody
//
//  Created by MBA0283F on 4/8/21.
//

import Foundation

extension Data {
    func toJSON() -> Any? {
        do {
            return try JSONSerialization.jsonObject(
                with: self,
                options: .allowFragments
            )
        } catch {
            return nil
        }
    }

    func toString() -> String? {
        return String(data: self, encoding: .utf8)
    }
}
