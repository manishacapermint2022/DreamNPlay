//
//  UIDevice+Check.swift
//  GeoTactical
//
//  Created by Ankit Prakash on 5/18/20.
//  Copyright © 2020 EvirtualServices. All rights reserved.
//

import Foundation
import UIKit

extension UIDevice {
    static func isIPad()->Bool{
       return UIDevice.current.userInterfaceIdiom == .pad
    }
    static func isIPhone()->Bool{
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    static func getFloatValue(iPhone:CGFloat,iPAd:CGFloat) -> CGFloat{
        if (UIDevice.isIPhone()) {
            return iPhone
        }
        else if (UIDevice.isIPad()) {
            return iPAd
            
        }
        return 0
        
    }
}
