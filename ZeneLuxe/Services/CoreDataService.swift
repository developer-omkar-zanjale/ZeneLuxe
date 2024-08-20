//
//  CoreDataService.swift
//  ZeneLuxe
//
//  Created by Omkar Zanjale on 20/02/24.
//

import Foundation
import CoreData

class CoreDataService: ObservableObject {
    let container = NSPersistentContainer(name: "CoreDataModel")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                printLog("Core Data Error: \(error.localizedDescription)")
            }
        }
    }
}
