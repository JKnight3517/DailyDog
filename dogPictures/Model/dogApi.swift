//
//  dogApi.swift
//  dogPictures
//
//  Created by Justin Knight on 3/19/19.
//  Copyright © 2019 JustinKnight. All rights reserved.
//

import Foundation
import UIKit

class DogApi {
    // Enum targeted endpoints from dog.ceo
    // Notice how this enum uses associated value since the randomIMageFormBreed API needs a specific breed value that can chang
    enum Endpoint {
        case randomImageFromAllDogsCollection
        case randomImageFromBreed (String)
        case listAllBreeds
        // Generates URL object
        var dogURL: URL {return URL(string: self.stringValue)!}
        
        // Generates String For URL
        var stringValue: String {
            switch self {
            case .randomImageFromAllDogsCollection: return  "https://dog.ceo/api/breeds/image/random"
            case .randomImageFromBreed(let breed): return "https://dog.ceo/api/breed/\(breed)/images/random"
            case .listAllBreeds: return "https://dog.ceo/api/breeds/list/all"
            }
        }
    }
    // Going to make this a class function so that we don't need an instance of the class to call it
    // The second parameter here is a closure marked with escaping since we want to be able to provide this completion handler to some other process
    class func requestImageFile(url:URL, completionHandler: @escaping (UIImage?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let recievedData = data else {
        completionHandler(nil,error)
        return
        }
        
        let downloadedImage = UIImage(data: recievedData)
        completionHandler(downloadedImage,nil)
        }
        task.resume()
}
    
    class func requestRandomImage(breed: String, completionHandler: @escaping (DogImage?,Error?) -> Void) {
        let randomImageEndPoint = DogApi.Endpoint.randomImageFromBreed(breed).dogURL
        let task = URLSession.shared.dataTask(with: randomImageEndPoint) { (data, response, error) in
            guard let recievedData = data else {
                completionHandler(nil, error)
                return
            }
            let decoder = JSONDecoder()
            do {
                // Note we add the ".self" to the end of DogImage so the system knows to reference the Struct in general and not a particular instance of DogImage
                let imageData = try decoder.decode(DogImage.self, from: recievedData)
                print(imageData)
               completionHandler(imageData, nil)
                
            } catch {print(error)}
            
    }
    task.resume()
}
    // Grab all of the breeds available
    class func requestAllBreeds(completionHandler: @escaping ([String]?, Error?) -> Void) {
        let allBreedsEndPoint = DogApi.Endpoint.listAllBreeds.dogURL
        let task = URLSession.shared.dataTask(with: allBreedsEndPoint) { (data, response, error) in
            guard let recievedData = data else {
                completionHandler(nil, error)
                return
            }
            let decoder = JSONDecoder()
            do {
                // Note we add the ".self" to the end of [String:String] so the system knows to reference the Struct in general and not a particular instance of DogImage
                let breedData = try decoder.decode(breedListStructure.self, from: recievedData)
                print(breedData)
                let breedList = breedData.message.keys.map({$0})
                completionHandler(breedList, nil)
                
            } catch {print(error)}
            
        }
        task.resume()
    }
}
