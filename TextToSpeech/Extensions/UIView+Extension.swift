//
//  UIView+Extension.swift
//  TextToSpeech
//
//  Created by Daniel James Tronca on 01/06/22.
//

import Foundation
import UIKit

extension UIView {
    public func addContentView(_ subView: UIView) {
        addSubview(subView)
        NSLayoutConstraint.activate([
            subView.topAnchor.constraint(equalTo: topAnchor),
            subView.bottomAnchor.constraint(equalTo: bottomAnchor),
            subView.leadingAnchor.constraint(equalTo: leadingAnchor),
            subView.trailingAnchor.constraint(equalTo: trailingAnchor)])
    }
}
