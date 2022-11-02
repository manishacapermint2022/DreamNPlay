//
//  ScoreCardModel.swift
//  DreamPlay
//
//  Created by MAC on 12/07/21.
//

import UIKit

class ScoreCardModel: NSObject {
    
    public struct Item {
       
        var name: String
        

        public init(name: String) {
            self.name = name
            
            
        }
    }

    public struct Sections {
       
        var teamName: String
        var overs:String
        var score:String
        var items: [Item]
        var collapsed: Bool
        
        public init(name: String,over:String,score:String,items: [Item], collapsed: Bool = true) {
            self.teamName = name
            self.overs = over
            self.score = score
            self.items = items
            self.collapsed = collapsed
        }
    }

}
