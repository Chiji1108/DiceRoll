//
//  DiceRollApp.swift
//  DiceRoll
//
//  Created by 千々岩真吾 on 2025/03/13.
//

import SwiftData
import SwiftUI

@main
struct DiceRollApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: DiceRoll.self)
    }
}
