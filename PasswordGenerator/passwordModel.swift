//
//  passwordModel.swift
//  PasswordGenerator
//
//  Created by Nitish M on 29/12/25.
//

import Foundation
import SwiftUI
import SwiftData

@Model
class passwordModel: Identifiable{
    var id: UUID = UUID()
    var name: String
    var password: String
    
    init(name: String, password: String) {
        self.name = name
        self.password = password
    }
}
