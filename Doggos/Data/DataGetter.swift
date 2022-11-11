//
//  DataGetter.swift
//  Doggos
//
//  Created by leonardo on 09/11/22.
//

import Foundation

class DataGetter {
    
    let endpoint: String = "https://dog.ceo"
    var api: URLComponents
    
    let decoder = JSONDecoder()
    
    init() {
        guard let unwrappedUrl = try URLComponents(string: endpoint) else { fatalError("Wrong URL") }
        api = unwrappedUrl
    }
    
    enum DataError: Error {
        case cantDecode;
        case badResponse(response: URLResponse)
    }
    
    func getData<T: ApiResult>(url: URL) async throws -> T {
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw DataError.badResponse(response: response)
        }
        
        guard let result = try? decoder.decode(T.self, from: data) else {
            throw DataError.cantDecode
        }
        
        return result
    }
    
    func fetchBreeds() async -> [String: [String]] {
        api.path = "/api/breeds/list/all"
        do {
            let result: Breeds = try await getData(url: api.url!)
            return result.message
        }
        catch {
            print(error)
        }
        return [:]
    }
    
    func fetchDogs(breed: String) async  -> [String] {
        api.path = "/api/breed/\(breed)/images"
        do {
            let result: Dogs = try await getData(url: api.url!)
            return result.message
        }
        catch {
            print(error)
        }
        return []
    }
    
    func fetchSubBreeds(breed: String) async {
        api.path = "/api/breed/\(breed)/list"
        do {
            let result: Dogs = try await getData(url: api.url!)
        }
        catch {
            print(error)
        }
    }
    
    func fetchRandomImage() async {
        
    }
    
    
}
