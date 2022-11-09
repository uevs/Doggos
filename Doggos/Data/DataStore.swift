//
//  DataStore.swift
//  Doggos
//
//  Created by leonardo on 09/11/22.
//

import Foundation

class DataStore {
    
    let dataGetter: DataGetter
    
    let userDefaults = UserDefaults.standard

    var breeds: [String: [String]] = [:]
    var selectedDog: [String] = []
    var isInitialized: Bool
    
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
    
    func setup() async {
        print("setting up...")
        breeds = await dataGetter.fetchBreeds()
        userDefaults.set(true, forKey: "isInitialized")
        userDefaults.set(breeds, forKey: "breedsList")
        isInitialized = true
        print(breeds)
    }
    
    func update() async {
        print("fetching from local storage...")
        breeds = (userDefaults.dictionary(forKey: "breedsList") ?? [:]) as! [String: [String]]
        
        if breeds.isEmpty {
            print("Can't find breeds, setting up again")
            await setup()
        }
        print(breeds)
        
        // check if enough time has passed, if so fetch again
        
    }
    
    

}
