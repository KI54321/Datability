//
//  PlantScannerPost.swift
//  Datability
//
//  Created by Krish Iyengar on 9/3/22.
//

import Foundation
import UIKit

struct PlantScanner {
    public static func plantScanner(image: UIImage, completion: @escaping (String, String, String) -> ()) {
        guard let plantScannerURL = URL(string: "https://api.plant.id/v2/identify") else { return }
        var plantScannerURLRequest = URLRequest(url: plantScannerURL)
        
        plantScannerURLRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        plantScannerURLRequest.addValue("pBjKtY8kVH7888JrUCgfHK35PBvT3LRSOMTZ2Njt7JaDJeHQvn", forHTTPHeaderField: "Api-Key")
        plantScannerURLRequest.httpMethod = "POST"
        
        guard let plantScannerImageData = image.pngData()?.base64EncodedString(options: .lineLength64Characters) else { return }
        do {
            plantScannerURLRequest.httpBody = try JSONSerialization.data(withJSONObject: ["images": [plantScannerImageData], "modifiers": ["similar_images"], "plant_details": ["common_names", "url"]])
            URLSession.shared.dataTask(with: plantScannerURLRequest) { plantScannerDataURL, plantScannerDataURLResponse, plantScannerDataError in
                if plantScannerDataError == nil && plantScannerDataURLResponse != nil && plantScannerDataURL != nil {
                    guard let plantScannerData = plantScannerDataURL else { return }
                    do {
                        guard let currentPlantScannerResults = try (JSONSerialization.jsonObject(with: plantScannerData)) as? [String:Any] else { return }
                        guard let plantScannerResults = currentPlantScannerResults["suggestions"] as? [[String:Any]] else { return }
                        guard let plantScannerFirstResult = plantScannerResults.first?["plant_details"] as? [String:Any] else { return }
                        guard let plantScannerFirstResultImageStep1 = plantScannerResults.first?["similar_images"] as? [[String:Any]] else { return }
                        guard let plantScannerFirstResultImageURL = plantScannerFirstResultImageStep1.first?["url"] as? String else { return }
                        guard let plantScannerFirstResultName = plantScannerResults.first?["plant_name"] as? String else { return }
                        guard let plantScannerFirstResultWikiURL = plantScannerFirstResult["url"] as? String else { return }
                        
                        completion(plantScannerFirstResultName, plantScannerFirstResultWikiURL, plantScannerFirstResultImageURL)
                        return

                    }
                    catch {
                        completion("Magnolia virginiana", "https://en.wikipedia.org/wiki/Magnolia_virginiana", "https://plant-id.ams3.cdn.digitaloceanspaces.com/similar_images/images/ccb/d7f8601a008729d6f2368da32a1d7.jpg")
                        return
                       print(error)
                    }
                }
                else {
                    completion("Magnolia virginiana", "https://en.wikipedia.org/wiki/Magnolia_virginiana", "https://plant-id.ams3.cdn.digitaloceanspaces.com/similar_images/images/ccb/d7f8601a008729d6f2368da32a1d7.jpg")
                    return
                }
            }.resume()
        }
        catch {
            completion("Magnolia virginiana", "https://en.wikipedia.org/wiki/Magnolia_virginiana", "https://plant-id.ams3.cdn.digitaloceanspaces.com/similar_images/images/ccb/d7f8601a008729d6f2368da32a1d7.jpg")

            print("ERROR")
        }
    }
}
