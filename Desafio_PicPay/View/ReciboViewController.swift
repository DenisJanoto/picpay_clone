//
//  ReciboViewController.swift
//  Desafio_PicPay
//
//  Created by Denis Janoto on 31/05/20.
//  Copyright © 2020 Denis Janoto. All rights reserved.
//


/**
 class responsible to show the payment status
 */

import UIKit
import Kingfisher

class ReciboViewController: UIViewController {
    
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblData: UILabel!
    @IBOutlet weak var lblHora: UILabel!
    @IBOutlet weak var lblTransacao: UILabel!
    @IBOutlet weak var lblNumeroCartao: UILabel!
    @IBOutlet weak var lblValorTotal1: UILabel!
    @IBOutlet weak var lblValorTotal2: UILabel!
    @IBOutlet weak var lblAs: UILabel!
    @IBOutlet weak var lblTotalPago: UILabel!
    
    
    var imagem_usuario:ImageResource!
    var nome_suario:String!
    var numero_transacao:String!
    var numero_cartao:String!
    var valor_total:String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureNavigationBar()
        configureLabels()
    }
    
    
    //back to the first view controller (contact list)
    override func viewWillDisappear(_ animated: Bool) {
        performSegue(withIdentifier: "UnwindView", sender: nil)
        
    }
    
    
    func configureView(){
        //change background color
        view.backgroundColor = UIColor(named: "backGroundColor")
        
    }
    
    
    func configureNavigationBar(){
        //change navigation bar color
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor(named: "backGroundColor")
        
    }
    
    
    func configureLabels(){
        
        //set label collor
        lblUserName.textColor = UIColor.white
        lblData.textColor = UIColor.lightGray
        lblTransacao.textColor = UIColor.lightGray
        lblNumeroCartao.textColor = UIColor.white
        lblValorTotal1.textColor = UIColor.white
        lblTotalPago.textColor = UIColor.white
        lblValorTotal2.textColor = UIColor.white
        
        
        //image settings
        imgUser.kf.indicatorType = .activity
        imgUser.kf.setImage(with: imagem_usuario)
        imgUser.layer.cornerRadius = imgUser.frame.size.height/2 //Deixa imagem redonda
        
        //get the last 4 digits card
        let finalCard = numero_cartao.suffix(4)
        
        //set label data
        lblUserName.text = nome_suario
        lblData.text = getDate()
        lblTransacao.text = "Transação: \(numero_transacao ?? "Sem Valor")"
        lblNumeroCartao.text = "Cartão Final: \(finalCard)"
        lblValorTotal1.text = valor_total
        lblValorTotal2.text = valor_total

    }
    

    //get date
    func getDate() -> String {
        
        let date = Date()
        let calendar = Calendar.current
        
        let day = calendar.component(.day, from: date)
        let mounth = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        
        return ("\(day)/\(mounth)/\(year)  às  \(hour):\(minute)")
    }
    
}
