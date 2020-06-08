//
//  receivedJson.swift
//  Desafio_PicPay
//
//  Created by Denis Janoto on 24/05/20.
//  Copyright © 2020 Denis Janoto. All rights reserved.
//


/**
all data received to api server is decoded here
*/

import Foundation

struct decoderGetData: Codable {
    let id: Int
    let name: String
    let img: String
    let username: String
}
