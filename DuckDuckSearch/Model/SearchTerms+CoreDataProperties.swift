//
//  SearchTerms+CoreDataProperties.swift
//  DuckDuckSearch
//
//  Created by MCS on 2/28/19.
//  Copyright © 2019 EduardoSantiz. All rights reserved.
//
//

import Foundation
import CoreData


extension SearchTerms {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SearchTerms> {
        return NSFetchRequest<SearchTerms>(entityName: "SearchTerms")
    }

    @NSManaged public var term: String?

}
