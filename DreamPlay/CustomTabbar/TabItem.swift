//
//  TabItem.swift
//  CustomTabNavigation
//
//  Created by Sprinthub on 09/10/2019.
//  Copyright © 2019 Sprinthub Mobile. All rights reserved.
//

// Changed by Agha Saad Rehman

import UIKit

enum TabItem: String, CaseIterable {
    case home = "home"
    case my_matches = "my matches"
    case team = "team"
    case profile = "profile"
    
    var icon: UIImage? {
        switch self {
        case .home:
            return #imageLiteral(resourceName: "home")
        case .my_matches:
            return #imageLiteral(resourceName: "match")
        case .team:
            return #imageLiteral(resourceName: "team")
        case .profile:
            return #imageLiteral(resourceName: "Vector Smart Object")
        }
    }
    
    var iconActive: UIImage? {
        switch self {
        case .home:
            return #imageLiteral(resourceName: "Home selected")
        case .my_matches:
            return #imageLiteral(resourceName: "match selection")
        case .team:
            return #imageLiteral(resourceName: "my team selected")
        case .profile:
            return #imageLiteral(resourceName: "profile selected")
        }
    }
    
    
    var displayTitle: String {
        return self.rawValue.capitalized(with: nil)
    }
}
