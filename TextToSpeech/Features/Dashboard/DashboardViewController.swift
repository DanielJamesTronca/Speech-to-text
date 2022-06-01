//
//  ViewController.swift
//  TextToSpeech
//
//  Created by Daniel James Tronca on 29/05/22.
//

import UIKit

protocol DashboardViewControllerDelegate: AnyObject {
    func dashboardViewControllerDidTapAddDocument(from dashboardViewController: DashboardViewController)
    func dashboardViewControllerDidPickDocument(from dashboardViewController: DashboardViewController, documentUrl: URL)
    func dashboardViewControllerDidTapDocument(from dashboardViewController: DashboardViewController, document: DocumentData)
}

class DashboardViewController: UIViewController {
    
    struct Configuration {
        var source: [DashboardCellItem]
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
    
    var configuration: Configuration {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16.0
        layout.minimumInteritemSpacing = 16.0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.appBackgroundColor
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.appBackgroundColor
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Speech to text"
        layout()
    }
    
    public func configure(with configuration: Configuration) {
        self.configuration = configuration
    }
    
    public func addNewDocument(documentConfiguration: DashboardCellItem) {
        configuration.source.insert(documentConfiguration, at: 1)
        collectionView.reloadItems(at: [IndexPath(row: 1, section: 0)])
    }
    
    public func removeNewDocument() {
        configuration.source.remove(at: 1)
    }
    
    private func layout() {
        // Configure collection view
        collectionView.delegate = self
        collectionView.dataSource = self
        // Configure constraints
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        // Register cell
        collectionView.register(cell: AddDocumentCollectionViewCell.self)
        collectionView.register(cell: DocumentCollectionViewCell.self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
}

extension DashboardViewController: UICollectionViewDelegate {
    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch configuration.source[indexPath.row].cellAction {
        case .didTapAdd:
            delegate?.dashboardViewControllerDidTapAddDocument(from: self)
        case .didTapDocument(document: let document):
            self.delegate?.dashboardViewControllerDidTapDocument(from: self, document: document)
        case .none:
            break
        }
    }
}

extension DashboardViewController: UICollectionViewDataSource {
    
    func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return configuration.source.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch configuration.source[indexPath.row].cellConfiguration {
        case .addDocumentCell(configuration: let configuration):
            let cell = collectionView.dequeue(indexPath: indexPath) as AddDocumentCollectionViewCell
            cell.configure(with: configuration)
            return cell
        case .documentCell(configuration: let configuration):
            let cell = collectionView.dequeue(indexPath: indexPath) as DocumentCollectionViewCell
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
        let collectionViewSize = collectionView.frame.size.width - 65.0
        return CGSize(width: collectionViewSize/3, height: 196)
    }
}

extension DashboardViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        delegate?.dashboardViewControllerDidPickDocument(from: self, documentUrl: url)
    }
}
