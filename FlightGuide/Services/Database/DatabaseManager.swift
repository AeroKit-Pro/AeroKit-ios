//
//  DatabaseManager.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 15.04.2023.
//

import SQLite
import Foundation
import RxSwift
/// 'DatabaseManager' is a static class that manages directory initialization, files copying, local database configuring and connection to it. Consider using wrappers to interact with this class.
final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private(set) var database: Connection? = nil
    
    let airports = Table("airports")
    let runways = Table("runways")
    let frequencies = Table("frequencies")
    
    lazy var joinedTables: Table = {
        airports.join(.leftOuter, runways, on: runwayFields.airportID == airportFields.id)
            .join(.leftOuter, frequencies, on: frequencyFields.airportID == airportFields.id)
    }()
    
    let airportFields = AirportColumns()
    let runwayFields = RunwayColumns()
    let frequencyFields = FrequencyColumns()
    
    private init() {
        connect()
        setupIndexes()
    }
    
    private func connect() {
        do {
            if let dbPath = DatabaseConstants.databasePath {
                assert(FileManager.default.fileExists(atPath: dbPath))
                database = try Connection(dbPath)
                print("SQLiteDataStore init successfully at: \(dbPath) ")
            } else { print("invalid path") }
        } catch {
            database = nil
            print("SQLiteDataStore init error: \(error)")
        }
    }
    
    private func setupIndexes() {
        let queryNameIndex = airports.createIndex(airportFields.name, ifNotExists: true)
        
        guard let database else { return }
        do {
            try database.run(queryNameIndex)
        }
        catch { print("error while creating index: \(error)") }
    }
    
}
