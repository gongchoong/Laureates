//
//  ApiService.swift
//  NobelLaureates
//
//  Created by chris davis on 2/16/20.
//  Copyright © 2020 Woohyun David Lee. All rights reserved.
//

import UIKit

enum ApiServiceError: String, Error{
    case dataFetchError = "data fetch error"
    case jsonDecodeError = "json decoding error"
}

protocol ApiServiceProtocol {
    func fetchNobelPrizeData(completion: @escaping(_ success: Bool, _ decoded: [Laureate], _ error: ApiServiceError?) -> ())
}

class ApiService: ApiServiceProtocol {
    func fetchNobelPrizeData(completion: @escaping(_ success: Bool, _ decoded: [Laureate], _ error: ApiServiceError?) -> ()) {
        guard let path = Bundle.main.path(forResource: Constant.jsonFileName, ofType: "json") else {
            completion(false, [Laureate](), .dataFetchError)
            return
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let decoder = JSONDecoder()
            let laureates = try decoder.decode([Laureate].self, from: data)
            completion(true, laureates, nil)
        }catch let error {
            print(error.localizedDescription)
            completion(false, [Laureate](), .jsonDecodeError)
        }
    }
}

struct Laureate: Codable {
    let firstName: String
    let lastName: String
    let city: String
    let year: String
    let location: Location
    
    enum CodingKeys: String, CodingKey {
        case firstName = "firstname"
        case lastName = "surname"
        case city
        case location
        case year
    }

    struct Location: Codable{
        let lat: Double
        let lng: Double
    }
}
