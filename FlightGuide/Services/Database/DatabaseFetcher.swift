//
//  DatabaseFetcher.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 28.04.2023.
//

import SQLite

final class DatabaseFetcher {
    
    private let databaseManager = DatabaseManager()
    private var database: Connection? {
        databaseManager.database
    }
    
    private var airportTable: Table {
        databaseManager.airports
    }
    
    private var joinedTables: Table {
        databaseManager.joinedTables
    }
    
    private var airportNameColumn: Expression<String?> {
        databaseManager.airportFields.name
    }
    
    private var airportIdColumn: Expression<Int> {
        databaseManager.airportFields.id
    }
    // MARK: "filter" to be substituded by a filtered request struct
    
    func fetchPreviewData<RequestedType: Decodable>(filter: String) -> [RequestedType]? {
        let query = airportTable.filter(airportNameColumn.like("%\(filter)%")) // search pattern
        return try? database?.prepare(query).map { try $0.decode() }
    }
    
}
