//
//  ViewController.swift
//  TextToSpeech
//
//  Created by Daniel James Tronca on 29/05/22.
//

import UIKit
import UniformTypeIdentifiers
import Vision

class ViewController: UIViewController {
    
    private lazy var mainButton: UIButton = {
        let button = UIButton()
        button.setTitle("Tap this button", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        view.addSubview(mainButton)
        NSLayoutConstraint.activate([
            mainButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        mainButton.addTarget(self, action: #selector(actionWithoutParam), for: .touchUpInside)
    }
    
    @objc func actionWithoutParam(){
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.jpeg, .png, .pdf])
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .overFullScreen
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true)
    }
}

extension ViewController: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        
        var totalResponse: [String] = []
        
        if url.startAccessingSecurityScopedResource() {
            print("Imported url: \(url)")
            if let images = drawPDFfromURL(url: url) {
                images.forEach {
                    guard let cgImage = $0.cgImage else { return }
                    //                    url.stopAccessingSecurityScopedResource()
                    performRecognition(cgImage: cgImage, completionHandler: { response in
                        totalResponse.append(contentsOf: response)
                        //                        let viewController = ConvertedTextViewController(text: response)
                        //                        self.navigationController?.pushViewController(viewController, animated: true)
                    })
                }
                
                let viewController = ConvertedTextViewController(text: totalResponse)
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
    
    func performRecognition(cgImage: CGImage, completionHandler: @escaping (_ response: [String]) -> Void) {
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)
        
        var responseArray: [String] = []
        
        let request = VNRecognizeTextRequest { (request, _) in
            guard let observation = request.results as? [VNRecognizedTextObservation] else { return }
            observation.forEach {
                let topCandidate: [VNRecognizedText] = $0.topCandidates(1)
                if let recognizedText: VNRecognizedText = topCandidate.first {
                    responseArray.append(recognizedText.string)
                }
            }
            completionHandler(responseArray)
        }
        request.recognitionLevel = VNRequestTextRecognitionLevel.fast
        try? requestHandler.perform([request])
    }
    
    func drawPDFfromURL(url: URL) -> [UIImage]? {
        
        guard let document = CGPDFDocument(url as CFURL) else { return nil }
        
        var images: [UIImage] = []
        
        for i in 0...document.numberOfPages {
            if let page = document.page(at: i) {
                let pageRect = page.getBoxRect(.mediaBox)
                let renderer = UIGraphicsImageRenderer(size: pageRect.size)
                let img = renderer.image { ctx in
                    UIColor.white.set()
                    ctx.fill(pageRect)
                    ctx.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
                    ctx.cgContext.scaleBy(x: 1.0, y: -1.0)
                    ctx.cgContext.drawPDFPage(page)
                }
                images.append(img)
            }
        }
        return images
    }
}
