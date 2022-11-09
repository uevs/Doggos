//
//  Data.swift
//  Doggos
//
//  Created by leonardo on 09/11/22.
//

protocol ApiResult: Decodable {
}

struct Breeds: ApiResult {
    var message: [String: [String]]
}

struct Dogs: ApiResult {
    var message: [String]
}

