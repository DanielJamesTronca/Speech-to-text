//
//  DocumentStorage.swift
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

class DocumentStorage: NSObject {
    
    public static let shared: DocumentStorage = DocumentStorage()
    
    var documentList = [DocumentData]()
    
    func getDocuments(completionHandler: @escaping (_ documents: [DocumentData]?) -> Void) {
        let context = PersistenceContainer.shared.container.viewContext
        let fetchRequest: NSFetchRequest<DocumentObjects> = DocumentObjects.fetchRequest()
        
        context.perform {
            do {
                let result = try fetchRequest.execute()
                var documentListToReturn = [DocumentData]()
                result.forEach {
                    $0.documentList?.forEach({
                        if let document = $0 as? DocumentObject {
                            documentListToReturn.append(document.convertToDocumentData())
                        }
                    })
                }
                completionHandler(documentListToReturn)
            } catch {
                print("Something went wrong: \(error.localizedDescription)")
                completionHandler(nil)
            }
        }
    }
    
    func saveDocument(document: DocumentData, completionHandler: @escaping (_ success: Bool) -> Void) {
        let persistenceContainer = PersistenceContainer.shared.container.viewContext
        if let documentObject = document.generateCoreDataDocumentObject(persistenceContainer: persistenceContainer) {
            let documents = DocumentObjects(context: persistenceContainer)
            documents.addToDocumentList(NSSet(object: documentObject))
            PersistenceContainer.shared.saveContext()
            completionHandler(true)
        } else {
            completionHandler(false)
        }
    }
}
