//
//  Trip+CoreDataProperties.swift
//  travel-app
//
//  Created by Eugene on 2025-04-10.
//
//

import Foundation
import CoreData


extension Trip {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Trip> {
        return NSFetchRequest<Trip>(entityName: "Trip")
    }

    @NSManaged public var name: String?
    @NSManaged public var details: String?
    @NSManaged public var id: UUID?
    @NSManaged public var startDate: Date?
    @NSManaged public var endDate: Date?

}

extension Trip : Identifiable {

}
