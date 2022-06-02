//
//  ConvertedTextBarView.swift
//  TextToSpeech
//
//  Created by Daniel James Tronca on 01/06/22.
//

import UIKit

enum ConvertedTextBarAction {
    case play
    case pause
}

protocol ConvertedTextBarViewDelegate: AnyObject {
    func convertedTextBarViewDidTapMainAction(action: ConvertedTextBarAction)
}

class ConvertedTextBarView: UIView {
    
    private lazy var barStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8.0
        return stackView
    }()
    
    private lazy var barPlayButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "play.circle"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()
    
    private lazy var timerLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "0:00:00"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    weak var delegate: ConvertedTextBarViewDelegate?
    
    private weak var timer: Timer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layout()
    }
    
    private var timerLenght: Int = 0
    
    private func layout() {
        layer.cornerRadius = 16.0
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.systemBlue.cgColor
        backgroundColor = UIColor.systemBlue.withAlphaComponent(0.16)
        clipsToBounds = true
        addSubview(barStackView)
        [barPlayButton, timerLabel].forEach(barStackView.addArrangedSubview(_:))
        barPlayButton.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        NSLayoutConstraint.activate([
            barPlayButton.heightAnchor.constraint(equalToConstant: 40.0),
            barPlayButton.widthAnchor.constraint(equalTo: barPlayButton.heightAnchor),
            barStackView.topAnchor.constraint(equalTo: topAnchor,constant: 4.0),
            barStackView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 16.0),
            barStackView.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -16.0),
            barStackView.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -4.0)
        ])
    }
    
    public func triggerTimer() {
        self.invalidateTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            self.timerLenght += 1
            self.timerLabel.text = Utils.convertToHourMinuteSecondFormat(seconds: self.timerLenght)
        }
    }
    
    public func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc
    private func handleRegister(sender: UIButton) {
        if barPlayButton.imageView?.image == UIImage(systemName: "play.circle") {
            barPlayButton.setImage(UIImage(systemName: "pause.circle"), for: .normal)
            delegate?.convertedTextBarViewDidTapMainAction(action: .play)
        } else {
            barPlayButton.setImage(UIImage(systemName: "play.circle"), for: .normal)
            delegate?.convertedTextBarViewDidTapMainAction(action: .pause)
        }
    }
}
