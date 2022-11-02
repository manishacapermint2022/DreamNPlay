//
//  LeftViewController+Action.swift
//  DreamPlay
//
//  Created by sismac020 on 27/04/22.
//

import UIKit

extension LeftViewController {
    @IBAction func profiel(_ sender : UIButton){
        /*let storyboard = UIStoryboard(name: "Main", bundle: nil)
         let menuVC  = storyboard.instantiateViewController(withIdentifier: "ProfielViewController") as? ProfielViewController
         self.navigationController?.pushViewController(menuVC!, animated: true)
         }
         */
    }
    @IBAction func logoutButtonTapped(_ sender: Any) {
        let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let centerVC = mainStoryBoard.instantiateViewController(withIdentifier:"DPLoginVC") as? DPLoginVC
        UserDefaults.standard.set(false, forKey:"isUserLoggedIn")
        UserDefaults.standard.synchronize()
        let nav = UINavigationController.init(rootViewController: centerVC!)
        nav.isNavigationBarHidden = true
        appDel.window!.rootViewController = nav
        appDel.window!.makeKeyAndVisible()
        //         self.present(centerVC!, animated: true, completion: nil)
    }
}
