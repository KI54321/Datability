//
//  DatabilityUserLogin.swift
//  Datability
//
//  Created by Krish Iyengar on 9/2/22.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import CoreLocation

struct DatabilityUserLoginFirebase {
    public static func uploadUser(dataTextName: String, dataTextEmail: String, dataTextPhoneNumber: String, password: String) {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        // Done onboarding

        Firestore.firestore().collection("users").document(currentUserID).setData(["fullNameLocal": dataTextName, "emailLocal": dataTextEmail, "challengesCompletedLocal": 0.0, "moneyTilNextPaymentLocal": 0.0, "phoneNumberLocal": dataTextPhoneNumber, "totalMoneyEarnedLocal": 0.0, "totalSnapsTakenLocal": 0.0, "password": password])
    }
    public static func getUser(currentUserID: String) {
        // Done onboarding

        Firestore.firestore().collection("users").document(currentUserID).getDocument { dataDocSnapshot, dataDocError in
            if dataDocError == nil && dataDocSnapshot != nil {
                guard let dataDocSnapshot = dataDocSnapshot else {
                    return
                }

                do {
                    let dataDatabilityUser = try dataDocSnapshot.data(as: DatabilityUser.self)
                    
                    UserDefaults.standard.set(dataDatabilityUser.fullNameLocal, forKey: "fullNameLocal")
                    UserDefaults.standard.set(dataDatabilityUser.emailLocal, forKey: "emailLocal")
                    UserDefaults.standard.set(dataDatabilityUser.challengesCompletedLocal, forKey: "challengesCompletedLocal")
                    UserDefaults.standard.set(dataDatabilityUser.moneyTilNextPaymentLocal, forKey: "moneyTilNextPaymentLocal")
                    UserDefaults.standard.set(dataDatabilityUser.phoneNumberLocal, forKey: "phoneNumberLocal")
                    UserDefaults.standard.set(dataDatabilityUser.totalMoneyEarnedLocal, forKey: "totalMoneyEarnedLocal")
                    UserDefaults.standard.set(dataDatabilityUser.totalSnapsTakenLocal, forKey: "totalSnapsTakenLocal")
                }
                catch {
                    
                }
            }
        }
    }
    
    public static func getMapCoordinates(completion: @escaping ([CLLocation]) -> ()) {
        
        var allMapCoordinates = [CLLocation]()
        Firestore.firestore().collection("challenges").getDocuments { allDocSnapshot, allDocError in
            if allDocError == nil && allDocSnapshot != nil {
                for eachDoc in (allDocSnapshot?.documents ?? []) {
                    eachDoc.reference.collection("entries").getDocuments { allDocEntrieSnapshot, allDocEntrieError in
                        if allDocEntrieError == nil && allDocEntrieSnapshot != nil {
                            for oneEntrieDocSnap in (allDocEntrieSnapshot?.documents ?? []) {
                                if (oneEntrieDocSnap.get("host") as? String ?? "ERROR") == (Auth.auth().currentUser?.uid ?? "User_Error") {
                                    allMapCoordinates.append(CLLocation(latitude: (oneEntrieDocSnap.get("lat") as? Double ?? 0.0), longitude: (oneEntrieDocSnap.get("long") as? Double ?? 0.0)))
                                }
                            }
                        }
                    }
                }
                
                completion(allMapCoordinates)
                return
            }
            else {
                completion([])
                return
            }
        }
    }
}
