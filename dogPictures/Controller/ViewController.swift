//
//  ViewController.swift
//  dogPictures
//
//  Created by Justin Knight on 3/19/19.
//  Copyright © 2019 JustinKnight. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var dogImageView: UIImageView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var breeds: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.dataSource = self
        pickerView.delegate = self
        DogApi.requestAllBreeds(completionHandler: handleBreedList(breedList:error:))
        
    }
    
    func handleImageFileResponse (image:UIImage?, error: Error?) {
        DispatchQueue.main.async {
            self.dogImageView.image = image
        }
    }
    func handleRandomImageResponse(imageData: DogImage?, error: Error?) {
        guard let dogImageURL = URL(string: (imageData?.message ?? "")) else {
            return
        }
        DogApi.requestImageFile(url: dogImageURL, completionHandler: self.handleImageFileResponse(image:error:))
        
    }
    func handleBreedList(breedList: [String]?, error: Error?) {
        guard let breedList = breedList else {
            
            print("inside handleSpecificBreedIMage. error: \(error)")
            return
        }
        breeds = breedList
        DispatchQueue.main.async {
            print(self.breeds)
            print("reloading all components")
            self.pickerView.reloadAllComponents()
        }
        
    }
}
extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    //number of sections
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        print("number of breeds: \(breeds.count)")
        return breeds.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return breeds[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        DogApi.requestRandomImage(breed: breeds[row], completionHandler: self.handleRandomImageResponse(imageData:error:))
    }
    
    
}

