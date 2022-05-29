//
//  ViewController.swift
//  TextToSpeech
//
//  Created by Daniel James Tronca on 29/05/22.
//

import UIKit
import PDFKit

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers
import Vision

class ViewController: UIViewController, UIDocumentMenuDelegate, UIDocumentPickerDelegate,UINavigationControllerDelegate {
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        print("import result : \(myURL)")
        if let image = drawPDFfromURL(url: myURL), let cgImage = image.cgImage {
            performRecognition(cgImage: cgImage)
        }
        
//        if let pdf = PDFDocument(url: myURL) {
//            let pageCount = pdf.pageCount
//            let documentContent = NSMutableAttributedString()
//
//            for i in 0 ..< pageCount {
//                guard let page = pdf.page(at: i) else { continue }
//                guard let pageContent = page.attributedString else { continue }
//                documentContent.append(pageContent)
//            }
//        }
    }
    
    func performRecognition(cgImage: CGImage) {
        // Create a new image-request handler.
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)
        let request = VNRecognizeTextRequest { (request, _) in
            guard let obs = request.results as? [VNRecognizedTextObservation]
            else { return }
            
            for observation in obs {
                let topCan: [VNRecognizedText] = observation.topCandidates(1)
                
                if let recognizedText: VNRecognizedText = topCan.first {
                    //                            label.text = recognizedText.string
                }
            }
        }
        request.recognitionLevel = VNRequestTextRecognitionLevel.fast
        try? requestHandler.perform([request])
    }
    
    func drawPDFfromURL(url: URL) -> UIImage? {
        guard let document = CGPDFDocument(url as CFURL) else { return nil }
        guard let page = document.page(at: 1) else { return nil }

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
    
    
    public func documentMenu(_ documentMenu:UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
    
    func clickFunction(){
        
        let documentPicker = UIDocumentMenuViewController(documentTypes: [String(kUTTypePDF)], in: .import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        self.present(documentPicker, animated: true, completion: nil)
    }
    
    
    func selectFiles() {
        let types = UTType.types(
            tag: "json",
                                 tagClass: UTTagClass.filenameExtension,
                                 conformingTo: nil
        )
        let documentPickerController = UIDocumentPickerViewController(
            forOpeningContentTypes: types)
        documentPickerController.delegate = self
        self.present(documentPickerController, animated: true, completion: nil)
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
    
    private func createPdfView(withFrame frame: CGRect) -> PDFView {
        let pdfView = PDFView(frame: frame)
        pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        pdfView.autoScales = true
        return pdfView
    }
    
    private func displayPdf() {
        let pdfView = self.createPdfView(withFrame: self.view.bounds)
        
        if let pdfDocument = self.createPdfDocument(forFileName: "BEMF1") {
            self.view.addSubview(pdfView)
            pdfView.document = pdfDocument
        }
    }
    
    private func resourceUrl(forFileName fileName: String) -> URL? {
        if let resourceUrl = Bundle.main.url(
            forResource: fileName,
            withExtension: "pdf"
        ) {
            return resourceUrl
        }
        
        return nil
    }
    
    private func createPdfDocument(forFileName fileName: String) -> PDFDocument? {
        if let resourceUrl = self.resourceUrl(forFileName: fileName) {
            return PDFDocument(url: resourceUrl)
        }
        
        return nil
    }
    
}

