//
//  LeftViewController+TableView.swift
//  DreamPlay
//
//  Created by sismac020 on 27/04/22.
//

import UIKit

extension LeftViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.table.dequeueReusableCell(withIdentifier: "LeftCell") as! LeftCell
        let data = menuList[indexPath.row]
        cell.imageLeft.image = UIImage(named: data.imageName)
        cell.nameLbL.text = data.name
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = menuList[indexPath.row]
        switch data.menuType {
        case .home:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let homeVC = storyboard.instantiateViewController(withIdentifier: "UITabBarController") as? TabBarController//UITabBarController
            homeVC?.selectedIndex = 0
            homeVC?.customTabBar?.switchTab(from: 1, to: 0)
            AppDelegate.getAppDelegate().setRoot(homeVC as AnyObject)
        case .viewProfile:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let homeVC  = storyboard.instantiateViewController(withIdentifier: "UITabBarController") as? TabBarController//UITabBarController
            homeVC?.selectedIndex = 3
            homeVC?.customTabBar?.switchTab(from: (homeVC?.customTabBar?.activeItem)!, to: 3)
            AppDelegate.getAppDelegate().setRoot(homeVC as AnyObject)
            //removeViewController(dpfaqVC)
           // removeViewController(DPLegacyViewController)
        case .changePassword:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let homeVC  = storyboard.instantiateViewController(withIdentifier: "DPChangePasswordVC") as? DPChangePasswordVC
            homeVC?.hidesBottomBarWhenPushed = true
           // pushSideMenu(vc: homeVC)
            homeVC?.modalPresentationStyle = .fullScreen
            self.present(homeVC!, animated: true)
        case .myWallet:
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let menuVC  = storyboard.instantiateViewController(withIdentifier: "DPWalletVC") as?  DPWalletVC
//            pushSideMenu(vc: menuVC)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let homeVC  = storyboard.instantiateViewController(withIdentifier: "DPWalletVC") as? DPWalletVC
            homeVC?.hidesBottomBarWhenPushed = true
           // pushSideMenu(vc: homeVC)
            homeVC?.modalPresentationStyle = .fullScreen
            self.present(homeVC!, animated: true)
        case .pointSystem:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let homeVC  = storyboard.instantiateViewController(withIdentifier: "DPPointTableVC") as? DPPointTableVC
            homeVC?.hidesBottomBarWhenPushed = true
            homeVC?.modalPresentationStyle = .fullScreen
            self.present(homeVC!, animated: true)
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let menuVC  = storyboard.instantiateViewController(withIdentifier: "DPPointTableVC") as? DPPointTableVC
//            pushSideMenu(vc: menuVC)
        case .inviteFriend:
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let menuVC  = storyboard.instantiateViewController(withIdentifier: "DPInviteFirendsVC") as? DPInviteFirendsVC
//            pushSideMenu(vc: menuVC)
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let homeVC  = storyboard.instantiateViewController(withIdentifier: "DPInviteFirendsVC") as? DPChangePasswordVC
//            homeVC?.hidesBottomBarWhenPushed = true
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let homeVC  = storyboard.instantiateViewController(withIdentifier: "DPInviteFirendsVC") as? DPInviteFirendsVC
            homeVC?.hidesBottomBarWhenPushed = true
            homeVC?.modalPresentationStyle = .fullScreen
            self.present(homeVC!, animated: true)
            
        case .fAQ:
//            let storyboard = UIStoryboard(name:"Main", bundle: nil)
//            let menuVC  = storyboard.instantiateViewController(withIdentifier: "DPFAQVC") as? DPFAQVC
//            pushSideMenu(vc: menuVC)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let homeVC  = storyboard.instantiateViewController(withIdentifier: "DPFAQVC") as? DPFAQVC
            homeVC?.hidesBottomBarWhenPushed = true
            homeVC?.modalPresentationStyle = .fullScreen
            self.present(homeVC!, animated: true)
            
        case .aboutUs:
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let menuVC  = storyboard.instantiateViewController(withIdentifier: "DPAboutUsVC") as? DPAboutUsVC
//            pushSideMenu(vc: menuVC)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let homeVC  = storyboard.instantiateViewController(withIdentifier: "DPAboutUsVC") as? DPAboutUsVC
            homeVC?.hidesBottomBarWhenPushed = true
            homeVC?.modalPresentationStyle = .fullScreen
            self.present(homeVC!, animated: true)
            
        case .legality:
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let menuVC  = storyboard.instantiateViewController(withIdentifier: "DPLegacyViewController") as? DPLegacyViewController
//            pushSideMenu(vc: menuVC)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let homeVC  = storyboard.instantiateViewController(withIdentifier: "DPLegacyViewController") as? DPLegacyViewController
            homeVC?.hidesBottomBarWhenPushed = true
            homeVC?.modalPresentationStyle = .fullScreen
            self.present(homeVC!, animated: true)
            
        case .termsCondition:
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let menuVC  = storyboard.instantiateViewController(withIdentifier: "DPTermConditionVC") as? DPTermConditionVC
//            pushSideMenu(vc: menuVC)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let homeVC  = storyboard.instantiateViewController(withIdentifier: "DPTermConditionVC") as? DPTermConditionVC
            homeVC?.hidesBottomBarWhenPushed = true
            homeVC?.modalPresentationStyle = .fullScreen
            self.present(homeVC!, animated: true)
            
        case .privacyPolicy:
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let menuVC  = storyboard.instantiateViewController(withIdentifier: "DPPrivacyPolicyVC") as? DPPrivacyPolicyVC
//            pushSideMenu(vc: menuVC)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let homeVC  = storyboard.instantiateViewController(withIdentifier: "DPPrivacyPolicyVC") as? DPPrivacyPolicyVC
            homeVC?.hidesBottomBarWhenPushed = true
            homeVC?.modalPresentationStyle = .fullScreen
            self.present(homeVC!, animated: true)
            
        }
    }
    
    func pushSideMenu(vc: UIViewController?) {
        vc?.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc!, animated: true)
        self.view.removeFromSuperview()

    }
    
    func removeViewController(_ viewController: UITableViewController) {
        // this is to notify the the child that it's about to be removed
        viewController.willMove(toParent: nil)
        // this is to remove the child's view from its superview
        viewController.view.removeFromSuperview()
        // this is to remove the child vc from its parent vc
        viewController.removeFromParent()
    }
}
    


