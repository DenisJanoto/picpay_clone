//
//  ContatosTableView.swift
//  Desafio_PicPay
//
//  Created by Denis Janoto on 24/05/20.
//  Copyright © 2020 Denis Janoto. All rights reserved.
//

import UIKit



class ContatosTableView: UITableViewController,UISearchBarDelegate {
    
    
    var x:Int = 1
    var dadosRecebidos:[receivedJson]=[]
    var dadosFiltrados:[receivedJson]=[]
    var nomeUsuario:[String]=[]
    var imagemUsuario:[String]=[]
    var idUsuario:[String]=[]
    
    var contatosFiltrados:[receivedJson]=[]
    var arrayNomes:[String]=[]
    let searchController = UISearchController(searchResultsController: nil)
    var searchActive = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //CONFIGURE SEARCHBAR
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movies"
        searchController.searchBar.sizeToFit()
        searchController.searchBar.becomeFirstResponder()
        navigationItem.searchController = searchController
        
        //API SERVICES
        callApi()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.hidesBarsOnSwipe = true
    }
    
    
    //SEARCHBAR - FILTRA ARRAY DE OBJETOS(CONTATOS)
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
    
    
    func callApi(){
        ApiController.loadData(page: x) { (response_) in
            if let dados = response_{
                self.dadosRecebidos=dados
                self.dadosFiltrados = dados
            }
            
            //UTILIZADO PARA SEARCHBAR
            for dados in self.dadosRecebidos{
                self.nomeUsuario.append(dados.name)
                self.imagemUsuario.append(dados.img)
                self.idUsuario.append(dados.username)
            }
            
            //NECESSÁRIO POIS A TABLE VIEW É CARREGADA ANTES DOS DADOS SEREM BAIXADOS TOTALMENTE
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
        
        if searchActive == false{
            cell.prepararCelula(contatos: dadosRecebidos[indexPath.row])
            return cell
        }else{
            cell.prepararCelula(contatos: dadosFiltrados[indexPath.row])
            return cell
        }
    }
}
