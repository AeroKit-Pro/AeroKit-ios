//
//  DatabaseManager.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 15.04.2023.
//

import SQLite
import Foundation
import RxSwift

final class DatabaseManager {
    
    private let apiClient = APIClient()
    private let disposeBag = DisposeBag()
    
    private var db: Connection? = nil
    
    private let airports = Table("airports")
    private let runways = Table("runways")
    private let frequencies = Table("frequencies")
    // fields:
    // airports
    private let id = Expression<Int>("id")
    private let ident = Expression<String?>("ident")
    private let type = Expression<String?>("type")
    private let name = Expression<String?>("name")
    private let latitudeDeg = Expression<Double?>("latitudeDeg")
    private let longitudeDeg = Expression<Double?>("longitudeDeg")
    private let elevationFt = Expression<Int?>("elevationFt")
    private let regionCode = Expression<String?>("regionCode")
    private let municipality = Expression<String?>("municipality")
    private let scheduledService = Expression<String?>("scheduledService")
    private let gpsCode = Expression<String?>("gpsCode")
    private let iataCode = Expression<String?>("iataCode")
    private let localCode = Expression<String?>("localCode")
    private let homeLink = Expression<String?>("homeLink")
    private let wikipediaLink = Expression<String?>("wikipediaLink")
    private let surfaces = Expression<String?>("surfaces")
    private let keywords = Expression<String?>("keywords")
    
    // runways
    private let runway_id = Expression<Int>("runway_id")
    private let airport_id = Expression<Int?>("airport_id")
    private let lengthFt = Expression<Int?>("lengthFt")
    private let widthFt = Expression<Int?>("widthFt")
    private let heDisplacedThresholdFt = Expression<Int?>("heDisplacedThresholdFt")
    private let leElevationFt = Expression<Int?>("leElevationFt")
    private let leDisplacedThresholdFt = Expression<Int?>("leDisplacedThresholdFt")
    private let heElevationFt = Expression<Int?>("heElevationFt")
    private let surface = Expression<String?>("surface")
    private let leIdent = Expression<String?>("leIdent")
    private let heIdent = Expression<String?>("heIdent")
    private let lighted = Expression<Bool?>("lighted")
    private let closed = Expression<Bool?>("closed")
    private let leLatitudeDeg = Expression<Double?>("leLatitudeDeg")
    private let leLongitudeDeg = Expression<Double?>("leLongitudeDeg")
    private let leHeadingDegT = Expression<Double?>("leHeadingDegT")
    private let heLatitudeDeg = Expression<Double?>("heLatitudeDeg")
    private let heLongitudeDeg = Expression<Double?>("heLongitudeDeg")
    private let heHeadingDegT = Expression<Double?>("heHeadingDegT")
    
    // frequencies
    private let frequency_id = Expression<Int>("frequency_id")
    private let usedByAirport_id = Expression<Int?>("usedByAirport_id")
    private let frequency_type = Expression<String?>("frequency_type")
    private let description = Expression<String?>("description")
    private let frequencyMhz = Expression<Double?>("frequencyMhz")
    
    init() {
        connect()
    }
    
    private func connect() {
        do {
            if let dbPath = DatabaseConstants.databasePath {
                assert(FileManager.default.fileExists(atPath: dbPath))
                db = try Connection(dbPath)
                print("SQLiteDataStore init successfully at: \(dbPath) ")
            } else { print("invalid path") }
        } catch {
            db = nil
            print("SQLiteDataStore init error: \(error)")
        }
    }
    // Creates directory. Should be called outside the class
    static func initDirectory() {
        if let dirPath = DatabaseConstants.documentsDirectoryPath {
            do {
                try FileManager.default.createDirectory(atPath: dirPath.path,
                                                        withIntermediateDirectories: true)
            } catch { print("failed to init directory", error) }
        }
    }
    // Copies existing base from bundle. Should be called outside the class. Will fail assertion if previuous method was not called or base was not found in bundle
    static func copyExistingDatabase() {
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
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
}
