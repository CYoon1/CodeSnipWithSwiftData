//
//  CodeSnipWithSwiftDataApp.swift
//  CodeSnipWithSwiftData
//
//  Created by Christopher Yoon on 2/12/24.
//

import SwiftUI
import SwiftData

@main
struct CodeSnipWithSwiftDataApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self, Snippet.self, Tag.self
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
            NavigationStack {
                ContainerView()
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
