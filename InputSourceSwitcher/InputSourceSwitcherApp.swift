//
//  InputSourceSwitcherApp.swift
//  InputSourceSwitcher
//
//  Created by 福田裕作 on 2024/10/18.
//

import SwiftUI
import SwiftData

@main
struct InputSourceSwitcherApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
