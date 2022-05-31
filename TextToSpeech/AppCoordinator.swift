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
}
