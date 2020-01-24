//
//  CatFactError.swift
//  CatFacts
//
//  Created by Maxwell Poffenbarger on 1/23/20.
//  Copyright © 2020 Poff Daddy. All rights reserved.
//

import Foundation

enum CatFactError: LocalizedError {
    
    case invalidURL
    case noData
    case thrownError(Error)
    case networkError
    
}
