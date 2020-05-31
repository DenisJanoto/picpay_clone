//
//  sendJsonData.swift
//  Desafio_PicPay
//
//  Created by Denis Janoto on 28/05/20.
//  Copyright © 2020 Denis Janoto. All rights reserved.
//

import Foundation

struct encoderPostData: Codable {
    var cardNumber: String?
    var cvv: Int?
    var value: Double?
    var expiryDate: String?
    var destinationUserId: Int?
    
    private enum CodingKeys: String, CodingKey {
        case cardNumber = "card_number"
        case cvv = "cvv"
        case value = "value"
        case expiryDate = "expiry_date"
        case destinationUserId = "destination_user_id"
    }
}
