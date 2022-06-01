//
//  DocumentObject+CoreDataClass.swift
//  TextToSpeech
//
//  Created by Daniel James Tronca on 01/06/22.
//
//

import Foundation
import CoreData

@objc(DocumentObject)
public class DocumentObject: NSManagedObject {
    func convertToDocumentData() -> DocumentData {
        return DocumentData(content: self.content, dateCreated: self.dateCreated, format: self.format, id: self.id, readingTime: self.readingTime, title: self.title)
    }
}
