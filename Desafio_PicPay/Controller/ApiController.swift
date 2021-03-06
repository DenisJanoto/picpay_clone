//
//  ApiController.swift
//  Desafio_PicPay
//
//  Created by Denis Janoto on 24/05/20.
//  Copyright © 2020 Denis Janoto. All rights reserved.
//


/**
 class responsible to interact with api aerver
 */

import Foundation
import Alamofire

class ApiController{
    
    private static let session = URLSession.shared
    
    
    //get
    class func loadData(onComplete:@escaping ([decoderGetData]?)->Void){
        let urlCompleta="http://careers.picpay.com/tests/mobdev/users"
        
        
        guard let url = URL(string: urlCompleta)else{
            onComplete(nil)
            return}
        
        //Recebe os dados do servidor
        let dataTask = session.dataTask(with: url) { (data:Data?, response:URLResponse?, error) in
            if error == nil{
                guard let response = response as? HTTPURLResponse else{
                    print("ERRO2")
                    onComplete(nil)
                    return}
                //se resposta for ok
                if response.statusCode == 200{
                    //Armazenar os dados do servidor na variavel data
                    guard let data = data else{return}
                    
                    //Tranformar json em array
                    do{
                        let dados = try JSONDecoder().decode([decoderGetData]?.self, from: data)
                        onComplete(dados)
                    }catch{
                        print("ERRO3",error)
                        onComplete(nil)
                    }
                }else{
                    print("Algum status inválido no servidor!!")
                    onComplete(nil)
                }
            }else{
                print("ERRO1")
                onComplete(nil)
            }
        }
        dataTask.resume()
    }
    
    
    //post
    class func saveOperation(operation:encoderPostData, onComplete:@escaping (decoderPostData)->Void){
        AF.request("http://careers.picpay.com/tests/mobdev/transaction", method: .post, parameters: operation, encoder: JSONParameterEncoder.default).response { response in
            switch response.result {
            case .success:
                //show all returned information
                let dados = response.data
                
                //decode response information from post
                do {
                    let model = try JSONDecoder().decode(decoderPostData.self, from: dados!)
                                  onComplete(model)
                              } catch {
                                print("decode error")
                              }
            case .failure:
                print("error")
            }
        }
    }
}
