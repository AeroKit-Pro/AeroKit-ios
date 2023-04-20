//
//  DatabaseManager.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 15.04.2023.
//

import SQLite
import Foundation
import RxSwift
// вызовы в бэкграунд, расставить индексы, weak self
final class DatabaseManager {
    
    static let DIR_DB = "DB"
    static let STORE_NAME = "sqlite3"
    private var db: Connection? = nil
    private let apiClient = APIClient()
    private let disposeBag = DisposeBag()
    
    private let airports = Table("airports")
    private let runways = Table("runways")
    private let frequencies = Table("frequencies")
    //MARK: FIELDS
    //airports
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
        if let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let dirPath = docDir.appendingPathComponent(Self.DIR_DB)
            
            do {
                try FileManager.default.createDirectory(atPath: dirPath.path, withIntermediateDirectories: true, attributes: nil)
                let dbPath = dirPath.appendingPathComponent(Self.STORE_NAME).path
                db = try Connection(dbPath)
                print("SQLiteDataStore init successfully at: \(dbPath) ")
            } catch {
                db = nil
                print("SQLiteDataStore init error: \(error)")
            }
        } else {
            db = nil
        }
        createTables()
        downloadBase()
    }
    
    private func createTables() {
        guard let db = self.db else { return }
                
        do {
            try db.run(airports.create(ifNotExists: true) { table in
                table.column(id, primaryKey: true)
                table.column(ident)
                table.column(type)
                table.column(name)
                table.column(latitudeDeg)
                table.column(longitudeDeg)
                table.column(elevationFt)
                table.column(regionCode)
                table.column(municipality)
                table.column(scheduledService)
                table.column(gpsCode)
                table.column(iataCode)
                table.column(localCode)
                table.column(homeLink)
                table.column(wikipediaLink)
                table.column(surfaces)
                table.column(keywords)
            })
            print("\(airports) created or already existed")
        } catch {
            print("error when creating table", error)
        }
        
        do {
            try db.run(runways.create(ifNotExists: true) { table in
                table.column(runway_id, primaryKey: true)
                table.column(airport_id)
                table.column(lengthFt)
                table.column(widthFt)
                table.column(heDisplacedThresholdFt)
                table.column(leElevationFt)
                table.column(leDisplacedThresholdFt)
                table.column(heElevationFt)
                table.column(surface)
                table.column(leIdent)
                table.column(heIdent)
                table.column(lighted)
                table.column(closed)
                table.column(leLatitudeDeg)
                table.column(leLongitudeDeg)
                table.column(leHeadingDegT)
                table.column(heLatitudeDeg)
                table.column(heLongitudeDeg)
                table.column(heHeadingDegT)
                table.foreignKey(airport_id, references: airports, id)
            })
            print("\(runways) created or already existed")
        } catch {
            print("error when creating table", error)
        }
        
        do {
            try db.run(frequencies.create(ifNotExists: true) { table in
                table.column(frequency_id, primaryKey: true)
                table.column(usedByAirport_id)
                table.column(frequency_type)
                table.column(description)
                table.column(frequencyMhz)
                table.foreignKey(usedByAirport_id, references: airports, id)
            })
            print("\(frequencies) created or already existed")
        } catch {
            print("error when creating table", error)
        }
    }
    
    func downloadBase() {
        apiClient.getAirports() // в бэкграунд
            .subscribe(onNext: { $0.items.forEach { airport in
                guard let db = self.db else { return }
                do {
                    try db.run(self.airports.insert(or: .replace, self.id <- airport.id,
                                                         self.ident <- airport.ident,
                                                         self.type <- airport.type,
                                                         self.name <- airport.name,
                                                         self.latitudeDeg <- airport.latitudeDeg,
                                                         self.longitudeDeg <- airport.longitudeDeg,
                                                         self.elevationFt <- airport.elevationFt,
                                                         self.regionCode <- airport.regionCode,
                                                         self.municipality <- airport.municipality,
                                                         self.scheduledService <- airport.scheduledService,
                                                         self.gpsCode <- airport.gpsCode,
                                                         self.iataCode <- airport.iataCode,
                                                         self.localCode <- airport.localCode,
                                                         self.homeLink <- airport.homeLink,
                                                         self.wikipediaLink <- airport.wikipediaLink,
                                                         self.surfaces <- airport.surfaces,
                                                         self.keywords <- airport.keywords))
                } catch {
                    print(error)
                }
            } })
            .disposed(by: disposeBag)
    /*
        apiClient.getRunways() // в бэкграунд
            .subscribe(onNext: { $0.items.forEach { runway in
                guard let db = self.db else { return }
                do {
                    try db.run(self.runways.insert(or: .replace, self.runway_id <- runway.id,
                                                self.airport_id <- runway.airportID,
                                                self.lengthFt <- runway.lengthFt,
                                                self.widthFt <- runway.widthFt,
                                                self.heDisplacedThresholdFt <- runway.heDisplacedThresholdFt,
                                                self.leElevationFt <- runway.leElevationFt,
                                                self.leDisplacedThresholdFt <- runway.leDisplacedThresholdFt,
                                                self.heElevationFt <- runway.heElevationFt,
                                                self.surface <- runway.surface,
                                                self.leIdent <- runway.leIdent,
                                                self.heIdent <- runway.heIdent,
                                                self.lighted <- runway.lighted,
                                                self.closed <- runway.closed,
                                                self.leLatitudeDeg <- runway.leLatitudeDeg,
                                                self.leLongitudeDeg <- runway.leLongitudeDeg,
                                                self.leHeadingDegT <- runway.leHeadingDegT,
                                                self.heLatitudeDeg <- runway.heLatitudeDeg,
                                                self.heLongitudeDeg <- runway.heLongitudeDeg,
                                                self.heHeadingDegT <- runway.heHeadingDegT))
                } catch {
                    print(error)
                }
            } })
            .disposed(by: disposeBag)
        
        apiClient.getFrequencies() // в бэкграунд
            .subscribe(onNext: { $0.items.forEach { frequency in
                guard let db = self.db else { return }
                do {
                    try db.run(self.frequencies.insert(or: .replace, self.frequency_id <- frequency.id,
                                                       self.usedByAirport_id <- frequency.airportID,
                                                       self.frequency_type <- frequency.type,
                                                       self.description <- frequency.description,
                                                       self.frequencyMhz <- frequency.frequencyMhz))
                } catch {
                    print(error)
                }
            } })
            .disposed(by: disposeBag)
        */
    }
     
    
}
