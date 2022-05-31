//
//  DocumentRecognitionManager.swift
//  TextToSpeech
//
//  Created by Daniel James Tronca on 31/05/22.
//

import Foundation
import UniformTypeIdentifiers
import Vision
import UIKit

class DocumentRecognitionManager {
    
    static let shared: DocumentRecognitionManager = DocumentRecognitionManager()
    
    func processDocumentUrl(documentUrl: URL, completionHandler: @escaping (_ response: [String]?) -> Void) {
        
        var convertedDocument: [String] = []
        
        if documentUrl.startAccessingSecurityScopedResource() {
            if let images = drawPDFfromURL(url: documentUrl) {
                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                    guard let self = self else { completionHandler(nil); return }
                    images.forEach {
                        if let cgImage = $0.cgImage {
                            self.performRecognition(cgImage: cgImage) { response in
                                convertedDocument.append(contentsOf: response)
                            }
                        }
                    }
                    documentUrl.stopAccessingSecurityScopedResource()
                    completionHandler(convertedDocument)
                }
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
        request.recognitionLevel = VNRequestTextRecognitionLevel.accurate
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
