//
//  PasswordGeneratorApp.swift
//  PasswordGenerator
//
//  Created by Nitish M on 29/12/25.
//

import SwiftUI
import SwiftData

@main
struct PasswordGeneratorApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [passwordModel.self])
    }
}
