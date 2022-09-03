//
//  PlantScannerPost.swift
//  Datability
//
//  Created by Krish Iyengar on 9/3/22.
//

import Foundation
import UIKit
import CoreLocation
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth
import NaturalLanguage

struct PlantScanner {
    
    public static let dataLocationManager = CLLocationManager()
    
    public static func plantScanner(image: UIImage, expectedPlant: String, completion: @escaping (Bool) -> ()) {
        
        guard let plantScannerURL = URL(string: "https://api.plant.id/v2/identify") else {
            
            completion(false)
            return
            
        }
        guard let currentLoc = self.dataLocationManager.location else {
            
            completion(false)
            
            return
        }
        
        var plantScannerURLRequest = URLRequest(url: plantScannerURL)
        
        plantScannerURLRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        plantScannerURLRequest.addValue("pBjKtY8kVH7888JrUCgfHK35PBvT3LRSOMTZ2Njt7JaDJeHQvn", forHTTPHeaderField: "Api-Key")
        plantScannerURLRequest.httpMethod = "POST"
        
        guard let plantScannerImageData = image.pngData()?.base64EncodedString(options: .lineLength64Characters) else {
            completion(false)
            return
            
        }
        do {
            
            plantScannerURLRequest.httpBody = try JSONSerialization.data(withJSONObject: ["images": [plantScannerImageData], "modifiers": ["similar_images"], "plant_details": ["common_names", "url"], "latitude": currentLoc.coordinate.latitude, "longitude": currentLoc.coordinate.longitude])
            
            URLSession.shared.dataTask(with: plantScannerURLRequest) { plantScannerDataURL, plantScannerDataURLResponse, plantScannerDataError in
                if plantScannerDataError == nil && plantScannerDataURLResponse != nil && plantScannerDataURL != nil {
                    guard let plantScannerData = plantScannerDataURL else { return }
                    do {
                        guard let currentPlantScannerResults = try (JSONSerialization.jsonObject(with: plantScannerData)) as? [String:Any] else {
                            completion(false)
                            return
                            
                        }
                        
                        var isPlantResultsBool = false
                        // Checks for nil and checks to make sure the the right plant is  bein skanned
                        if let isPlantResults = currentPlantScannerResults["is_plant"] as? Int {
                            if isPlantResults == 1 {
                                isPlantResultsBool = true
                            }
                        }
                        else {
                            completion(false)
                            return
                        }
                        guard let plantScannerResults = currentPlantScannerResults["suggestions"] as? [[String:Any]] else {
                            completion(false)
                            return
                            
                        }
                        guard let plantScannerFirstResult = plantScannerResults.first?["plant_details"] as? [String:Any] else {
                            completion(false)
                            return
                            
                        }
                        guard let plantScannerFirstResultImageStep1 = plantScannerResults.first?["similar_images"] as? [[String:Any]] else {
                            completion(false)
                            return
                            
                        }
                        guard let plantScannerFirstResultImageURL = plantScannerFirstResultImageStep1.first?["url"] as? String else {
                            completion(false)
                            return
                            
                        }
                        guard let plantScannerFirstResultName = plantScannerResults.first?["plant_name"] as? String else {
                            completion(false)
                            return
                            
                        }
                        guard let plantScannerFirstResultWikiURL = plantScannerFirstResult["url"] as? String else {
                            completion(false)
                            return
                            
                        }
                        
                        if isPlantResultsBool {
                            if let dataSentenceEmbedding = NLEmbedding.sentenceEmbedding(for: .english) {
                                let theDistanceBetweenPhrase = 1-(dataSentenceEmbedding.distance(between: expectedPlant, and: plantScannerFirstResultName))
                                
                                if theDistanceBetweenPhrase <= 0.2 {
                                    completion(true)
                                    return
                                }
                                else {
                                    completion(false)
                                    return
                                }
                            }
                            else {
                                completion(false)
                                return
                            }
                            
                        }
                        else {
                            completion(false)
                            return
                        }
                        
                    }
                    catch {
                        completion(false)
                        return
                    }
                }
                else {
                    completion(false)
                    return
                }
            }.resume()
        }
        catch {
            completion(false)
            
            print("ERROR")
        }
    }
    
    
    
