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
        
        Task {
            print("Test")
            print("Getting all breeds")
            await fetchBreeds()
            print("Getting Hound images")
            await fetchDogs(breed: "hound")
            print("Getting Hound sub-breeds")
            await fetchSubBreeds(breed: "hound")
        }
    }
    
    enum DataError: Error {
        case cantDecode;
        case badResponse
    }
    
    func getData<T: ApiResult>(url: URL) async throws -> T {
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw DataError.badResponse
        }
        
        guard let result = try? decoder.decode(T.self, from: data) else {
            throw DataError.cantDecode
        }
        
        return result
    }
    
    func fetchBreeds() async {
        api.path = "/api/breeds/list/all"
        do {
            var result: Breeds = try await getData(url: api.url!)
            print(result)
        }
        catch {
            print(error)
        }
    }
    
    func fetchDogs(breed: String) async  {
        api.path = "/api/breed/\(breed)/images"
        do {
            var result: Dogs = try await getData(url: api.url!)
            print(result)
        }
        catch {
            print(error)
        }
        
    }
    
    func fetchSubBreeds(breed: String) async {
        api.path = "/api/breed/\(breed)/list"
        do {
            var result: Dogs = try await getData(url: api.url!)
            print(result)
        }
        catch {
            print(error)
        }
    }
    
    func fetchRandomImage() async {
        
    }
    
    
}
