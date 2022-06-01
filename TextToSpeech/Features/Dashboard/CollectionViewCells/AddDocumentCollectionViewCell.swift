//
//  AddDocumentCollectionViewCell.swift
//  TextToSpeech
//
//  Created by Daniel James Tronca on 31/05/22.
//

import UIKit

class AddDocumentCollectionViewCell: UICollectionViewCell, Reusable {
    
    struct Configuration {
        let addLabel: String
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
        addLabel.text = configuration.addLabel
    }
    
    private func generateView() {
        contentView.addDashedBorder()
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

extension UIView {
  func addDashedBorder() {
    let color = UIColor.blue.cgColor

    let shapeLayer:CAShapeLayer = CAShapeLayer()
    let frameSize = self.frame.size
    let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)

    shapeLayer.bounds = shapeRect
    shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
    shapeLayer.fillColor = UIColor.clear.cgColor
    shapeLayer.strokeColor = color
    shapeLayer.lineWidth = 1
    shapeLayer.lineJoin = CAShapeLayerLineJoin.round
    shapeLayer.lineDashPattern = [6,2]
    shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).cgPath

    self.layer.addSublayer(shapeLayer)
    }
}
