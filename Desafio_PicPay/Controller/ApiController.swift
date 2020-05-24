//
//  ApiController.swift
//  Desafio_PicPay
//
//  Created by Denis Janoto on 24/05/20.
//  Copyright © 2020 Denis Janoto. All rights reserved.
//

import Foundation

class ApiController{
    
    private static let session = URLSession.shared
    
    
    //GET
    class func loadData(page:Int,onComplete:@escaping ([receivedJson]?)->Void){
        let urlCompleta="http://careers.picpay.com/tests/mobdev/users"
      
        
        guard let url = URL(string: urlCompleta)else{
            //Retorno para a closure o erro url contido no enum(carError)
            onComplete(nil)
            return}
        
        //Recebe os dados do servidor
        //OBS: a dataTask é executada em outra thread, liberando o usuário para uso simultaneo no app
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
                        let dados = try JSONDecoder().decode([receivedJson]?.self, from: data)
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
    
    
}
