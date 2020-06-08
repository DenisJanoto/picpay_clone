//
//  paymentModel.swift
//  Desafio_PicPay
//
//  Created by Denis Janoto on 31/05/20.
//  Copyright © 2020 Denis Janoto. All rights reserved.
//


/**
 response htttp post from api server is encoded here
 */

import Foundation

struct decoderPostData: Codable {
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

struct UserModel: Codable {
    let id: Int?
    let name: String?
    let img: String?
    let username: String?
}
