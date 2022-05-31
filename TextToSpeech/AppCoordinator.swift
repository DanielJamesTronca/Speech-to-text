//
//  AppCoordinator.swift
//  TextToSpeech
//
//  Created by Daniel James Tronca on 31/05/22.
//

import Foundation
import UIKit

class AppCoordinator {
    
    private let navigationController = UINavigationController()
    
    private let appManager: AppManager = AppManager()
    
    var rootViewController: UIViewController {
        return navigationController
    }
    
    func start() {
        let configuration = appManager.createDashboardViewControllerConfiguration()
        let viewController: DashboardViewController = DashboardViewController(configuration: configuration)
        viewController.coordinator = self
        viewController.delegate = self
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension AppCoordinator: DashboardViewControllerDelegate {
    func dashboardViewControllerDidTapAddDocument(from dashboardViewController: DashboardViewController) {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.jpeg, .png, .pdf])
        documentPicker.delegate = dashboardViewController
        documentPicker.modalPresentationStyle = .formSheet
        documentPicker.allowsMultipleSelection = false
        dashboardViewController.present(documentPicker, animated: true)
    }
    
    func dashboardViewControllerDidPickDocument(from dashboardViewController: DashboardViewController, documentUrl: URL) {
        let recognitionMangaer: DocumentRecognitionManager = DocumentRecognitionManager.shared
        
        dashboardViewController.configuration.source.insert(
            DashboardCellItem(
                cellConfiguration: .documentCell(
                    configuration: DocumentCollectionViewCell.Configuration(
                        addLabel: documentUrl.lastPathComponent,
                        isLoading: true
                    )
                ),
                cellAction: .none
            ),
            at: 1
        )
        dashboardViewController.collectionView.reloadItems(at: [IndexPath(row: 1, section: 0)])
        
        recognitionMangaer.processDocumentUrl(documentUrl: documentUrl) { [weak dashboardViewController] response in
            DispatchQueue.main.async { [weak dashboardViewController] in
                guard let dashboardViewController = dashboardViewController else { return }
                
                dashboardViewController.configuration.source.remove(at: 1)
                dashboardViewController.configuration.source.insert(DashboardCellItem(cellConfiguration: .documentCell(configuration: DocumentCollectionViewCell.Configuration(addLabel: documentUrl.lastPathComponent, isLoading: false)), cellAction: .none), at: 1)
                dashboardViewController.collectionView.reloadItems(at: [IndexPath(row: 1, section: 0)])
                
                if let response = response, !response.isEmpty {
                    let convertedTextViewController: ConvertedTextViewController = ConvertedTextViewController(text: response)
                    convertedTextViewController.title = documentUrl.lastPathComponent
                    dashboardViewController.navigationController?.pushViewController(convertedTextViewController, animated: true)
                }
            }
        }
    }
}
