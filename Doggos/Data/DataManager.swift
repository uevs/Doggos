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
    private(set) var imagesCache = NSCache<NSString, NSMutableDictionary>() //[Breed name: [Dict of image data of that breed]
    private(set) var favorites: [String] = [] // Contains urls to favorite images
    
    private let endpoint: String = "https://dog.ceo"
    private var api: URLComponents
    
    private let userDefaults = UserDefaults.standard
    private let decoder = JSONDecoder()
    
    static var magnification: CGFloat = 3
    
    init() {
        guard let unwrappedUrl = try URLComponents(string: endpoint) else { fatalError("Wrong URL") }
        api = unwrappedUrl
    }
    
    enum DataError: Error {
        case cantDecode;
        case badResponse(response: URLResponse)
    }
    
    @MainActor
    func setup(completion: @escaping () -> (Void)) async {
        
        /// Check if there are Breed names on userdefaults and load them
        breedsNames = userDefaults.object(forKey: "breedsNames") as? [String: [String]] ?? [:]
        
        favorites = userDefaults.stringArray(forKey: "favorites") ?? []
        
        if breedsNames.isEmpty {
            breedsNames = await fetchBreeds()
            userDefaults.set(breedsNames, forKey: "breedsNames")
            completion()
        } else {
            completion()
        }
        
        /// Check if there are image caches in userdefautls and load them
//        breedImages = userDefaults.object(forKey: "breedImages") as? NSCache<NSString, NSArray> ?? NSCache<NSString, NSArray>()
        
    }
    
    @MainActor
    func setupBreedView(breed: String, completion: @escaping () -> (Void)) async {
        breedImagesURL[breed] = await fetchBreedImagesURLs(breed: breed)
        completion()
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
    
    func getImage(breed: String, url: String, completion: @escaping () -> (Void)) async throws -> UIImage {
        
        let nsBreed = NSString(string: breed)
        let nsUrl = NSString(string: url)
        
        if let cachedBreed = imagesCache.object(forKey: nsBreed) {
            if let cachedImage: Data = cachedBreed.object(forKey: url) as? Data {
                return UIImage(data: cachedImage)!
            }
        }
        
        let (data, response) = try await URLSession.shared.data(from: URL(string: url)!)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw DataError.badResponse(response: response)
        }
        
        if let cache = imagesCache.object(forKey: nsBreed) {
            cache.setValue(data, forKey: url)
            imagesCache.setObject(cache, forKey: nsBreed)
        } else {
            let newCache = NSMutableDictionary()
            newCache.setValue(data, forKey: url)
            imagesCache.setObject(newCache, forKey: nsBreed)
        }
        
        return UIImage(data:data) ?? UIImage(systemName: "wifi.exclamationmark")!
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
    
    func fetchBreedImagesURLs(breed: String) async  -> [String] {
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
    
    func toggleFavorite(url: String) {
        if !favorites.contains(url) {
            favorites.append(url)
            userDefaults.set(favorites, forKey: "favorites")
            print(favorites)
        } else {
            favorites.removeAll(where: {$0 == url})
            userDefaults.set(favorites, forKey: "favorites")
            print(favorites)
        }
    }
}


