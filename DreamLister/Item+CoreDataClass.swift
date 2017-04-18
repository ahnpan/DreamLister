//
//  Item+CoreDataClass.swift
//  DreamLister
//
//  Created by Ruby Vega on 09/04/2017.
//  Copyright © 2017 Ruby Vega. All rights reserved.
//

import Foundation
import CoreData

public class Item: NSManagedObject {
    
    public override func awakeFromInsert() {
        
        super.awakeFromInsert()
        
        self.created = NSDate()
        
    }

}
