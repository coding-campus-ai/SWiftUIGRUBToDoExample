//
//  Database+App.swift
//  SWiftUIGRUBToDoExample
//
//  Created by Jihun Kang on 1/2/24.
//

import Foundation
import GRDB

//Database+App
// A `Database` extension for creating various repositories for the
// app, tests, and previews.
extension Database {
    /// The on-disk repository for the application.
    static let shared = makeShared()
    
    /// Returns an on-disk repository for the application.
    private static func makeShared() -> Database {
        do {
            // Apply recommendations from
            // <https://swiftpackageindex.com/groue/grdb.swift/documentation/grdb/databaseconnections>
            //
            // Create the "Application Support/Database" directory if needed
            let fileManager = FileManager.default
            let appSupportURL = try fileManager.url(
                for: .applicationSupportDirectory, in: .userDomainMask,
                appropriateFor: nil, create: true)
            let directoryURL = appSupportURL.appendingPathComponent("Database", isDirectory: true)
            try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)

            // Open or create the database
            let databaseURL = directoryURL.appendingPathComponent("db.sqlite")
            NSLog("Database stored at \(databaseURL.path)")
            let dbPool = try DatabasePool(
                path: databaseURL.path,
                // Use default Database configuration
                configuration: Database.makeConfiguration())

            // Create the Database
            let database = try Database(dbPool)
            
            return database
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate.
            //
            // Typical reasons for an error here include:
            // * The parent directory cannot be created, or disallows writing.
            // * The database is not accessible, due to permissions or data protection when the device is locked.
            // * The device is out of space.
            // * The database could not be migrated to its latest schema version.
            // Check the error message to determine what the actual problem was.
            fatalError("Unresolved error \(error)")
        }
    }
    
    /// Returns an empty in-memory repository, for previews and tests.
    static func empty() -> Database {
        try! Database(DatabaseQueue(configuration: Database.makeConfiguration()))
    }
    
    /// Returns an in-memory repository that contains one player,
    /// for previews and tests.
    ///
    /// - parameter playerId: The ID of the inserted player.
    static func populated(playerId: Int64? = nil) -> Database {
        let repo = self.empty()
        _ = try! repo.insert(Player.makeRandom(id: playerId))
        return repo
    }
}
