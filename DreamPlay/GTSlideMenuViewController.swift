//
//  GTSlideMenuViewController.swift
//  GeoTactical
//
//  Created by Ankit Prakash on 5/12/20.
//  Copyright © 2020 EvirtualServices. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class GTSlideMenuViewController: UITableViewController {
    
    let name: Any? = UserDefaults.standard.object(forKey:"Name") as Any?
    let phone: Any? = UserDefaults.standard.object(forKey:"ContactNumber") as Any?
    var responseDictionary:[String:Any] = [:]
    var message:String?
    var photo1:UIImage?
    var status:String?
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var userName: UILabel!
    var flag:Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // userName.text = name as? String
        //phoneNumber.text = phone as? String
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       
        
         if indexPath.row == 5{
            let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
            let centerVC = mainStoryBoard.instantiateViewController(withIdentifier:"GTWelcomeViewController") as? UINavigationController
           UserDefaults.standard.set(false, forKey:"isUserLoggedIn")
            UserDefaults.standard.synchronize()
            appDel.window!.rootViewController = centerVC
            appDel.window!.makeKeyAndVisible()
             self.present(centerVC!, animated: true, completion: nil)
        }
    }
    
   

}