    public static func uploadPhoto(image: UIImage, lat: Double, long: Double, currentDictChallenge: [String:Any]) {
        let imageUUID = UUID().uuidString
        guard let data = image.pngData() else { return }
        let currentImageStorage = Storage.storage().reference().child("\(imageUUID).png")
        currentImageStorage.putData(data) { storageMet, storageError in
            if storageError == nil && storageMet != nil {
                uploadEntries(uuid: currentImageStorage, latitude: "\(lat)", longitude: "\(long)", currentDictChallenge: currentDictChallenge)
            }
        }
        
    }
    
    public static func uploadEntries(uuid: StorageReference, latitude: String, longitude: String, currentDictChallenge: [String:Any]) {
        guard let currentDictID = currentDictChallenge["id"] as? String else { return }
        guard let currentUserID = Auth.auth().currentUser?.uid as? String else { return }
        Firestore.firestore().collection("challenges").document(currentDictID).collection("entries").addDocument(data: ["host": currentUserID, "photo": uuid.fullPath, "lat": latitude, "long": longitude])
    }
    public static func getPhotoChallengesURL(currentDictChallenge: [String:Any], completion: @escaping (UIImage) -> ()) {
        guard let photosURLString = currentDictChallenge["photoURL"] as? String else {
            completion(UIImage())

            return
            
        }
        guard let photosURL = URL(string: photosURLString) else {
            completion(UIImage())

            return
            
        }
        URLSession.shared.dataTask(with: photosURL) { photosData, photosResponse, photosError in
            if photosError == nil && photosResponse != nil && photosData != nil {
                guard let photosData = photosData else {
                    completion(UIImage())
                    return
                }
                completion(UIImage(data: photosData) ?? UIImage())
                
            }
            else {
                completion(UIImage())
                return
            }
        }.resume()
    }
    
    public static func createNLPSummaries(plant: String, completion: @escaping (String) -> ()) {
        do {
            guard let nlpSummariesURL = URL(string: "https://api-inference.huggingface.co/models/facebook/bart-large-cnn") else {
                completion("Error Getting Information About Plant")
                return
                
            }
            var nlpSummariesURLRequest = URLRequest(url: nlpSummariesURL)
            
            nlpSummariesURLRequest.addValue("Bearer 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", forHTTPHeaderField: "Authorization")
            nlpSummariesURLRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            nlpSummariesURLRequest.httpMethod = "POST"
            nlpSummariesURLRequest.httpBody = try JSONSerialization.data(withJSONObject: ["inputs": plant], options: .withoutEscapingSlashes)
            
            URLSession.shared.dataTask(with: nlpSummariesURLRequest) { nlpSummariesData, nlpSummariesResponse, nlpSummariesError in
                if nlpSummariesError == nil && nlpSummariesResponse != nil && nlpSummariesData != nil {
                    do {
                        guard let nlpPlantData = try JSONSerialization.jsonObject(with: nlpSummariesData ?? Data()) as? [[String:Any]] else {
                            completion("Error Getting Information About Plant")
                            return
                        }
                        guard let nlpSummaryText = nlpPlantData.first?["summary_text"] as? String else {
                            completion("Error Getting Information About Plant")
                            return
                            
                        }
                        completion(nlpSummaryText)
                        return
                    }
                    catch {
                        completion("Error Getting Information About Plant")
                        return
                    }
                }
                else {
                    completion("Error Getting Information About Plant")
                    return
                }
            }.resume()
        }
        catch {
            completion("Error Getting Information About Plant")
            return
        }
    }
    
    
}
