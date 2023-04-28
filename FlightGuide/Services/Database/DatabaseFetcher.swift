//
//  DatabaseFetcher.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 28.04.2023.
//

import SQLite
/// 'DatabaseFetcher' is a wrapper for 'DatabaseManager' that fetches data from local database. An instance of this class provides the needed API to retrieve records from database with filter parameters.
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
    // TODO: "filter" to be substituded by a filtered request struct
    /// should be used to fetch the most basic 'preview' information as the size of generic parameter hugely affects perfomance
    func fetchPreviewData<RequestedType: Decodable>(filter: String) -> [RequestedType]? {
        let query = airportTable.filter(airportNameColumn.like(SearchPattern.contains(filter)))
        return try? database?.prepare(query).map { try $0.decode() }
    }
        
}
