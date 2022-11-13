//
//  DataStore.swift
//  Doggos
//
//  Created by leonardo on 09/11/22.
//

import Foundation
import UIKit

class DataStore {
    
    let dataGetter: DataGetter
    
    private let userDefaults = UserDefaults.standard
    
    private(set) var breeds: [String: [String]] = [:]
    private(set) var breedImagesURL: [String: [String]] = [:]
    private(set) var breedImages = NSCache<NSString, NSArray>()
    
    private(set) var isInitialized: Bool
    
    init(dataGetter: DataGetter) {
        self.dataGetter = dataGetter
        
        isInitialized = userDefaults.bool(forKey: "isInitialized")
        
        Task {
            if !isInitialized {
                await setup()
            } else {
                await update()
            }
        }
    }
    
    private func setup() async {
        print("initializing app")
        breeds = await dataGetter.fetchBreeds()
        userDefaults.set(true, forKey: "isInitialized")
        userDefaults.set(breeds, forKey: "breedsList")
        isInitialized = true
        await setupImagesURL()
    }
    
    private func update() async {
        breeds = (userDefaults.dictionary(forKey: "breedsList") ?? [:]) as! [String: [String]]
        
        if breeds.isEmpty {
            await setup()
        }
        
        // check if enough time has passed, if so fetch again and update the dataset
        
    }
    
    private func setupImagesURL() async {
        if !breeds.isEmpty {
            for i in 0...14 {
                let current = Array(breeds.keys).sorted()[i]
                print("Fetching breed \(i) of 14: \(current)")
                let images = await dataGetter.fetchDogs(breed: current)
                userDefaults.set(images, forKey: current)
                breedImagesURL[current] = images
            }
        } else {
            await setup()
        }
    }
    
    func getImagesURL(breed: String) async -> [String] {
        print("")
        print("Fetching \(breed) images")
        var images = (userDefaults.object(forKey: breed) ?? []) as! [String]
        
        // check if enough time has passed, if so fetch again
        
        if images.isEmpty {
            print("UserDefaults doesn't contain \(breed). Fetching online")
            images = await dataGetter.fetchDogs(breed: breed)
            breedImagesURL[breed] = images
            userDefaults.set(images, forKey: breed)
            return images
            
        } else {
            print("Found \(breed) on userdefaults.")
            breedImagesURL[breed] = images
            return images
        }
    }
    
    
    
}
