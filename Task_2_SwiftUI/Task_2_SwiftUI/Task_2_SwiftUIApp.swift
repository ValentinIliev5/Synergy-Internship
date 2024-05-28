//
//  Task_2_SwiftUIApp.swift
//  Task_2_SwiftUI
//
//  Created by Synergy on 13.05.24.
//

import SwiftUI

@main
struct Task_2_SwiftUIApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
