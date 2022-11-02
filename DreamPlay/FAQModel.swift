//
//  FAQModel.swift
//  DreamPlay
//
//  Created by MAC on 28/08/21.
//

import Foundation
import UIKit

struct Items: Codable {
    var name: String
    init(name: String) {
        self.name = name
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "title"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        name = try values.decode(String.self, forKey: .name)
    }
}

struct Sections : Codable{
   
    var name: String
    var description:String
    var items: [Item]
    var collapsed: Bool
    
    
    enum CodingKeys: String, CodingKey {
        case name = "title"
        case description = "description"
        case items = "data"
//        case collapsed = ""
    }
    init(name: String,description:String, items: [Item], collapsed: Bool = true) {
        self.name = name
        self.items = items
        self.collapsed = collapsed
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        name = try values.decode(String.self, forKey: .name)
        items = try values.decode([Item].self, forKey: .items)
        
//        collapsed = try values.decode(Bool.self, forKey: .collapsed)
        collapsed = true
        
    }
}
