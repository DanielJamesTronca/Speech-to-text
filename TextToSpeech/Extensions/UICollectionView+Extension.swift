//
//  UICollectionView+Extension.swift
//  TextToSpeech
//
//  Created by Daniel James Tronca on 31/05/22.
//

import Foundation
import UIKit

// MARK: - UICollectionView
extension UICollectionView {
    
    // MARK: - UICollectionViewCell
    
    /// This method register a Reusable cell
    /// - Parameter cell: Cell type, also used to retrieve the reuse identifier
    func register<T: UICollectionViewCell>(cell: T.Type) where T: Reusable {
        self.register(cell, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    /// This method dequeue a Reusable cell based on the Type given in input
    /// - Parameters:
    ///   - indexPath: The index path that specifies the location of the new supplementary view.
    ///   - type: Type of the given cell
    /// - Returns: The cell dequeued from the collectionView
    func dequeue<T: UICollectionViewCell>(indexPath: IndexPath, type: T.Type = T.self) -> T where T: Reusable {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            preconditionFailure("Cannot dequeue, check if this cell has been registered")
        }
        return cell
    }
}
