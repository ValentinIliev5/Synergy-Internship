//
//  Task_1App.swift
//  Task_1
//
//  Created by Synergy on 7.05.24.
//

import SwiftUI

@main
struct Task_1App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            CitiesListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
