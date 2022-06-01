//
//  AppManager.swift
//  TextToSpeech
//
//  Created by Daniel James Tronca on 31/05/22.
//

import Foundation

class AppManager {
    
    func createDashboardViewControllerConfiguration(documents: [DocumentData]?) -> DashboardViewController.Configuration {
        
        var cells: [DashboardCellItem] = []
        
        cells.append(
            DashboardCellItem(
                cellConfiguration: .addDocumentCell(
                    configuration: AddDocumentCollectionViewCell.Configuration(addLabel: "Aggiungi")
                ),
                cellAction: .didTapAdd
            )
        )
        
        if let documents = documents {
            documents.forEach {
                cells.append(
                    DashboardCellItem(
                        cellConfiguration: .addDocumentCell(
                            configuration: AddDocumentCollectionViewCell.Configuration(addLabel: $0.title!)
                        ),
                        cellAction: .didTapDocument(document: $0)
                    )
                )
            }
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
