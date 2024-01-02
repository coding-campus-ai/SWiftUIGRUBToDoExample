//import GRDBQuery
//import Players
import SwiftUI

// MARK: - Give SwiftUI access to the player repository

// Define a new environment key that grants access to a `PlayerRepository`.
//
// The technique is documented at
// <https://developer.apple.com/documentation/swiftui/environmentkey>.
private struct DatabaseKey: EnvironmentKey {
    /// The default appDatabase is an empty in-memory repository.
    static let defaultValue = Database.empty()
}

extension EnvironmentValues {
    var database: Database {
        get { self[DatabaseKey.self] }
        set { self[DatabaseKey.self] = newValue }
    }
}

// MARK: - @Query convenience

// Help views and previews observe the database with the @Query property wrapper.
// See <https://swiftpackageindex.com/groue/grdbquery/documentation/grdbquery/gettingstarted>
extension Query where Request.DatabaseContext == Database {
    /// Creates a `Query`, given an initial `Queryable` request that
    /// uses `PlayerRepository` as a `DatabaseContext`.
    init(_ request: Request) {
        self.init(request, in: \.database)
    }
}
