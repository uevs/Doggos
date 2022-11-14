//
//  DataManager.swift
//  Doggos
//
//  Created by leonardo on 09/11/22.
//

import Foundation
import UIKit

class DataManager {
    ///  Manages network calls, data chaching and data persistence for the app.
    
    /// The data is stored here in memory at runtime. Names and favorites are also stored locally on UserDefaults.
    private(set) var breedsNames: [String: [String]] = [:] /// [Breed name: [Array of SubBreeds names]
    private(set) var breedImagesURL: [String: [String]] = [:] /// [Breed name: [Array of Pics URLS]
    private(set) var favorites: [String] = [] /// [URLs of favorite images]
    private var imagesCache = NSCache<NSString, NSMutableDictionary>() /// [Breed name: [url: image data]
    
    private let endpoint: String = "https://dog.ceo"
    private var api: URLComponents
    
    private let userDefaults = UserDefaults.standard
    private let decoder = JSONDecoder()
    
    static var magnification: CGFloat = 3 // Stored here just for convenience
    
    init() {
        guard let unwrappedUrl = URLComponents(string: endpoint) else { fatalError("Wrong URL") }
        api = unwrappedUrl
    }
    
    private enum DataError: Error {
        case cantDecode;
        case badResponse(response: URLResponse)
    }
    
    @MainActor
    func setup(completion: @escaping () -> (Void)) async {
        /// This function needs to be called when the view loads, to populate it with data.
        
        breedsNames = userDefaults.object(forKey: "breedsNames") as? [String: [String]] ?? [:]
        favorites = userDefaults.stringArray(forKey: "favorites") ?? []
        
        /// Since breeds are unlikely to be updated, they are only feteched if there aren't on UserDefaults
        if breedsNames.isEmpty {
            breedsNames = await fetchBreeds()
            userDefaults.set(breedsNames, forKey: "breedsNames")
            completion()
        } else {
            completion()
        }
    }
    
    @MainActor
    func setupBreedView(breed: String, completion: @escaping () -> (Void)) async {
        /// Fetches all images URLs for a given breed
        
        breedImagesURL[breed] = await fetchBreedImagesURLs(breed: breed)
        completion()
    }
    
    func getImage(breed: String, url: String, completion: @escaping () -> (Void)) async throws -> UIImage {
        /// Returns a specific image from either a URL or the cahced version.
        
        let nsBreed = NSString(string: breed)
        
        /// Checks if the given breed is stored in the cache, then cecks if the image corresponding to the URL is stored in the breed's chace.
        if let cachedBreed = imagesCache.object(forKey: nsBreed) {
            if let cachedImage: Data = cachedBreed.object(forKey: url) as? Data {
                return UIImage(data: cachedImage)!
            }
        }
        
        /// If no image or breed is present in the cache, it gets the image from the APi.
        let (data, response) = try await URLSession.shared.data(from: URL(string: url)!)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw DataError.badResponse(response: response)
        }
        
        /// It stores the image on the breed's cache and creates it if it doesn't exist yet.
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
    
    
    func toggleFavorite(url: String) {
        
        if !favorites.contains(url) {
            favorites.append(url)
            userDefaults.set(favorites, forKey: "favorites")
        } else {
            favorites.removeAll(where: {$0 == url})
            userDefaults.set(favorites, forKey: "favorites")
        }
    }
    
    
    private func getData<T: ApiResult>(url: URL) async throws -> T {
        /// Gets from the internet either a Breed [Breed: [SubBreeds]] or Dog [URLs] data.
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw DataError.badResponse(response: response)
        }
        
        guard let result = try? decoder.decode(T.self, from: data) else {
            throw DataError.cantDecode
        }
        
        return result
    }

        
    private func fetchBreeds() async -> [String: [String]] {
        /// Rreturns a list of all Breeds and SubBreeds available on the API.
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
    
    
    private func fetchBreedImagesURLs(breed: String) async  -> [String] {
        /// Returns all the images URLs for a specific breed
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
}


