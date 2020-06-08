//
//  CustomViewCell.swift
//  Desafio_PicPay
//
//  Created by Denis Janoto on 24/05/20.
//  Copyright © 2020 Denis Janoto. All rights reserved.
//


/**
 class responsible to configure custom cell from tableview
 */

import UIKit
import Kingfisher

class CustomViewCell: UITableViewCell {
    
    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var name: UILabel!
    var urlImagem:String!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
 
    
    //MONTAR CELULA SEM A PESQUISA DA SEARCHBAR
    func prepararCelula(contatos:decoderGetData){
        urlImagem = contatos.img
        name.text = contatos.name
        userName.text = contatos.username
        
        kingFicher(pathImage: urlImagem)
    }

    //KINGFISHER DOWNLOAD IMAGE
    func kingFicher(pathImage:String){
        if let url = URL.init(string:self.urlImagem){
            let resource = ImageResource(downloadURL: url, cacheKey: self.urlImagem)
            imageUser.kf.indicatorType = .activity //Placeholder nas imagens antes de carregar
            imageUser.kf.setImage(with: resource)
        }else{
            imageUser.image = nil
        }
        imageUser.layer.cornerRadius = imageUser.frame.size.height/2 //Deixa imagem redonda
    }
}




