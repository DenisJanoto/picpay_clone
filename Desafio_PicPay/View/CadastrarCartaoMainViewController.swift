//
//  CadastrarCartaoMainViewController.swift
//  
//
//  Created by Denis Janoto on 25/05/20.
//


/**
 screen showed before saveDataCard screen
 */

import UIKit

class CadastrarCartaoMainViewController: UIViewController {
    
    @IBOutlet weak var labelTitulo: UILabel!
    @IBOutlet weak var labelSubtitulo: UILabel!


    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //change background color
        self.view.backgroundColor = UIColor(named: "backGroundColor")

        //change navigation bar color
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor(named: "backGroundColor")
        
        //change navigation bar title color
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]

        //change label color
        labelTitulo.textColor = UIColor.white
        labelSubtitulo.textColor = UIColor.white
        
    }


    @IBAction func btnCadastrar(_ sender: Any) {
        performSegue(withIdentifier: "segueCadastrar", sender: nil)

    }
}
