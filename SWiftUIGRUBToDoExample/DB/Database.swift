//
//  Database.swift
//  SWiftUIGRUBToDoExample
//
//  Created by Jihun Kang on 1/2/24.
//

import Foundation
import GRDB
import os.log

public struct Database {
    public init(_ dbWriter: some GRDB.DatabaseWriter) throws {
        self.dbWriter = dbWriter
        try migrator.migrate(dbWriter)
    }
    
    private let dbWriter: any DatabaseWriter
    
    private var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()
        
#if DEBUG
        migrator.eraseDatabaseOnSchemaChange = true
#endif
        
        migrator.registerMigration("createPlayer") { db in
            // Create a table
            try db.create(table: "player") { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("name", .text).notNull()
                t.column("score", .integer).notNull()
                t.column("photoID", .integer).notNull()
            }
        }
        
        
        return migrator
    }
}

// MARK: - Database Configuration

extension Database {
    private static let sqlLogger = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "SQL")
    
    public static func makeConfiguration(_ base: Configuration = Configuration()) -> Configuration {
        var config = base
        
        if ProcessInfo.processInfo.environment["SQL_TRACE"] != nil {
            config.prepareDatabase { db in
                db.trace {
                    os_log("%{public}@", log: sqlLogger, type: .debug, String(describing: $0))
                }
            }
        }
        
        
        return config
    }
}


extension Database {
    /// Inserts a player and returns the inserted player.
    public func insert(_ player: Player) throws -> Player {
        try dbWriter.write { db in
            try player.inserted(db)
        }
    }
    
    /// Updates the player.
    public func update(_ player: Player) throws {
        try dbWriter.write { db in
            try player.update(db)
        }
    }
    
    /// Deletes all players.
    public func deleteAllPlayer() throws {
        try dbWriter.write { db in
            _ = try Player.deleteAll(db)
        }
    }
}

extension Database {
    /// Provides a read-only access to the database.
    public var reader: any GRDB.DatabaseReader {
        dbWriter
    }
}


