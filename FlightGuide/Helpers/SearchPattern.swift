//
//  SearchPattern.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 29.04.2023.
//
/// 'SearchPattern' is used to construct filter expressions for SQLite queries
struct SearchPattern {
    static func startsWith(_ string: String) -> String {
        "\(string)%"
    }
    
    static func endsWith(_ string: String) -> String {
        "%\(string)"
    }
    
    static func contains(_ string: String) -> String {
        "%\(string)%"
    }
}
