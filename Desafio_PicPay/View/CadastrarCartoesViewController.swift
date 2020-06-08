//
//  CadastrarCartoesViewController.swift
//  Desafio_PicPay
//
//  Created by Denis Janoto on 25/05/20.
//  Copyright © 2020 Denis Janoto. All rights reserved.
//


/**
 class responsible to save and edit card info
 */

import UIKit
import GPSMaskTextField


class CadastrarCartoesViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var labelCadastrarCartao: UILabel!
    @IBOutlet weak var txtNumeroCartao: GPSMaskTextField!
    @IBOutlet weak var txtNomeTitular: GPSMaskTextField!
    @IBOutlet weak var txtVencimento: GPSMaskTextField!
    @IBOutlet weak var txtCvv: GPSMaskTextField!
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
    
    //MARK: configure view
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
    
    //MARK: hide keyboard
    @objc func tapRecognized() {
        view.endEditing(true)
    }
    
    
    //MARK: buttonSettings
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
    
    //MARK: textfield settings
    func configureTextFields(){
        
        //txt cardnumber is selected when start
        txtNumeroCartao.becomeFirstResponder()
        
        
        //set textfield with registered card values (when user edit info)
        txtNumeroCartao.text = cardNumber
        txtNomeTitular.text = nameRegisteredCard
        txtVencimento.text = expirationDate
        txtCvv.text = cvvNumber
        
        
        //textfield card number
        txtNumeroCartao.textColor = UIColor.white
        txtNumeroCartao.attributedPlaceholder = NSAttributedString(string: "Número do Cartão",
                                                                   attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        let configTxtNumeroCartao = GPSMaskTextField()
        configTxtNumeroCartao.customMask = "####.####.####.####"
        configTxtNumeroCartao.maximumSize = 16
        txtNumeroCartao.customMask = configTxtNumeroCartao.customMask
        txtNumeroCartao.maximumSize = configTxtNumeroCartao.maximumSize
        
        //textfield card username
        txtNomeTitular.textColor = UIColor.white
        txtNomeTitular.attributedPlaceholder = NSAttributedString(string: "Nome do Titular",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        //textfield card finish date
        txtVencimento.textColor = UIColor.white
        txtVencimento.attributedPlaceholder = NSAttributedString(string: "Vencimento",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        let configTxtVencimento = GPSMaskTextField()
        configTxtVencimento.customMask = "##/##"
        configTxtVencimento.maximumSize = 4
        txtVencimento.customMask = configTxtVencimento.customMask
        txtVencimento.maximumSize = configTxtVencimento.maximumSize
        
        //textfield card cvv number
        txtCvv.textColor = UIColor.white
        txtVencimento.attributedPlaceholder = NSAttributedString(string: "CVV",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        let configTxtCvv = GPSMaskTextField()
        configTxtCvv.maximumSize = 3
        txtCvv.maximumSize = configTxtCvv.maximumSize
        
    }
    
    
    //MARK: navigationbar settings
    func configureNavigationBar(){
        
        //change navigation bar color
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor(named: "backGroundColor")
        
        //remove back button title
        self.navigationController!.navigationBar.topItem!.title = ""
        
    }
    
    
    //MARK: textfield "return" button clicked
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
    
    //MARK: button save card
    @IBAction func btnCadastrarCartao(_ sender: Any) {
        
        //remove "dots" from card number
        let cardNumberFormated = txtNumeroCartao.text!.replacingOccurrences(of: ".", with: "")
        
        CoreDataController.saveCard(cardNumber: cardNumberFormated, name: txtNomeTitular.text!, expirationDate: txtVencimento.text!, cvvNumber: txtCvv.text!)
        
        //back to payment view
        navigationController?.popViewController(animated: true)
    }
    
}
