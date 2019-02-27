//
//  DDGModel.swift
//  DuckDuckSearch
//
//  Created by MCS on 2/24/19.
//  Copyright © 2019 EduardoSantiz. All rights reserved.
//

import Foundation

enum ResultType: String, Codable {
    case article = "A"
    case disambiguation = "D"
    case category = "C"
    case name = "N"
    case exclusive = "E"
}

struct DDGModel: Decodable {
    let title: String
    let description: String
    let resultType: ResultType
    let imageURL: URL?
    
    enum CodingKeys: String, CodingKey {
        case title = "Heading"
        case description = "AbstractText"
        case resultType = "Type"
        case imageURL = "Image"
    }
}

extension DDGModel {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        resultType = try container.decode(ResultType.self, forKey: .resultType)
        imageURL = try container.decode(URL.self, forKey: .imageURL)
    }
}
