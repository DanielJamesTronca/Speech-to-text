//
//  DocumentObjects+CoreDataProperties.swift
//  TextToSpeech
//
//  Created by Daniel James Tronca on 01/06/22.
//
//

import Foundation
import CoreData


extension DocumentObjects {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DocumentObjects> {
        return NSFetchRequest<DocumentObjects>(entityName: "DocumentObjects")
    }

    @NSManaged public var documentList: NSSet?

}

// MARK: Generated accessors for documentList
extension DocumentObjects {

    @objc(addDocumentListObject:)
    @NSManaged public func addToDocumentList(_ value: DocumentObject)

    @objc(removeDocumentListObject:)
    @NSManaged public func removeFromDocumentList(_ value: DocumentObject)

    @objc(addDocumentList:)
    @NSManaged public func addToDocumentList(_ values: NSSet)

    @objc(removeDocumentList:)
    @NSManaged public func removeFromDocumentList(_ values: NSSet)

}

extension DocumentObjects : Identifiable {

}
