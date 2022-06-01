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
                        cellConfiguration: .documentCell(
                            configuration: DocumentCollectionViewCell.Configuration(
                                content: $0.content,
                                title: $0.title,
                                date: "12/12/98",
                                isLoading: false
                            )
                        ),
                        cellAction: .didTapDocument(document: $0)
                    )
                )
            }
        }
        
        return DashboardViewController.Configuration(source: cells)
    }
    
    func createDashboardViewControllerNewDocumentConfiguration(documentName: String, isLoading: Bool, content: String? = nil) -> DashboardCellItem {
        return DashboardCellItem(
            cellConfiguration: .documentCell(
                configuration: DocumentCollectionViewCell.Configuration(
                    content: content,
                    title: documentName,
                    date: "12/12/98",
                    isLoading: isLoading
                )
            ),
            cellAction: .none
        )
    }
}
