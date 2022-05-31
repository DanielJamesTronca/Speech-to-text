//
//  AddDocumentCollectionViewCell.swift
//  TextToSpeech
//
//  Created by Daniel James Tronca on 31/05/22.
//

import UIKit

class AddDocumentCollectionViewCell: UICollectionViewCell, Reusable {
    
    struct Configuration {
        
    }
    
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
        
    }
    
    private func generateView() {
        contentView.layer.borderWidth = 2.0
        contentView.layer.borderColor = UIColor.white.cgColor
        contentView.addSubview(addLabel)
        NSLayoutConstraint.activate([
            addLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            addLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
}
