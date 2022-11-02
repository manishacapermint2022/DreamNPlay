//
//  TabNavigationMenu.swift
//  CustomTabNavigation
//
//  Created by Sprinthub on 14/10/2019.
//  Copyright © 2019 Sprinthub Mobile. All rights reserved.
//
// Changed by Agha Saad Rehman

import UIKit

class TabNavigationMenu: UIImageView {
    
    var itemTapped: ((_ tab: Int) -> Void)?
    var activeItem: Int = 0
    let color = UIColor.black
    var menuItems:[TabItem]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(menuItems: [TabItem], frame: CGRect) {
        self.init(frame: frame)
        self.menuItems = menuItems
        print(frame)
        
        self.image = #imageLiteral(resourceName: "tabBarbg3").maskWithColor(color: color)
        self.isUserInteractionEnabled = true
        
        self.clipsToBounds = true
        
        for i in 0 ..< menuItems.count {
            let itemWidth = self.frame.width / CGFloat(menuItems.count)
            let leadingAnchor = itemWidth * CGFloat(i)
            
            let itemView = self.createTabItem(item: menuItems[i])
            itemView.tag = i
            
            self.addSubview(itemView)
            
            itemView.translatesAutoresizingMaskIntoConstraints = false
            itemView.clipsToBounds = true
            
            NSLayoutConstraint.activate([
                itemView.heightAnchor.constraint(equalTo: self.heightAnchor),
                itemView.widthAnchor.constraint(equalToConstant: itemWidth), // fixing width
                
                itemView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: leadingAnchor),
                itemView.topAnchor.constraint(equalTo: self.topAnchor),
            ])
        }
        self.setNeedsLayout()
        self.layoutIfNeeded()
        self.activateTab(tab: 0)
    }
    
    func createTabItem(item: TabItem) -> UIView {
        let tabBarItem = UIView(frame: CGRect.zero)
        let itemTitleLabel = UILabel(frame: CGRect.zero)
        let itemIconView = UIImageView(frame: CGRect.zero)
        let selectedItemView = UIImageView(frame: CGRect.zero)
        
        // adding tags to get views for modification when selected/unselected
        
        tabBarItem.tag = 11
        itemTitleLabel.tag = 12
        itemIconView.tag = 13
        selectedItemView.tag = 14
        selectedItemView.image = #imageLiteral(resourceName: "selectedTab").maskWithColor(color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        selectedItemView.translatesAutoresizingMaskIntoConstraints = false
        selectedItemView.clipsToBounds = true
        tabBarItem.addSubview(selectedItemView)
        NSLayoutConstraint.activate([
            selectedItemView.centerXAnchor.constraint(equalTo: tabBarItem.centerXAnchor),
            selectedItemView.centerYAnchor.constraint(equalTo: tabBarItem.centerYAnchor, constant: 0),
            selectedItemView.heightAnchor.constraint(equalToConstant: TabNavigationMenu.isSmallSize() ? 35 :45),
            selectedItemView.widthAnchor.constraint(equalToConstant: TabNavigationMenu.isSmallSize() ? 93 :103)
        ])
        
        selectedItemView.layer.cornerRadius = 10
        tabBarItem.sendSubviewToBack(selectedItemView)
        
        selectedItemView.isHidden = true

        itemTitleLabel.text = item.displayTitle
        if item.displayTitle == "My Matches" {
            itemTitleLabel.font = UIFont.boldSystemFont(ofSize: TabNavigationMenu.isSmallSize() ? 9 : 11)
        } else {
            itemTitleLabel.font = UIFont.boldSystemFont(ofSize: TabNavigationMenu.isSmallSize() ? 10 : 12)
        }
        itemTitleLabel.textColor = .black // changing color to white
        itemTitleLabel.textAlignment = .left
        itemTitleLabel.textAlignment = .center
        itemTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        itemTitleLabel.clipsToBounds = true
        itemTitleLabel.isHidden = true // hiding label for now
        
        itemIconView.image = item.icon!.withRenderingMode(.automatic)
        itemIconView.contentMode = .scaleAspectFit // added to stop stretching
        itemIconView.translatesAutoresizingMaskIntoConstraints = false
        itemIconView.clipsToBounds = true
        tabBarItem.layer.backgroundColor = color.cgColor//UIColor.clear.cgColor
        tabBarItem.addSubview(itemIconView)
        tabBarItem.addSubview(itemTitleLabel)
        tabBarItem.translatesAutoresizingMaskIntoConstraints = false
        tabBarItem.clipsToBounds = true
        NSLayoutConstraint.activate([
            itemIconView.heightAnchor.constraint(equalToConstant: 20), // Fixed height for our tab item(25pts) changed to 15
            itemIconView.widthAnchor.constraint(equalToConstant: 20), // Fixed width for our tab item icon changed to 15
//            itemIconView.centerXAnchor.constraint(equalTo: tabBarItem.centerXAnchor),
            itemIconView.centerXAnchor.constraint(equalTo: tabBarItem.centerXAnchor, constant: 0),
//            [tabToActivate.viewWithTag(13)!.centerXAnchor.constraint(equalTo: tabToActivate.centerXAnchor, constant: -20)],
            itemIconView.centerYAnchor.constraint(equalTo: tabBarItem.centerYAnchor, constant: 0), // adding to make icon exact center
            //itemIconView.topAnchor.constraint(equalTo: tabBarItem.topAnchor, constant: 8), // Position menu item icon 8pts from the top of it's parent view; commenting old y position
            //itemIconView.leadingAnchor.constraint(equalTo: tabBarItem.leadingAnchor, constant: 35), s: fixed height of its superview so don't need this, thus commenting
            itemTitleLabel.heightAnchor.constraint(equalToConstant: 13), // Fixed height for title label
            //itemTitleLabel.widthAnchor.constraint(equalTo: tabBarItem.widthAnchor), // Position label full width across tab bar item
            itemTitleLabel.leadingAnchor.constraint(equalTo: itemIconView.trailingAnchor, constant: 2),
            itemTitleLabel.centerYAnchor.constraint(equalTo: tabBarItem.centerYAnchor, constant: 0)
            //itemTitleLabel.topAnchor.constraint(equalTo: itemIconView.bottomAnchor, constant: 4), // Position title label 4pts below item icon, s: changinf postion of label so don't need this
            ])
        tabBarItem.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap))) // Each item should be able to trigger and action on tap
        return tabBarItem
    }
    
    @objc func handleTap(_ sender: UIGestureRecognizer) {
//        if self.activeItem != sender.view!.tag {
            self.switchTab(from: self.activeItem, to: sender.view!.tag)
//        }
    }
    
    func switchTab(from: Int, to: Int) {
        if from == to{
            self.itemTapped?(from)
            return
        }
        self.deactivateTab(tab: from)
        self.activateTab(tab: to)
    }
    
    func activateTab(tab: Int) {
        let tabToActivate = self.subviews[tab]
        // showing title label on selection
        (tabToActivate.viewWithTag(13) as? UIImageView)?.image = self.menuItems?[tab].iconActive
        tabToActivate.viewWithTag(12)?.isHidden = false // showing label
        tabToActivate.viewWithTag(14)?.isHidden = false // showing selected tab background
        // changing constraints for animation
        NSLayoutConstraint.deactivate(tabToActivate.constraints.filter({$0.firstItem === tabToActivate.viewWithTag(13) && $0.firstAttribute == .centerX}))
        NSLayoutConstraint.activate([tabToActivate.viewWithTag(13)!.centerXAnchor.constraint(equalTo: tabToActivate.centerXAnchor, constant: tab == 1 ? -30 : -20)])
        // transform effect for selectedtab background
        UIView.animate(withDuration: 0/*0.25*/, animations: {
            tabToActivate.viewWithTag(14)?.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.layoutIfNeeded()
        }) { (_) in
            tabToActivate.viewWithTag(14)?.isHidden = false
        }
        self.itemTapped?(tab)
        self.activeItem = tab
    }
    
    func deactivateTab(tab: Int) {
        let inactiveTab = self.subviews[tab]
        (inactiveTab.viewWithTag(13) as? UIImageView)?.image = self.menuItems?[tab].icon
        // hiding label again when deselected
        inactiveTab.viewWithTag(12)?.isHidden = true
        //inactiveTab.viewWithTag(14)?.isHidden = true
        // changing constraints for animation
        NSLayoutConstraint.deactivate(inactiveTab.constraints.filter({$0.firstItem === inactiveTab.viewWithTag(13) && $0.firstAttribute == .centerX}))
        NSLayoutConstraint.activate([inactiveTab.viewWithTag(13)!.centerXAnchor.constraint(equalTo: inactiveTab.centerXAnchor)])
        self.layoutIfNeeded()
        UIView.animate(withDuration: 0/*0.25*/, animations: {
            inactiveTab.viewWithTag(14)?.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            self.layoutIfNeeded()
        }) { (_) in
            inactiveTab.viewWithTag(14)?.isHidden = true
        }
    }
    
    static func isSmallSize()->Bool{
        switch UIDevice.current.screenType {
        case .iPhone4,.iPhones_5_5s_5c_SE,.iPhones_6_6s_7_8:
            return true
        default:
            return false
        }
    }
}
extension UIImage {

    func maskWithColor(color: UIColor) -> UIImage? {
        let maskImage = cgImage!

        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!

        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)

        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }

}
