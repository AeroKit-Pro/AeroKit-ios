//
//  Float.swift
//  FlightGuide
//
//  Created by Vanya Bogdantsev on 06.07.2023.
//

extension Float {
    func degreesToRadians() -> Float {
        return self * .pi / 180.0
    }
    
    func radiansToDegrees() -> Float {
        return self * 180.0 / .pi
    }
}

extension Float {
    func toTimeString() -> String {
        let totalSeconds = Int(self * 3600)
        
        let hoursString = String(format: "%02d", totalSeconds / 3600)
        let minutesString = String(format: "%02d", (totalSeconds % 3600) / 60)
        let secondsString = String(format: "%02d", totalSeconds % 60)
        
        return "\(hoursString):\(minutesString):\(secondsString)"
    }
}
