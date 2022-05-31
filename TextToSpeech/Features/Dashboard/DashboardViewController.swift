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
        collectionView.backgroundColor = UIColor.black
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Speech to text"
        layout()
    }
    
    public func configure(with configuration: Configuration) {
        self.configuration = configuration
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
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
        return UIEdgeInsets(top: .zero, left: 16.0, bottom: .zero, right: 16.0)
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
        delegate?.dashboardViewControllerDidPickDocument(from: self, documentUrl: url)
    }
}
