//
//  RecentImage+CoreDataProperties.swift
//  Book
//
//  Created by 김은서 on 5/16/25.
//
//

import Foundation
import CoreData


extension RecentImage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecentImage> {
        return NSFetchRequest<RecentImage>(entityName: "RecentImage")
    }

    @NSManaged public var thumbnail: String?
    @NSManaged public var authors: String?
    @NSManaged public var price: String?
    @NSManaged public var title: String?
    @NSManaged public var contents: String?

}

extension RecentImage : Identifiable {

}
