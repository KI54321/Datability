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
  let challengesCompleted: Int
  let email: String
  let moneyTilNextPayment: Double
  let phoneNumber: String
  let totalMoneyEarned: Double
  let totalSnapsTaken: Int
}

