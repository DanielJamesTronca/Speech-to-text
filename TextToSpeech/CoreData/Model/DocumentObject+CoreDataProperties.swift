//
//  DocumentObject+CoreDataProperties.swift
//  TextToSpeech
//
//  Created by Daniel James Tronca on 01/06/22.
//
//

import Foundation
import CoreData

extension DocumentObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DocumentObject> {
        return NSFetchRequest<DocumentObject>(entityName: "DocumentObject")
    }

    @NSManaged public var content: String
    @NSManaged public var dateCreated: Date
    @NSManaged public var format: String?
    @NSManaged public var id: UUID
    @NSManaged public var readingTime: Float
    @NSManaged public var title: String
    @NSManaged public var documents: DocumentObjects?

}

extension DocumentObject : Identifiable {

}
