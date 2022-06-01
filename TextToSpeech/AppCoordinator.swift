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
        DocumentStorage.shared.getDocuments { documents in
            let configuration = self.appManager.createDashboardViewControllerConfiguration(documents: documents)
            let viewController: DashboardViewController = DashboardViewController(configuration: configuration)
            viewController.coordinator = self
            viewController.delegate = self
            self.navigationController.pushViewController(viewController, animated: true)
        }
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
        dashboardViewController.addNewDocument(
            documentConfiguration: appManager.createDashboardViewControllerNewDocumentConfiguration(
                documentName: documentUrl.lastPathComponent,
                isLoading: true
            )
        )
        recognitionMangaer.processDocumentUrl(documentUrl: documentUrl) { [weak dashboardViewController] document in
            DispatchQueue.main.async { [weak dashboardViewController, weak self] in
                guard let self = self, let dashboardViewController = dashboardViewController else { return }
                dashboardViewController.removeNewDocument()
                dashboardViewController.addNewDocument(
                    documentConfiguration: self.appManager.createDashboardViewControllerNewDocumentConfiguration(
                        documentName: documentUrl.lastPathComponent,
                        isLoading: false,
                        content: document?.content
                    )
                )
                if let document = document {
                    DocumentStorage.shared.saveDocument(document: document) { [weak dashboardViewController] success in
                        guard let dashboardViewController = dashboardViewController else { return }
                        if success {
                            let convertedTextViewController: ConvertedTextViewController = ConvertedTextViewController(document: document)
                            convertedTextViewController.title = document.title
                            dashboardViewController.navigationController?.pushViewController(convertedTextViewController, animated: true)
                        } else {
                            print("NOOO")
                        }
                    }
                }
            }
        }
    }
    
    func dashboardViewControllerDidTapDocument(from dashboardViewController: DashboardViewController, document: DocumentData) {
        let convertedTextViewController: ConvertedTextViewController = ConvertedTextViewController(document: document)
        convertedTextViewController.title = document.title
        dashboardViewController.navigationController?.pushViewController(convertedTextViewController, animated: true)
    }
    
    func dashboardViewControllerDidTapSettings(from dashboardViewController: DashboardViewController) {
        let settingsViewController: SettingsTableViewController = SettingsTableViewController()
        dashboardViewController.navigationController?.pushViewController(settingsViewController, animated: true)
    }
}
