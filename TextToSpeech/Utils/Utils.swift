//
//  Utils.swift
//  TextToSpeech
//
//  Created by Daniel James Tronca on 02/06/22.
//

import Foundation

class Utils {
    public static func convertToHourMinuteSecondFormat(seconds: Int) -> String {
        let hour = "\((seconds % 86400) / 3600)"
        let minutes = "\((seconds % 3600) / 60)"
        let seconds = "\((seconds % 3600) % 60)"
        let minuteStamp = minutes.count > 1 ? minutes : "0" + minutes
        let secondStamp = seconds.count > 1 ? seconds : "0" + seconds
        return "\(hour):\(minuteStamp):\(secondStamp)"
    }
}
