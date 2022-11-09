//
//  Breed.swift
//  Doggos
//
//  Created by leonardo on 09/11/22.
//

import Foundation

protocol ApiResult: Decodable {
}

struct Breeds: ApiResult {
    var message: [String: [String]]
}

struct Dogs: ApiResult {
    var message: [String]
}

