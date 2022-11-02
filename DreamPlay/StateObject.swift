//
//  StateObject.swift
//  
//
//  Created by MAC on 28/06/21.
//

import UIKit

class StateObject: NSObject {
    var stateName: String?
    var stateId:Int?
   
    
    
    init(title: String,titleDescription:Int){
        self.stateName = title
        self.stateId = titleDescription
       
    }

}
