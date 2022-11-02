//
//  Constants.swift
//  PriceLazer
//
//  Created by IOSdev on 10/19/20.
//  Copyright © 2020 evs. All rights reserved.
//

import UIKit
import Foundation
import UIKit

class Constants: NSObject {
    
 //static let BaseUrl = "https://dreamnplay.thesst.com/api/api/"
    static let BaseUrl = "https://dreamnplay.com/api/api/"

}
struct Console{
    static func log(_ message: Any?){
        print(message ?? "errorNothingToLog")
    }
}
