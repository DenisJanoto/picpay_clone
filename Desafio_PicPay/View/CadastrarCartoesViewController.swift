//
//  CadastrarCartoesViewController.swift
//  Desafio_PicPay
//
//  Created by Denis Janoto on 25/05/20.
//  Copyright © 2020 Denis Janoto. All rights reserved.
//

import UIKit
import TextFieldEffects

class CadastrarCartoesViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var labelCadastrarCartao: UILabel!
    @IBOutlet weak var txtNumeroCartao: HoshiTextField!
    @IBOutlet weak var txtNomeTitular: HoshiTextField!
    @IBOutlet weak var txtVencimento: HoshiTextField!
    @IBOutlet weak var txtCvv: HoshiTextField!
    @IBOutlet weak var viewScroll: UIView!
    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var btnOutletSalvar: UIButton!
    
    
    static var isEdit = false

    
    //card data
    var cardNumber:String?
    var nameRegisteredCard:String?
    var expirationDate:String?
    var cvvNumber:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureLabels()
        configureTextFields()
        configureNavigationBar()
        configureButton()
    }
    
    func configureView(){
        viewScroll.becomeFirstResponder()
        viewScroll.isUserInteractionEnabled = true
        
        //change background view color
        view.backgroundColor = UIColor(named: "backGroundColor")
        viewScroll.backgroundColor = UIColor(named: "backGroundColor")
        
        //make clicable scrollview (like touchBegan)
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CadastrarCartoesViewController.tapRecognized))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        myScrollView.addGestureRecognizer(singleTapGestureRecognizer)
        
    }
    
    //hide keyboard
    @objc func tapRecognized() {
        view.endEditing(true)
    }
    
    
    //buttonSettings
    func configureButton(){
        //change button title
        if CadastrarCartoesViewController.isEdit == false{
            btnOutletSalvar.setTitle("Cadastrar Cartão", for: .normal)
        }else{
            btnOutletSalvar.setTitle("Salvar Alteração", for: .normal)

        }
        
    }
    
    //label settings
    func configureLabels(){
        //change label color
        labelCadastrarCartao.textColor = UIColor.white
    }
    
    //textfield settings
    func configureTextFields(){
        
        //set textfield with registered card values
        
        txtNumeroCartao.text = cardNumber
        txtNomeTitular.text = nameRegisteredCard
        txtVencimento.text = expirationDate
        txtCvv.text = cvvNumber

        txtNumeroCartao.delegate = self
        txtNomeTitular.delegate = self
        txtVencimento.delegate = self
        txtCvv.delegate = self
        
        txtNumeroCartao.becomeFirstResponder()
        
        //textfield card number
       // txtNumeroCartao.keyboardType = .numberPad
        txtNumeroCartao.placeholderColor = UIColor.white
        txtNumeroCartao.borderActiveColor = UIColor.white
        txtNumeroCartao.borderInactiveColor = UIColor.lightGray
        txtNumeroCartao.textColor = UIColor.white
        
        //textfield card user name
       // txtNomeTitular.keyboardType = .numberPad
        txtNomeTitular.placeholderColor = UIColor.white
        txtNomeTitular.borderActiveColor = UIColor.white
        txtNomeTitular.borderInactiveColor = UIColor.lightGray
        txtNomeTitular.textColor = UIColor.white
        
        //textfield card finish date
       // txtVencimento.keyboardType = .numberPad
        txtVencimento.placeholderColor = UIColor.white
        txtVencimento.borderActiveColor = UIColor.white
        txtVencimento.borderInactiveColor = UIColor.lightGray
        txtVencimento.textColor = UIColor.white
        
        //textfield card cvv number
      //  txtCvv.keyboardType = .numberPad
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
    
    
    //textfield return button clicked
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //jump to the next textfields
        if textField == txtNumeroCartao{
            txtNomeTitular.becomeFirstResponder()
        }
        
        if textField == txtNomeTitular{
            txtVencimento.becomeFirstResponder()
        }
        
        if textField == txtVencimento{
            txtCvv.becomeFirstResponder()
        }
        
        if textField == txtCvv{
            view.endEditing(true)
        }
        return true
    }
    
    //button save card
    @IBAction func btnCadastrarCartao(_ sender: Any) {
        CoreDataController.saveCard(cardNumber: txtNumeroCartao.text!, name: txtNomeTitular.text!, expirationDate: txtVencimento.text!, cvvNumber: txtCvv.text!)
    }
    
}
