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
        recognitionMangaer.processDocumentUrl(documentUrl: documentUrl) { [weak dashboardViewController] response in
            DispatchQueue.main.async { [weak dashboardViewController, weak self] in
                guard let self = self, let dashboardViewController = dashboardViewController else { return }
                dashboardViewController.removeNewDocument()
                dashboardViewController.addNewDocument(
                    documentConfiguration: self.appManager.createDashboardViewControllerNewDocumentConfiguration(
                        documentName: documentUrl.lastPathComponent,
                        isLoading: true
                    )
                )
                if let response = response, !response.isEmpty {
                    let convertedText = response.joined(separator: "\n")
                    let document = DocumentData(
                        content: convertedText,
                        dateCreated: Date(),
                        format: "pdf",
                        id: UUID(),
                        readingTime: 18.0,
                        title: documentUrl.lastPathComponent
                    )
                    DocumentStorage.shared.saveDocument(document: document) { success in
                        if success {
                            print("A")
                        } else {
                            print("NOOO")
                        }
                    }
                    let convertedTextViewController: ConvertedTextViewController = ConvertedTextViewController(text: convertedText)
                    convertedTextViewController.title = documentUrl.lastPathComponent
                    dashboardViewController.navigationController?.pushViewController(convertedTextViewController, animated: true)
                }
            }
        }
    }
}
