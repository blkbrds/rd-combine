//
//  Image.swift
//  Foody
//
//  Created by MBA0283F on 5/10/21.
//

import SwiftUI

extension Image {
    init(_ data: Data?, isProfile: Bool = false) {
        if let data = data, let image = Image(data: data) {
            self = image
        } else {
            self.init(isProfile ? "no-user": "default-thumbnail")
        }
    }
}
