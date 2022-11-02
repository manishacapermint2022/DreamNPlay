//
//  SideBarModel.swift
//  UKM
//
//  Created by Nitish Rai on 14/02/21.
//  Copyright © 2021 Ravi Rana. All rights reserved.
//

import UIKit

struct Item: Codable {
    var name: String
    init(name: String) {
        self.name = name
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        name = try values.decode(String.self, forKey: .name)
    }
}

struct Section : Codable{
   
    var name: String
    var images:String
    var items: [Item]
    var collapsed: Bool
    var image_path:String
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case images = "image"
        case items = "fantasy_points"
        case image_path = "image_path"
//        case collapsed = ""
    }
    init(name: String,image:String, items: [Item], image_path:String, collapsed: Bool = true) {
        self.name = name
        self.images = image
        self.items = items
        self.image_path = image_path
        self.collapsed = collapsed
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        name = try values.decode(String.self, forKey: .name)
        items = try values.decode([Item].self, forKey: .items)
        images = try values.decode(String.self, forKey: .images)
        image_path = try values.decode(String.self, forKey: .image_path)
//        collapsed = try values.decode(Bool.self, forKey: .collapsed)
        collapsed = true
        
    }
}




