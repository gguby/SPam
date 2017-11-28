//
//  Content+CoreDataProperties.swift
//  SPam
//
//  Created by wsjung on 2017. 11. 27..
//  Copyright © 2017년 wsjung. All rights reserved.
//
//

import Foundation
import CoreData


extension Content {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Content> {
        return NSFetchRequest<Content>(entityName: "Content")
    }

    @NSManaged public var fileterString: String?

}
