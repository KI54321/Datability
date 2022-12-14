//
//  DatabilityFetchFirestoreProfile.swift
//  Datability
//
//  Created by Pranit Agrawal on 9/2/22.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import UIKit

struct DatabilityFetchFirestoreProfile {
    
    public static func fetchProfileData() -> DatabilityUser? {
      /*  guard let currentUID = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(currentUID).getDocument { dataSnapshot, dataSnapshotError in
            if dataSnapshotError == nil && dataSnapshot {
                dataSnapshot.data(as: DatabilityUser.self)
            }
        }
       */
        
        guard let fullName = UserDefaults.standard.object(forKey: "fullNameLocal") as? String else { return nil }
        guard let challengesCompleted = UserDefaults.standard.object(forKey: "challengesCompletedLocal") as? Int else { return nil }
        guard let email = UserDefaults.standard.object(forKey: "emailLocal") as? String else { return nil }
        guard let moneyTilNextPayment = UserDefaults.standard.object(forKey: "moneyTilNextPaymentLocal") as? Double else { return nil }
        guard let phoneNumber = UserDefaults.standard.object(forKey: "phoneNumberLocal") as? String else { return nil }
        guard let totalMoneyEarned = UserDefaults.standard.object(forKey: "totalMoneyEarnedLocal") as? Double else { return nil }
        guard let totalSnapsTaken = UserDefaults.standard.object(forKey: "totalSnapsTakenLocal") as? Int else { return nil }


        return DatabilityUser(fullNameLocal: fullName, challengesCompletedLocal: challengesCompleted, emailLocal: email, moneyTilNextPaymentLocal: moneyTilNextPayment, phoneNumberLocal: phoneNumber, totalMoneyEarnedLocal: totalMoneyEarned, totalSnapsTakenLocal: totalSnapsTaken)
                
        
    }
    
    public static func fetchDatabilityChallenges(completion: @escaping ([[String:Any]]) -> ()) {
        Firestore.firestore().collection("challenges").getDocuments { docSnapshots, docError in
            if docError == nil && docSnapshots != nil {
                var docSnapshotsData = [[String:Any]]()
                for oneSnapshot in (docSnapshots?.documents ?? []) {
                    docSnapshotsData.append(oneSnapshot.data())
                }
                
                
                completion(docSnapshotsData)
            }
            else {
                completion([])
            }
        }
 
        
    }
    
}
