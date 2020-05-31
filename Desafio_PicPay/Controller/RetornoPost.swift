//
//  RetornoPost.swift
//  Desafio_PicPay
//
//  Created by Denis Janoto on 31/05/20.
//  Copyright © 2020 Denis Janoto. All rights reserved.
//

import Foundation

struct RetornoPost: Codable {
    let transaction: Transaction?
}

struct Transaction: Codable {
    let id, timestamp: Int?
    let value: Double?
    let destinationUser: UserModel?
    let success: Bool?
    let status: String?
    
    enum CodingKeys: String, CodingKey {
        case id, timestamp, value
        case destinationUser = "destination_user"
        case success, status
    }
}
