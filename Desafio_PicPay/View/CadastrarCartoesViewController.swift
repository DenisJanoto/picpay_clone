//
//  CadastrarCartoesViewController.swift
//  Desafio_PicPay
//
//  Created by Denis Janoto on 25/05/20.
//  Copyright © 2020 Denis Janoto. All rights reserved.
//

import UIKit
import TextFieldEffects

class CadastrarCartoesViewController: UIViewController {
    
    @IBOutlet weak var labelCadastrarCartao: UILabel!
    @IBOutlet weak var txtNumeroCartao: HoshiTextField!
    @IBOutlet weak var txtNomeTitular: HoshiTextField!
    @IBOutlet weak var txtVencimento: HoshiTextField!
    @IBOutlet weak var txtCvv: HoshiTextField!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //change background view color
        self.view.backgroundColor = UIColor(named: "backGroundColor")
        
        configureLabel()
        configureTextFields()
        configureNavigationBar()
    }
    
    
    //label settings
    func configureLabel(){
        
        //change label color
        labelCadastrarCartao.textColor = UIColor.white
    }
    
    //textfield settings
    func configureTextFields(){
        
        //textfield card number
        txtNumeroCartao.placeholderColor = UIColor.white
        txtNumeroCartao.borderActiveColor = UIColor.white
        txtNumeroCartao.borderInactiveColor = UIColor.lightGray
        txtNumeroCartao.textColor = UIColor.white
        
        //textfield card user name
        txtNomeTitular.placeholderColor = UIColor.white
        txtNomeTitular.borderActiveColor = UIColor.white
        txtNomeTitular.borderInactiveColor = UIColor.lightGray
        txtNomeTitular.textColor = UIColor.white
        
        //textfield card finish date
        txtVencimento.placeholderColor = UIColor.white
        txtVencimento.borderActiveColor = UIColor.white
        txtVencimento.borderInactiveColor = UIColor.lightGray
        txtVencimento.textColor = UIColor.white
        
        //textfield card cvv number
        txtCvv.placeholderColor = UIColor.white
        txtCvv.borderActiveColor = UIColor.white
        txtCvv.borderInactiveColor = UIColor.lightGray
        txtCvv.textColor = UIColor.white
    }
    
    
    //navigation bar settings
    func configureNavigationBar(){
        
        //change navigation bar color
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor(named: "backGroundColor")
        
        //remove back button title
        self.navigationController!.navigationBar.topItem!.title = ""
        
    }
    
    
    
    //button save card
    @IBAction func btnCadastrarCartao(_ sender: Any) {
        
        
    }
    
    
}
