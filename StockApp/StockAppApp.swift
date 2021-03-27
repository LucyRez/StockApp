//
//  StockAppApp.swift
//  StockApp
//
//  Created by Ludmila Rezunic on 25.03.2021.
//

import SwiftUI

@main
struct StockAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
