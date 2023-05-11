//
//  Database.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 26.04.2023.
//

import Foundation

enum DatabaseConstants {
    static let dbResourcePath = Bundle.main.path(forResource: "aerokit_database", ofType: "sqlite")
    
    static let databaseDirectoryName = "database_directory"
    
    static let databaseStoreName = "aerokit_database"
    
    static let documentsDirectoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(Self.databaseDirectoryName)
    
    static let databasePath = Self.documentsDirectoryPath?.appendingPathComponent(Self.databaseStoreName).path
}
