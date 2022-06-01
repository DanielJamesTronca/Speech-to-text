//
//  AppManager.swift
//  TextToSpeech
//
//  Created by Daniel James Tronca on 31/05/22.
//

import Foundation

class AppManager {
    
    func createDashboardViewControllerConfiguration(with url: String? = nil) -> DashboardViewController.Configuration {
        
        var cells: [DashboardCellItem] = []
        
        cells.append(
            DashboardCellItem(
                cellConfiguration: .addDocumentCell(
                    configuration: AddDocumentCollectionViewCell.Configuration(addLabel: "Aggiungi")
                ),
                cellAction: .didTapAdd
            )
        )
        
        if let url = url {
            cells.append(
                DashboardCellItem(
                    cellConfiguration: .addDocumentCell(
                        configuration: AddDocumentCollectionViewCell.Configuration(addLabel: url)
                    ),
                    cellAction: .didTapAdd
                )
            )
        }
        
        return DashboardViewController.Configuration(source: cells)
    }
    
    func createDashboardViewControllerNewDocumentConfiguration(documentName: String, isLoading: Bool) -> DashboardCellItem {
        return DashboardCellItem(
            cellConfiguration: .documentCell(
                configuration: DocumentCollectionViewCell.Configuration(
                    addLabel: documentName,
                    isLoading: isLoading
                )
            ),
            cellAction: .none
        )
    }
}
