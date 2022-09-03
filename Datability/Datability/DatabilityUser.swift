//
//  DatabilityUser.swift
//  Datability
//
//  Created by Pranit Agrawal on 9/2/22.
//

import FirebaseFirestoreSwift

struct DatabilityUser: Identifiable, Decodable {
    @DocumentID var id: String?
    let fullName: String
    let challengesCompleted: String
    let email: String
    let homeAddress: String
    let moneyTilNextPayment: String
    let phoneNumber: String
    let totalMoneyEarned: String
    let totalSnapsTaken: String
    
}

