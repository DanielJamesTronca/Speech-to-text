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
        let content: String?
        let title: String?
        let date: String
        let isLoading: Bool
    }
    
    private lazy var containerStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 4.0
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private lazy var mainView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
       let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    private lazy var contentLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: 6.0)
        label.numberOfLines = 20
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor.gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "folder.fill")
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        generateView()
    }
    
    required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
    public func configure(with configuration: Configuration) {
        titleLabel.text = configuration.title ?? ""
        dateLabel.text = "12/13/12"
        contentLabel.text = configuration.content ?? ""
        if configuration.isLoading {
            contentLabel.isHidden = true
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        } else {
            activityIndicator.isHidden = true
            contentLabel.isHidden = false
            activityIndicator.stopAnimating()
        }
    }
    
    private func generateView() {
        contentView.backgroundColor = UIColor.appBackgroundColor
        contentView.addSubview(containerStackView)
        
        mainView.backgroundColor = UIColor.black
        mainView.layer.cornerRadius = 16.0
        mainView.clipsToBounds = true
        
        [mainView, titleLabel, dateLabel].forEach(containerStackView.addArrangedSubview(_:))
        
        mainView.addSubview(stackView)
        activityIndicator.color = UIColor.red
        [activityIndicator, contentLabel].forEach(stackView.addArrangedSubview(_:))
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 8.0),
            stackView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 8.0),
            stackView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -8.0),
            stackView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -8.0),
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
}
