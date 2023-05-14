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
    
    static func prepare() {
        initDirectory()
        copyExistingDatabase()
    }
    // Creates directory. Should be called outside the class
    private static func initDirectory() {
        if let dirPath = DatabaseConstants.documentsDirectoryPath {
            do {
                try FileManager.default.createDirectory(atPath: dirPath.path,
                                                        withIntermediateDirectories: true)
            } catch { print("failed to init directory: \(error)") }
        }
    }
    // Copies existing base from bundle. Should be called outside the class. Will fail assertion if previuous method was not called or base was not found in bundle
    private static func copyExistingDatabase() {
        let fileManager = FileManager.default
        if let dirPath = DatabaseConstants.documentsDirectoryPath {
            assert(fileManager.fileExists(atPath: dirPath.path), "directory should be created beforehand")
        }
        
        if let dbPath = DatabaseConstants.databasePath {
            if !fileManager.fileExists(atPath: dbPath) {
                if let dbResourcePath = DatabaseConstants.dbResourcePath {
                    do {
                        try fileManager.copyItem(atPath: dbResourcePath, toPath: dbPath)
                    } catch {
                        print("error while copying sqlite file: \(error)")
                    }
                }
            }
        }
    }
    
    private(set) var database: Connection? = nil
    
    let airports = Table("airports")
    let runways = Table("runways")
    let frequencies = Table("frequencies")
    
    lazy var joinedTables: Table = {
        airports.join(.leftOuter, runways, on: runwayFields.airport_id == airportFields.id)
            .join(.leftOuter, frequencies, on: frequencyFields.usedByAirport_id == airportFields.id)
    }()
    
    let airportFields = AirportFields()
    let runwayFields = RunwayFields()
    let frequencyFields = FrequencyFields()
    
    init() {
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
        let queryLengthFtIndex = runways.createIndex(runwayFields.lengthFt, ifNotExists: true)
        
        guard let database else { return }
        do {
            try database.run(queryNameIndex)
            try database.run(queryLengthFtIndex)
        }
        catch { print("error while creating index: \(error)") }
    }
    
}
