//
//  Contatos.swift
//  Desafio_PicPay
//
//  Created by Denis Janoto on 24/05/20.
//  Copyright © 2020 Denis Janoto. All rights reserved.
//

import Foundation


class Contatos{
    
    var id: Int
    var name: String
    var img: String
    var userName: String
    
    
    init(id:Int,name:String,img:String,userName:String) {
        self.id = id
        self.name = name
        self.img = img
        self.userName = userName
    }
    
}
