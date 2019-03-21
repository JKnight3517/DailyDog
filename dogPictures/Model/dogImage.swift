//
//  dogImage.swift
//  dogPictures
//
//  Created by Justin Knight on 3/19/19.
//  Copyright © 2019 JustinKnight. All rights reserved.
//

import Foundation

// THis is to represent the data recieved from dog APIs which just contain a status message and an image URL
// We need to specify that DogIMage conforms to the Codable protocol so we can decode JSON messages into an instance of our dogIMage
struct DogImage: Codable{
    let status: String
    let message: String
}
