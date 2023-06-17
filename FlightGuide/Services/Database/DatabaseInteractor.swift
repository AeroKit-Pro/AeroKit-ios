//
//  DatabaseFetcher.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 28.04.2023.
//

import SQLite
/// 'DatabaseFetcher' is a wrapper for 'DatabaseManager' that fetches data from local database. An instance of this class provides the needed API to retrieve records from database with filter parameters.
final class DatabaseInteractor {
        
    private let databaseManager = DatabaseManager.shared
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
    /// should be used to fetch the most basic 'preview' information as the size of generic parameter hugely affects perfomance
    func fetchPreviewData<RequestedType: Decodable>(_ requestedType: RequestedType.Type,
                                                    input: String,
                                                    filters: AirportFilterSettings) -> [RequestedType]? {
        // TODO: Separate filtered query construction
        var query = joinedTables
        
        applyFilterSettingsToQuery(query: &query, filters: filters)
        
        query = query
            .filter(databaseManager.airportFields.name.lowercaseString.like(SearchPattern.contains(input))
                    || databaseManager.airportFields.municipality.like(SearchPattern.contains(input))
                    || databaseManager.airportFields.iataCode.like(SearchPattern.contains(input))
                    || databaseManager.airportFields.ident.like(SearchPattern.contains(input)))
            .select(databaseManager.airportFields.name,
                    databaseManager.airportFields.type,
                    databaseManager.airportFields.municipality,
                    databaseManager.airportFields.surfaces,
                    databaseManager.airportFields.id,
                    databaseManager.airportFields.isFavorite)
            .group(databaseManager.airportFields.id)
        
        return try? database?.prepare(query).map { return try $0.decode() }
    }
    
    func fetchAirportsByCity<RequestedType: Decodable>(_ requestedType: RequestedType.Type,
                                               input: String,
                                               filters: AirportFilterSettings) -> [RequestedType]? {
        var query = joinedTables
        
        applyFilterSettingsToQuery(query: &query, filters: filters)
        
        query = query
            .filter(databaseManager.airportFields.municipality.like(SearchPattern.startsWith(input)))
            .group(databaseManager.airportFields.id)
            .select(databaseManager.airportFields.id,
                    databaseManager.airportFields.type,
                    databaseManager.airportFields.municipality)
        
        return try? database?.prepare(query).map { return try $0.decode() }
    }
    
    func fetchAirportCoordinate<RequestedType: Decodable>(_ requestedType: RequestedType.Type, by id: Int) -> RequestedType? {
        let query = databaseManager.airports
            .filter(databaseManager.airportFields.id == id)
            .select(databaseManager.airportFields.latitudeDeg,
                    databaseManager.airportFields.longitudeDeg)
        
        return try? database?.prepare(query).map { return try $0.decode() }.first
    }
    
    // TODO: Temporary solution. Need to understand how to parse such query results properly
    func fetchAirport(by id: Int) -> [Airport]? {
        let query = airportTable
            .filter(databaseManager.airportFields.id == id)
        
        return try? database?.prepare(query).map { return try $0.decode() }
    }
    
    func fetchRunways(by id: Int) -> [Runway]? {
        let query = databaseManager.runways
            .filter(databaseManager.runwayFields.airportID == id)
        
        return try? database?.prepare(query).map { return try $0.decode() }
    }
    
    func fetchFrequencies(by id: Int) -> [Frequency]? {
        let query = databaseManager.frequencies
            .filter(databaseManager.frequencyFields.airportID == id)
        
        return try? database?.prepare(query).map { return try $0.decode() }
    }
    
    func fetchFavorites() -> [AirportPreview]? {
        let query = databaseManager.airports
            .filter(databaseManager.airportFields.isFavorite)
        
        return try? database?.prepare(query).map { return try $0.decode() }
    }
    // MARK: in case if there are more updatable rows, a more generic function will be implemented
    /// Updates "isFavorite" column in "Airports table".
    /// - Parameters: value: Bool - new value, id: Int - row id
    /// - Returns: true if succes, false if updating failed
    func markAirportAsFavorite(_ value: Bool, id rowId: Int) -> Bool {
        let query = databaseManager.airports
            .filter(databaseManager.airportFields.id == rowId)
            .update(databaseManager.airportFields.isFavorite <- value)
        do { try database?.run(query) }
        catch { print("row by id \(rowId) value update failed"); return false }
        return true
    }
    
    private func applyFilterSettingsToQuery(query: inout Table, filters: AirportFilterSettings) {
        if let length = filters.minRunwayLength {
            query = query
                .filter(databaseManager.runwayFields.lengthFt >= length)
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
    
}
