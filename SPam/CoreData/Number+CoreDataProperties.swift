//
//  Number+CoreDataProperties.swift
//  SPam
//
//  Created by wsjung on 2017. 11. 27..
//  Copyright © 2017년 wsjung. All rights reserved.
//
//

import Foundation
import CoreData


extension Number {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Number> {
        return NSFetchRequest<Number>(entityName: "Number")
    }

    @NSManaged public var number: String?

}
