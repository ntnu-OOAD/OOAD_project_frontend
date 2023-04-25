//
//  bookkeepingApp.swift
//  bookkeeping
//
//  Created by 張凱博 on 2023/3/30.
//

import SwiftUI

@main
struct bookkeepingApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            LoginView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
