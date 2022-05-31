//
//  Reusable.swift
//  TextToSpeech
//
//  Created by Daniel James Tronca on 31/05/22.
//

import Foundation

// MARK: - Reusable
protocol Reusable {
    /// String that will be used as a implicit reuseIdentifier
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
