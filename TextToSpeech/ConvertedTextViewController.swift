//
//  ConvertedTextViewController.swift
//  TextToSpeech
//
//  Created by Daniel James Tronca on 30/05/22.
//

import UIKit
import AVFoundation

class ConvertedTextViewController: UIViewController {
    
    init(text: [String]) {
        self.convertedText = text
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var convertedText: [String] = []
    
    var spokenTextLengths: Int = 0
    
    var previousSelectedRange: NSRange!
    
    var totalUtterances: Int! = 0
    
    var currentUtterance: Int! = 0
    
    private let synthesizer = AVSpeechSynthesizer()
    
    private lazy var textView: UITextView = {
        let textView: UITextView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 24.0)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readText()
        view.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.topAnchor),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        textView.text = convertedText.joined(separator: "\n")
        textView.setContentOffset(.zero, animated: false)
        textView.layoutIfNeeded()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        synthesizer.stopSpeaking(at: .immediate)
    }
    
    private func readText() {
        let singleString = convertedText.joined(separator: "\n")
        let utterance = AVSpeechUtterance(string: singleString)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        utterance.rate = 0.4
        synthesizer.delegate = self
        synthesizer.speak(utterance)
        
    }
}

extension ConvertedTextViewController: AVSpeechSynthesizerDelegate {
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        
        // Determine the current range in the whole text (all utterances), not just the current one.
        let rangeInTotalText = NSMakeRange(spokenTextLengths + characterRange.location, characterRange.length)
        
        // Select the specified range in the textfield.
        textView.selectedRange = rangeInTotalText
        
        // Store temporarily the current font attribute of the selected text.
        let currentAttributes = textView.attributedText.attributes(at: rangeInTotalText.location, effectiveRange: nil)
        let fontAttribute: AnyObject? = currentAttributes[NSAttributedString.Key.font] as AnyObject
        // Assign the selected text to a mutable attributed string.
        let attributedString = NSMutableAttributedString(string: textView.attributedText.attributedSubstring(from: rangeInTotalText).string)
        
        // Make the text of the selected area orange by specifying a new attribute.
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue, range: NSMakeRange(0, attributedString.length))
        
        // Make sure that the text will keep the original font by setting it as an attribute.
        attributedString.addAttribute(NSAttributedString.Key.font, value: fontAttribute!, range: NSMakeRange(0, attributedString.string.count))
        
//        textView.scrollRangeToVisible(rangeInTotalText)
        
        // Begin editing the text storage.
        textView.textStorage.beginEditing()
        
        // Replace the selected text with the new one having the orange color attribute.
        textView.textStorage.replaceCharacters(in: rangeInTotalText, with: attributedString)
        
        // If there was another highlighted word previously (orange text color), then do exactly the same things as above and change the foreground color to black.
        if let previousRange = previousSelectedRange {
            let previousAttributedText = NSMutableAttributedString(string: textView.attributedText.attributedSubstring(from: previousRange).string)
            previousAttributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(0, previousAttributedText.length))
            previousAttributedText.addAttribute(NSAttributedString.Key.font, value: fontAttribute!, range: NSMakeRange(0, previousAttributedText.length))
            
            textView.textStorage.replaceCharacters(in: previousRange, with: previousAttributedText)
        }
        
        // End editing the text storage.
        textView.textStorage.endEditing()
        
        previousSelectedRange = rangeInTotalText
    }
    
    func unselectLastWord() {
        if let selectedRange = previousSelectedRange {
            // Get the attributes of the last selected attributed word.
            let currentAttributes = textView.attributedText.attributes(at: selectedRange.location, effectiveRange: nil)
            // Keep the font attribute.
            let fontAttribute: AnyObject? = currentAttributes[NSAttributedString.Key.font] as AnyObject
            
            // Create a new mutable attributed string using the last selected word.
            let attributedWord = NSMutableAttributedString(string: textView.attributedText.attributedSubstring(from: selectedRange).string)
            
            // Set the previous font attribute, and make the foreground color black.
            attributedWord.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(0, attributedWord.length))
            attributedWord.addAttribute(NSAttributedString.Key.font, value: fontAttribute!, range: NSMakeRange(0, attributedWord.length))
            
            // Update the text storage property and replace the last selected word with the new attributed string.
            textView.textStorage.beginEditing()
            textView.textStorage.replaceCharacters(in: selectedRange, with: attributedWord)
            textView.textStorage.endEditing()
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        if currentUtterance == totalUtterances {
            unselectLastWord()
            previousSelectedRange = nil
        }
    }
}
