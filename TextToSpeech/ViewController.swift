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
    
    func clickFunction() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.jpeg, .png, .pdf])
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .overFullScreen
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true)
    }
    
    private lazy var mainButton: UIButton = {
        let button = UIButton()
        button.setTitle("Ciao", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.blue, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
        view.addSubview(mainButton)
        NSLayoutConstraint.activate([
            mainButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        mainButton.addTarget(self, action: #selector(actionWithoutParam), for: .touchUpInside)
    }
    
    @objc func actionWithoutParam(){
        self.clickFunction()
    }
}

extension ViewController: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        if url.startAccessingSecurityScopedResource() {
            print("import result : \(url)")
            if let image = drawPDFfromURL(url: url), let cgImage = image.cgImage {
                url.stopAccessingSecurityScopedResource()
                performRecognition(cgImage: cgImage, completionHandler: { response in
                    print(response)
                })
            }
        }
    }
    
    func performRecognition(cgImage: CGImage, completionHandler: @escaping (_ response: [String]) -> Void) {
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)
        
        var responseArray: [String] = []
        
        let request = VNRecognizeTextRequest { (request, _) in
            guard let obs = request.results as? [VNRecognizedTextObservation]
            else { return }

            for observation in obs {
                let topCan: [VNRecognizedText] = observation.topCandidates(1)

                if let recognizedText: VNRecognizedText = topCan.first {
                    responseArray.append(recognizedText.string)
                }
            }
            completionHandler(responseArray)
        }
        request.recognitionLevel = VNRequestTextRecognitionLevel.fast
        try? requestHandler.perform([request])
    }

    func drawPDFfromURL(url: URL) -> UIImage? {
        
        guard let document = CGPDFDocument(url as CFURL) else {
            return nil
        }
        guard let page = document.page(at: 1) else {
            return nil
        }

        let pageRect = page.getBoxRect(.mediaBox)
        let renderer = UIGraphicsImageRenderer(size: pageRect.size)
        let img = renderer.image { ctx in
            UIColor.white.set()
            ctx.fill(pageRect)

            ctx.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
            ctx.cgContext.scaleBy(x: 1.0, y: -1.0)

            ctx.cgContext.drawPDFPage(page)
        }

        return img
    }
}
