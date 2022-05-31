//
//  DocumentCollectionViewCell.swift
//  TextToSpeech
//
//  Created by Daniel James Tronca on 31/05/22.
//

import Foundation
import UIKit

class DocumentCollectionViewCell: UICollectionViewCell, Reusable {
    
    struct Configuration {
        let addLabel: String
        let isLoading: Bool
    }
    
    private lazy var stackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
       let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    private lazy var addLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        generateView()
    }
    
    required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
    public func configure(with configuration: Configuration) {
        addLabel.text = configuration.addLabel
        if configuration.isLoading {
            addLabel.isHidden = true
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        } else {
            activityIndicator.isHidden = true
            addLabel.isHidden = false
            activityIndicator.stopAnimating()
        }
    }
    
    private func generateView() {
        contentView.layer.cornerRadius = 16.0
        contentView.clipsToBounds = true
        contentView.layer.borderWidth = 2.0
        contentView.layer.borderColor = UIColor.white.cgColor
        contentView.addSubview(stackView)
        activityIndicator.color = UIColor.red
        [activityIndicator, addLabel].forEach(stackView.addArrangedSubview(_:))
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
}
