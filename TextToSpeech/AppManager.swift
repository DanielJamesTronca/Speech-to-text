//
//  AppManager.swift
//  TextToSpeech
//
//  Created by Daniel James Tronca on 31/05/22.
//

import Foundation

class AppManager {
    
    func createDashboardViewControllerConfiguration() -> DashboardViewController.Configuration {
        
        var cells: [DashboardCellItem] = []
        
        cells.append(
            DashboardCellItem(
                cellConfiguration: .addDocumentCell(
                    configuration: AddDocumentCollectionViewCell.Configuration()
                ),
                cellAction: .didTapAdd
            )
        )
        
        return DashboardViewController.Configuration(source: [(header: "Ciao", cells: cells)])
    }
    
}
