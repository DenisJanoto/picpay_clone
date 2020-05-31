//
//  ContatosTableView.swift
//  Desafio_PicPay
//
//  Created by Denis Janoto on 24/05/20.
//  Copyright © 2020 Denis Janoto. All rights reserved.
//

import UIKit
import CoreData



class ContatosTableView: UITableViewController,UISearchBarDelegate {
    
    var x:Int = 1
    var dadosRecebidos:[receivedJson]=[]
    var dadosFiltrados:[receivedJson]=[]
    var senderUserInformation:receivedJson?
    var nomeUsuario:[String]=[]
    var imagemUsuario:[String]=[]
    var idUsuario:[String]=[]
    
    var contatosFiltrados:[receivedJson]=[]
    var arrayNomes:[String]=[]
    let searchController = UISearchController(searchResultsController: nil)
    var searchActive = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//DELETE COREDATA
//        let appDel:AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
//        let context:NSManagedObjectContext = appDel.persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Card")
//        fetchRequest.returnsObjectsAsFaults = false
//
//        do
//        {
//            let results = try context.fetch(fetchRequest)
//            for managedObject in results
//            {
//                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
//                context.delete(managedObjectData)
//                try context.save()
//            }
//        } catch let error as NSError {
//            print("Deleted all my data in myEntity error : \(error) \(error.userInfo)")
//        }
        
        
        
        //settings
        configureSearchBar()
        configureTableView()
        configureStatusBar()
        
        //api services
        callApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //settings
        configureNavigationBar()
    }
    
    //status bar settings
    func configureStatusBar(){
        //change status bar color
        if #available(iOS 13, *){
            let statusBar = UIView(frame: (UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame)!)
            statusBar.backgroundColor = UIColor(named: "backGroundColor")
            UIApplication.shared.keyWindow?.addSubview(statusBar)
        } else {
            // ADD THE STATUS BAR AND SET A CUSTOM COLOR
            let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
            if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
                statusBar.backgroundColor = UIColor(named: "backGroundColor")
            }
            UIApplication.shared.statusBarStyle = .lightContent
        }
    }
    
    //navigation bar settings
    func configureNavigationBar(){
        navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    //tableview settings
    func configureTableView(){
        //change tableview color
        tableView.backgroundColor = UIColor(named: "backGroundColor")
    }
    
    //searchbar settings
    func configureSearchBar(){
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movies"
        searchController.searchBar.sizeToFit()
        searchController.searchBar.becomeFirstResponder()
        //add search bar in navigation bar
        navigationItem.searchController = searchController
        
        //change searchbar text color
        let textField = searchController.searchBar.searchTextField
        textField.textColor = UIColor.white
        
    }
    
    
    //search bar text changed
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        dadosFiltrados = dadosRecebidos
        
        if searchText.isEmpty{
            searchActive = false
            tableView.reloadData()
        }else{
            searchActive=true
            dadosFiltrados = dadosFiltrados.filter({(dados) -> Bool in
                let x = dados.name.range(of:searchText,options: .caseInsensitive)
                return x != nil
            })
            tableView.reloadData()
        }
    }
    
    //search bar cancel button clicked - reload all data in tableview
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        tableView.reloadData()
    }
    
    
    //call api data
    func callApi(){
        ApiController.loadData(page: x) { (response_) in
            if let dados = response_{
                self.dadosRecebidos=dados
                self.dadosFiltrados = dados
            }
            
            //utilized for search bar
            for dados in self.dadosRecebidos{
                self.nomeUsuario.append(dados.name)
                self.imagemUsuario.append(dados.img)
                self.idUsuario.append(dados.username)
            }
            
            //tableview reload after download data
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive{
            return dadosFiltrados.count
        }else{
            return dadosRecebidos.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celula", for: indexPath) as! CustomViewCell
        cell.contentView.backgroundColor = UIColor(named: "backGroundColor")
        if searchActive == false{
            cell.prepararCelula(contatos: dadosRecebidos[indexPath.row])
            return cell
        }else{
            cell.prepararCelula(contatos: dadosFiltrados[indexPath.row])
            return cell
        }
    }
    
    //cell selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let isRegistered:Bool
        
        isRegistered = CoreDataController.selectCard()
        
        
        if isRegistered == true{
            if searchActive == false{
                senderUserInformation = dadosRecebidos[indexPath.row]
                performSegue(withIdentifier: "seguePagamento", sender: nil)
            }else{
                senderUserInformation = dadosFiltrados[indexPath.row]
                performSegue(withIdentifier: "seguePagamento", sender: nil)
            }
        }else{
            //for new card register the button title is not changed
            CadastrarCartoesViewController.isEdit = false
            
            performSegue(withIdentifier: "segueCadastroCartao", sender: nil)
            print("no data recorded")
        }
    }
    
    //send data to pagamento view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seguePagamento"{
            let destino = segue.destination as! PagamentoViewController
            
            //send card data
            destino.receivedCardNumber = CoreDataController.LocalcardNumber
            destino.receivedRegisteredCardName = CoreDataController.LocalcardName
            destino.receivedExpirationDateCard = CoreDataController.LocalcardEspirationDate
            destino.receivedCvvCardNumber = CoreDataController.LocasCvvCardNumber
            
            //send user data
            destino.receivedUrlImagem = senderUserInformation?.img
            destino.receivedUserName = senderUserInformation?.username
            destino.receivedUserId = senderUserInformation?.id
            
            
            
        }
    }
}
