//
//  SignUpModel.swift
//  DreamPlay
//
//  Created by MAC on 23/06/21.
//

import UIKit

class SignUpModel:Codable {
    var data:String?
    var responseData:SData?
    var status:Int?
    var message:String?
    
    init(datas:String,responseData:SData?,status:Int,message:String){
        self.data = datas
        self.responseData = responseData
        self.status = status
    }
    class ResultModel:Decodable{
        var message = [ResultModel]()
        init(message:[ResultModel]) {
            self.message = message
        }
    }
}
