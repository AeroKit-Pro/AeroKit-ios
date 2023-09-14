//
//  CalculatorsDataSource.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 06.07.2023.
//

import UIKit

final class CalculatorsDataSource: NSObject, UITableViewDataSource {
    
    private let calculators: [Calculator] = [HeadingWindCorrectionAngleCalculator(), FlightTimeGroundSpeedCalculator(), FuelConsumptionForFlightTimeCalculator(), TrueAirSpeedCalculator()]
    
    private let converters: [Calculator] = [TimeConverter(), TemperatureConverter(), DistanceConverter(), SpeedConverter()]
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return calculators.count
        case 1: return converters.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CalculatorCell()
        cell.model = object(for: indexPath)
        return cell
    }
    
    func object(for indexPath: IndexPath) -> Calculator? {
        switch indexPath.section {
        case 0: return calculators[indexPath.row]
        case 1: return converters[indexPath.row]
        default: return nil
        }
    }
    
}
