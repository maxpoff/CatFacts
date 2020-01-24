//
//  CatFact.swift
//  CatFacts
//
//  Created by Maxwell Poffenbarger on 1/23/20.
//  Copyright © 2020 Poff Daddy. All rights reserved.
//

import Foundation

struct TopLevelGETObject: Decodable {
    let facts: [CatFact]
}

struct CatFact: Codable {
    
    let id: Int?
    let details: String
    
}

struct TopLevelPOSTObject: Codable {
    let facts: CatFact
}

