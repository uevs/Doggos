//
//  DataManager.swift
//  Doggos
//
//  Created by leonardo on 09/11/22.
//

import Foundation
import UIKit


class DataManager {
    
    private(set) var breedsNames: [String: [String]] = [:] // [Breed name: [Array of SubBreeds names]
    private(set) var breedImagesURL: [String: [String]] = [:] // [Breed name: [Array of Pics URLS]
    private(set) var breedImages = NSCache<NSString, NSArray>() //[Breed name: [Array of UImages of that breed]
    
    private let endpoint: String = "https://dog.ceo"
    private var api: URLComponents
    
    private let userDefaults = UserDefaults.standard
    private let decoder = JSONDecoder()
    
    init() {
        guard let unwrappedUrl = try URLComponents(string: endpoint) else { fatalError("Wrong URL") }
        api = unwrappedUrl
        setup()
    }
    
    enum DataError: Error {
        case cantDecode;
        case badResponse(response: URLResponse)
    }
    
    private func setup() {
        
        /// Check if there are Breed names on userdefaults and load them
        breedsNames = userDefaults.object(forKey: "breedsNames") as? [String: [String]] ?? [:]
        
        if breedsNames.isEmpty {
            Task {
                breedsNames = await fetchBreeds()
                userDefaults.set(breedsNames, forKey: "breedsNames")
            }
        }
        
        /// Check if there are images urls on userdefaults and load them
        print("breedimageurls")
        breedImagesURL = userDefaults.object(forKey: "breedImagesURL") as? [String: [String]] ?? [:]
        
        
        /// Check if there are image caches in userdefautls and load them
//        breedImages = userDefaults.object(forKey: "breedImages") as? NSCache<NSString, NSArray> ?? NSCache<NSString, NSArray>()
        
    }
    
    
    private func getData<T: ApiResult>(url: URL) async throws -> T {
        
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
    
    
}


