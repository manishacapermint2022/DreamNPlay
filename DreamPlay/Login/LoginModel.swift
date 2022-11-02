//
//  LoginModel.swift
//  DreamPlay
//
//  Created by MAC on 23/06/21.
//

import UIKit

struct LoginModel : Codable {
    
    let status: String?
    let msg: String?
    
    let data: SData?
}

struct SData : Codable {
    
    let userId: String?
    let fullName: String?
    let email: String?
    let city:String?
    let address: String?
    let contactNumber: String?
  
    
    
    
}
