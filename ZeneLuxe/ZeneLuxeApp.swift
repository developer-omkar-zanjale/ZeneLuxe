//
//  ZeneLuxeApp.swift
//  ZeneLuxe
//
//  Created by Omkar Zanjale on 12/02/24.
//  ZeneLux: derived from the Greek word "Ζήνα" (Zena), meaning "musical" or "of music," and "Luxe" is from French, meaning "luxury" or "high-quality."

import SwiftUI

@main
struct ZeneLuxeApp: App {
    
    @StateObject var coreDataService = CoreDataService()
    
    var body: some Scene {
        WindowGroup {
            if #available(iOS 16.0, *) {
                NavigationStack {
                    SearchMusicView()
                        .environment(\.managedObjectContext, coreDataService.container.viewContext)
                }
            } else {
                NavigationView {
                    SearchMusicView()
                        .environment(\.managedObjectContext, coreDataService.container.viewContext)
                }
            }
        }
    }
}
