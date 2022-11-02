//
//  TabBarController.swift
//  SwipeableTabBarController
//
//  Created by Marcos Griselli on 2/1/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit


class TabBarController: UITabBarController{

    var customTabBar: TabNavigationMenu?
    var tabBarHeight: CGFloat = TabNavigationMenu.isSmallSize() ? 50 : 63
    var isManaul: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadTabBar()
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print(item)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        // Handle didSelect viewController method here
        print(viewController)
        
    }
    
    private func loadTabBar() {
        let tabItems: [TabItem] = [.home, .my_matches, .team,.profile]
        self.setupCustomTabBar(tabItems) { (controllers) in
            self.viewControllers = controllers
        }
        
        self.selectedIndex = 0 // default our selected index to the first item
    }
    
    func getController(_ tb:TabItem)-> UINavigationController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        switch tb {
        case .home:
            let vc  = storyboard.instantiateViewController(withIdentifier: "homeTab") as! UINavigationController
            return vc//ChatChannelListVC()
        case .my_matches:
            let vc  = storyboard.instantiateViewController(withIdentifier: "mymatchTab") as! UINavigationController
            return vc//StatusListVC()
        case .team:
            let vc  = storyboard.instantiateViewController(withIdentifier: "teamTab") as! UINavigationController
            return vc//CallListVC()
        case .profile:
            let vc  = storyboard.instantiateViewController(withIdentifier: "profileTab") as! UINavigationController
            return vc//UIViewController()
        }
    }
    
    // Build the custom tab bar and hide default
    private func setupCustomTabBar(_ items: [TabItem], completion: @escaping ([UINavigationController]) -> Void) {
        let frame = CGRect(x: tabBar.frame.origin.x, y: tabBar.frame.origin.x, width: tabBar.frame.width, height: tabBarHeight) // had to change from let frame = tabBar.frame because the default height of 49 was being passed instead of 67. The background wasn't fitting correctly so had to incrrease height by 1. Not quite sure why...

        print(UIScreen.main.bounds)
        var controllers = [UINavigationController]()
        
        // hide the tab bar
        tabBar.isHidden = true
        
        self.customTabBar = TabNavigationMenu(menuItems: items, frame: frame)
        self.customTabBar!.translatesAutoresizingMaskIntoConstraints = false
        self.customTabBar!.clipsToBounds = true
        self.customTabBar!.itemTapped = self.changeTab
        
//        customTabBar.image = UIImage(named: "tabBarbg")
//        customTabBar.isUserInteractionEnabled = true
        // Add it to the view
        self.view.addSubview(customTabBar!)
        
        // Add positioning constraints to place the nav menu right where the tab bar should be
//        NSLayoutConstraint.activate([
//            self.customTabBar!.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor),
//            self.customTabBar!.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor),
//            self.customTabBar!.widthAnchor.constraint(equalToConstant: tabBar.frame.width),
//            self.customTabBar!.heightAnchor.constraint(equalToConstant: tabBarHeight), // Fixed height for nav menu
//            self.customTabBar!.bottomAnchor.constraint(equalTo: tabBar.bottomAnchor)
//        ])
        
        if #available(iOS 11, *) {
            let bottomView = UIView(frame: frame)
            bottomView.frame.size = CGSize(width: bottomView.frame.width, height: 0)
            bottomView.translatesAutoresizingMaskIntoConstraints = false
            let color = UIColor.black
            
            bottomView.backgroundColor = color
            self.view.addSubview(bottomView)
            view.insertSubview(bottomView, belowSubview: self.customTabBar!)
            
            let guide = view.safeAreaLayoutGuide
            NSLayoutConstraint.activate([
                self.customTabBar!.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor),
                self.customTabBar!.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor),
                self.customTabBar!.widthAnchor.constraint(equalToConstant: tabBar.frame.width),
                self.customTabBar!.heightAnchor.constraint(equalToConstant: tabBarHeight), // Fixed height for nav menu
                self.customTabBar!.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
                
                bottomView.topAnchor.constraint(equalTo: guide.bottomAnchor),
                bottomView.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor),
                bottomView.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor),
                bottomView.bottomAnchor.constraint(equalTo: tabBar.bottomAnchor),
            ])
        } else {
            NSLayoutConstraint.activate([
                self.customTabBar!.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor),
                self.customTabBar!.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor),
                self.customTabBar!.widthAnchor.constraint(equalToConstant: tabBar.frame.width),
                self.customTabBar!.heightAnchor.constraint(equalToConstant: tabBarHeight), // Fixed height for nav menu
                self.customTabBar!.bottomAnchor.constraint(equalTo: tabBar.bottomAnchor)
            ])
        }
        
        
        print(customTabBar!.frame)
        for i in 0 ..< items.count {
            let vc = getController(items[i])
            controllers.append(vc)
//            controllers.append(items[i].viewController) // we fetch the matching view controller and append here
        }
        
        self.view.layoutIfNeeded() // important step
        completion(controllers) // setup complete. handoff here
    }
    
    
    func changeTab(tab: Int) {
        if self.selectedIndex == tab{
            if let nav = viewControllers?[tab] as? UINavigationController {
                //nav.popViewController(animated: true)
                nav.popToRootViewController(animated: false)
            }
            //self.navigationController?.popViewController(animated: true)
            return
        }
        else{
            if let nav = viewControllers?[tab] as? UINavigationController{
                //nav.popViewController(animated: true)
                nav.popToRootViewController(animated: false)
            }
        }
        if !isManaul {
            self.selectedIndex = tab
        }
        isManaul = false
        print("selected: \(self.selectedIndex) ")
        print("controller: \(self.viewControllers![self.selectedIndex])")
    }
}
