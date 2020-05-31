//
//  CoreDataController.swift
//  Desafio_PicPay
//
//  Created by Denis Janoto on 27/05/20.
//  Copyright © 2020 Denis Janoto. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataController{
    static var LocalcardNumber:String?
    static var LocalcardName:String?
    static var LocalcardEspirationDate:String?
    static var LocasCvvCardNumber:String?
    
    //save card data
    class func saveCard(cardNumber:String, name:String, expirationDate:String, cvvNumber:String){
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let card = NSEntityDescription.insertNewObject(forEntityName: "Card", into: context)
        
        card.setValue(cardNumber, forKey: "cardNumber")
        card.setValue(name, forKey: "cardRegisteredName")
        card.setValue(expirationDate, forKey: "expirationDate")
        card.setValue(cvvNumber, forKey: "cvvNumber")
        
        do {
            try context.save()
            print("saved data")
        } catch{
            print("no saved data - error")
        }
    }
    
    
    
    //select card data
    class func selectCard()->Bool{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        
        let requisition = NSFetchRequest<NSFetchRequestResult>(entityName: "Card")        
        do {
            let card = try context.fetch(requisition)
            if card.count > 0{
                for card in card as! [NSManagedObject]{
                    
                    LocalcardNumber = card.value(forKey: "cardNumber") as? String
                    LocalcardName = card.value(forKey: "cardRegisteredName") as? String
                    LocalcardEspirationDate = card.value(forKey: "expirationDate") as? String
                    LocasCvvCardNumber = card.value(forKey: "cvvNumber") as? String
                    
                }
                return true
            }else{
                return false
            }
        } catch{
            print("select data error")
        }
        return false
        
        
        
        
        
        
    }
}
