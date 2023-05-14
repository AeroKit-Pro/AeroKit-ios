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
    func fetchPreviewData<RequestedType: Decodable>(_ requestedType: RequestedType.Type,
                                                    input: String,
                                                    filters: AirportFilterSettings?) -> [RequestedType]? {
        // TODO: Separate filtered query construction
        var query = joinedTables
        if let filters {
            if let lenght = filters.minRunwayLength {
                query = query
                    .filter(databaseManager.runwayFields.lengthFt >= lenght)
            }
            if filters.airportTypes.notEmpty {
                query = query
                    .filter(filters.airportTypes.contains(databaseManager.airportFields.type))
            }
            if filters.runwaySurfaces.notEmpty {
                query = query
                    .filter(filters.runwaySurfaces.contains(databaseManager.runwayFields.surface))
            }
            if filters.isEnabledRunwayLight {
                query = query
                    .filter(databaseManager.runwayFields.lighted == filters.isEnabledRunwayLight)
            }
        }
        
        query = query
            .filter(airportNameColumn.lowercaseString.like(SearchPattern.contains(input)))
            .select(databaseManager.airportFields.name,
                    databaseManager.airportFields.type,
                    databaseManager.airportFields.municipality,
                    databaseManager.airportFields.surfaces)
            .group(airportIdColumn)
                
        return try? database?.prepare(query).map { return try $0.decode() }
    }
        
}
