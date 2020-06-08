//
//  PagamentoViewController.swift
//  Desafio_PicPay
//
//  Created by Denis Janoto on 28/05/20.
//  Copyright © 2020 Denis Janoto. All rights reserved.
//


/**
 class responsible to execute the payment. the post is sended to api server with data card and value from payment.
 if post response is successful, the reciboViewController is called.
 */

import UIKit
import Kingfisher
import CurrencyTextField

class PagamentoViewController: UIViewController {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var lblEditar: UILabel!
    @IBOutlet weak var cardNumber: UILabel!
    @IBOutlet weak var txtValue: CurrencyTextField!
    @IBOutlet weak var lblPagamentoRecusado: UILabel!
    
    
    //user data
    var receivedUserName:String!
    var receivedUrlImagem:String!
    var receivedUserId:Int!
    
    //kingfisher
    var resource:ImageResource!
    
    
    //card data
    var receivedCardNumber:String!
    var receivedRegisteredCardName:String!
    var receivedExpirationDateCard:String!
    var receivedCvvCardNumber:String!
    
    //transaction data
    var transactionNumber:String!
    
    
    //read core data after info card is edited
    override func viewWillAppear(_ animated: Bool) {
        //read data from core data
        CoreDataController.selectCard()
        
        receivedCardNumber = CoreDataController.LocalcardNumber
        receivedRegisteredCardName = CoreDataController.LocalcardName
        receivedExpirationDateCard = CoreDataController.LocalcardEspirationDate
        receivedCvvCardNumber = CoreDataController.LocasCvvCardNumber
        setViewInformation()

    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureNavigationBar()
        configureLabels()
        
    }
    
    //view settings
    func configureView(){
        //change background color
        view.backgroundColor = UIColor(named: "backGroundColor")
        
        //change text view placeholder color
        txtValue.attributedPlaceholder = NSAttributedString(string: "0,00",
                                                            attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "defaultItensColor") ?? UIColor.white])
    }
    
    //navigation bar settings
    func configureNavigationBar(){
        //change navigation bar color
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor(named: "backGroundColor")
    }
    
    //label settings
    func configureLabels(){
        userName.textColor = UIColor.white
        lblEditar.textColor = UIColor(named: "defaultItensColor")
        cardNumber.textColor = UIColor.white
        
        
        self.lblEditar.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.labelTapped))
        self.lblEditar.addGestureRecognizer(tap)
    }
    
    //label edit clicked
    @objc func labelTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        CadastrarCartoesViewController.isEdit = true
        performSegue(withIdentifier: "seguePagamento", sender: nil)
    }
    
    
    //send card data to edit card view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seguePagamento"{
            let destino = segue.destination as! CadastrarCartoesViewController
            destino.cardNumber = receivedCardNumber
            destino.nameRegisteredCard = receivedRegisteredCardName
            destino.expirationDate = receivedExpirationDateCard
            destino.cvvNumber = receivedCvvCardNumber
        }
        
        //send data to recibo view controller
        if segue.identifier == "segueRecibo"{
            let nav = segue.destination as! UINavigationController
            let destino = nav.topViewController as! ReciboViewController
            destino.imagem_usuario = resource
            destino.nome_suario = receivedUserName
            destino.numero_transacao = transactionNumber
            destino.numero_cartao = receivedCardNumber
            destino.valor_total = txtValue.text
        }
    }
    
    
    //pay button
    @IBAction func btnPagar(_ sender: Any) {
        
        //new object to send to server by post method
        var saveData = encoderPostData()
        saveData.cardNumber = receivedCardNumber
        saveData.cvv = Int(receivedCvvCardNumber) ?? 0
        saveData.value = (txtValue.text! as NSString).doubleValue
        saveData.expiryDate = receivedExpirationDateCard
        saveData.destinationUserId = Int(receivedUserId)
        
        
        ApiController.saveOperation(operation: saveData) { (success) in
            if success.transaction?.status == "Recusada"{
                self.lblPagamentoRecusado.isHidden = false
            }else{
                self.transactionNumber = "\(success.transaction?.id ?? 0)"
                self.lblPagamentoRecusado.isHidden = true
                
                //show rebido screen
                self.performSegue(withIdentifier: "segueRecibo", sender: nil)
                
            }
        }
        
        
    }
    
    
    
    func setViewInformation(){
        //set user name
        userName.text = receivedUserName
        
        //get the last 4 digits card
        let finalCard = receivedCardNumber.suffix(4)
        //set card number
        cardNumber.text = "Cartão Final - \(finalCard)"
        
        //set user image
        getImageFromApi()
        
    }
    
    
    //kingfisher image download
    func getImageFromApi(){
        if let url = URL.init(string:self.receivedUrlImagem){
            resource = ImageResource(downloadURL: url, cacheKey: self.receivedUrlImagem)
            userImage.kf.indicatorType = .activity //Placeholder nas imagens antes de carregar
            userImage.kf.setImage(with: resource)
            
        }else{
            print("no image")
            userImage.image = nil
        }
        
        userImage.layer.cornerRadius = userImage.frame.size.height/2 //Deixa imagem redonda
    }
    
    //hide keyboard when screen es touched
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

