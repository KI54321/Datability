//
//  DatabilityUser.swift
//  Datability
//
//  Created by Pranit Agrawal on 9/2/22.
//

import FirebaseFirestoreSwift

struct DatabilityUser: Identifiable, Decodable {
    @DocumentID public var id: String?
    public let fullNameLocal: String
    public let challengesCompletedLocal: Int
    public let emailLocal: String
    public let moneyTilNextPaymentLocal: Double
    public let phoneNumberLocal: String
    public var totalMoneyEarnedLocal: Double
    public let totalSnapsTakenLocal: Int
}

