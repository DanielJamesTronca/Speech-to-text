//
//  ViewController.swift
//  TextToSpeech
//
//  Created by Daniel James Tronca on 29/05/22.
//

import UIKit
import UniformTypeIdentifiers
import Vision

protocol DashboardViewControllerDelegate: AnyObject {
    func dashboardViewControllerDidTapAddDocument(from dashboardViewController: DashboardViewController)
}

class DashboardViewController: UIViewController {
    
    struct Configuration {
        let source: [(header: String, cells: [DashboardCellItem])]
    }
    
    init(configuration: Configuration) {
        self.configuration = configuration
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var delegate: DashboardViewControllerDelegate?
    
    var coordinator: AppCoordinator?
    
    private let configuration: Configuration
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16.0
        layout.minimumInteritemSpacing = 16.0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.black
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        title = "Speech to text"
        layout()
    }
    
    private func layout() {
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        collectionView.register(cell: AddDocumentCollectionViewCell.self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
}

extension DashboardViewController: UICollectionViewDelegate {
    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch configuration.source[indexPath.section].cells[indexPath.row].cellAction {
        case .didTapAdd:
            delegate?.dashboardViewControllerDidTapAddDocument(from: self)
        case .none:
            break
        }
    }
}

extension DashboardViewController: UICollectionViewDataSource {
    func numberOfSections(in _: UICollectionView) -> Int {
        return configuration.source.count
    }
    
    func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return configuration.source[section].cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch configuration.source[indexPath.section].cells[indexPath.row].cellConfiguration {
        case .addDocumentCell(configuration: let configuration):
            let cell = collectionView.dequeue(indexPath: indexPath) as AddDocumentCollectionViewCell
            cell.configure(with: configuration)
            return cell
        }
    }
}

extension DashboardViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _: UICollectionView,
        layout _: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout _: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let padding: CGFloat = 16.0
        let collectionViewSize = collectionView.frame.size.width - padding - 32.0
        return CGSize(width: collectionViewSize/2, height: 128)
    }
}

extension DashboardViewController: UIDocumentPickerDelegate {
    
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
