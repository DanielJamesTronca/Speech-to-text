//
//  DocumentData.swift
//  TextToSpeech
//
//  Created by Daniel James Tronca on 01/06/22.
//

import Foundation
import CoreData

struct DocumentData {
    var content: String?
    var dateCreated: Date?
    var format: String?
    var id: UUID?
    var readingTime: Float?
    var title: String?
    
    func generateCoreDataDocumentObject(persistenceContainer: NSManagedObjectContext) -> DocumentObject? {
        let coreDataDocument = DocumentObject(context: persistenceContainer)
        coreDataDocument.content = self.content
        coreDataDocument.dateCreated = self.dateCreated
        coreDataDocument.format = self.format
        coreDataDocument.id = self.id
        coreDataDocument.readingTime = self.readingTime ?? 0.0
        coreDataDocument.title = self.title
        return coreDataDocument
    }
}
