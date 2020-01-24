//
//  CatFactController.swift
//  CatFacts
//
//  Created by Maxwell Poffenbarger on 1/23/20.
//  Copyright © 2020 Poff Daddy. All rights reserved.
//

import Foundation

class CatFactController {
    
    private static let baseURL = URL(string: "http://www.catfact.info/api/v1/facts")
    private static let postPathExtension = "json"
    private static let pageQueryName = "page"
    static private let contentTypeKey = "Content-Type"
    static private let contentTypeValue = "application/JSON"
    
    static func fetchCatFacts(page: Int, completion: @escaping (Result<[CatFact], CatFactError>) -> Void) {
        
        guard var url = baseURL else {return completion(.failure(.invalidURL))}
        url.appendPathExtension(postPathExtension)
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        let pageQueryItem = URLQueryItem(name: pageQueryName, value: String(page))
        components?.queryItems = [pageQueryItem]
        guard let finalURL = components?.url else {return}
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            
            if let error = error {
                print(error, error.localizedDescription)
                completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else {return completion(.failure(.noData))}
            
            do {
                let catFacts = try JSONDecoder().decode(TopLevelGETObject.self, from: data).facts
                completion(.success(catFacts))
            } catch {
                print(error, error.localizedDescription)
                completion(.failure(.thrownError(error)))
            }
        }.resume()
    }
    
    static func postCatFact(details: String, completion: @escaping (Result<CatFact, CatFactError>) -> Void) {
        
        guard let baseURL = baseURL else {return completion(.failure(.invalidURL))}
        let finalURL = baseURL.appendingPathExtension(postPathExtension)
        print(finalURL)
        
        var postRequest = URLRequest(url: finalURL)
        postRequest.httpMethod = "POST"
        postRequest.addValue(contentTypeValue, forHTTPHeaderField: contentTypeKey)
        let postingCatFact = CatFact(id: nil, details: details)
        
        do {
            let catData = try JSONEncoder().encode(postingCatFact)
            postRequest.httpBody = catData
        } catch {
            print(error, error.localizedDescription)
            return completion(.failure(.thrownError(error)))
        }
        
        URLSession.shared.dataTask(with: postRequest) { (data, _, error) in
            
            if let error = error {
                print(error, error.localizedDescription)
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else {return completion(.failure(.noData))}
            
            do {
                let catFact = try JSONDecoder().decode(CatFact.self, from: data)
                completion(.success(catFact))
            } catch {
                print(error, error.localizedDescription)
                return completion(.failure(.thrownError(error)))
            }
        }.resume()
    }
}//End of class
