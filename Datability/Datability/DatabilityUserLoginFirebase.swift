//
//  DatabilityUserLogin.swift
//  Datability
//
//  Created by Krish Iyengar on 9/2/22.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

struct DatabilityUserLoginFirebase {
    public static func uploadUser(dataTextName: String, dataTextEmail: String, dataTextPhoneNumber: String ) {
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        // Done onboarding

        Firestore.firestore().collection("users").document(currentUserID).setData(["fullNameLocal": dataTextName, "emailLocal": dataTextEmail, "challengesCompletedLocal": 0.0, "moneyTilNextPaymentLocal": 0.0, "phoneNumberLocal": dataTextPhoneNumber, "totalMoneyEarnedLocal": 0.0, "totalSnapsTakenLocal": 0.0])
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
                    
                    UserDefaults.standard.set(dataDatabilityUser.fullName, forKey: "fullNameLocal")
                    UserDefaults.standard.set(dataDatabilityUser.email, forKey: "emailLocal")
                    UserDefaults.standard.set(dataDatabilityUser.challengesCompleted, forKey: "challengesCompletedLocal")
                    UserDefaults.standard.set(dataDatabilityUser.moneyTilNextPayment, forKey: "moneyTilNextPaymentLocal")
                    UserDefaults.standard.set(dataDatabilityUser.phoneNumber, forKey: "phoneNumberLocal")
                    UserDefaults.standard.set(dataDatabilityUser.totalMoneyEarned, forKey: "totalMoneyEarnedLocal")
                    UserDefaults.standard.set(dataDatabilityUser.totalSnapsTaken, forKey: "totalSnapsTakenLocal")
                }
                catch {
                    
                }
            }
        }
    }
}
