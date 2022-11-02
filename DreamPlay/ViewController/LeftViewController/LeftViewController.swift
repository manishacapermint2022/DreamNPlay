//
//  LeftViewController.swift
//  G.O.A.T
//
//  Created by APPLE on 28/07/20.
//  Copyright © 2020 APPLE. All rights reserved.
//

import UIKit
import Alamofire
//import MBProgressHUD


struct SideMenuList {
    let name: String
    let imageName: String
    let menuType: SideMenuType
}

enum SideMenuType {
    case home
    case viewProfile
    case changePassword
    case myWallet
    case pointSystem
    case inviteFriend
    case fAQ
    case aboutUs
    case legality
    case termsCondition
    case privacyPolicy
}
  

class LeftViewController: UIViewController {
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet var name : UILabel!
    @IBOutlet var nameimaAGE : UIImageView!
    @IBOutlet var table : UITableView!
    let userId: Any? = UserDefaults.standard.object(forKey:"UserID") as Any?
    var responseDictionary:[String:Any] = [:]
    var menuList = [SideMenuList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSideMenuData()
        
        // logoutButton.layer.cornerRadius = 8
        //logoutButton.layer.borderWidth = 1
        //logoutButton.layer.borderColor = UIColor.clear.cgColor
        // self.nameimaAGE.layer.cornerRadius = self.nameimaAGE.frame.width/2
        // self.nameimaAGE.layer.masksToBounds = true
        /* let spinnerActivity = MBProgressHUD.showAdded(to:view, animated: true);
         spinnerActivity.label.text = "Loading";
         spinnerActivity.detailsLabel.text = "Please Wait!!";
         
         if let apiString = URL(string:Constants.BaseUrl) {
         var request = URLRequest(url:apiString)
         request.httpMethod = "POST"
         request.setValue("application/json",
         forHTTPHeaderField: "Content-Type")
         
         let values = ["action":"profile","userId":self.userId as Any]
         request.httpBody = try! JSONSerialization.data(withJSONObject: values)
         AF.request(request)
         .responseJSON { response in
         // do whatever you want here
         switch response.result {
         case .failure(let error):
         // SVProgressHUD.dismiss()
         let alertController = UIAlertController(title: "Alert", message: "Some error Occured", preferredStyle: .alert)
         let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
         print("you have pressed the Ok button");
         }
         alertController.addAction(okAction)
         self.present(alertController, animated: true, completion:nil)
         print(error)
         if let data = response.data,
         let responseString = String(data: data, encoding: .utf8) {
         print(responseString)
         print("response \(responseString)")
         }
         case .success(let responseObject):
         DispatchQueue.main.async {
         
         print("This is run on the main queue, after the previous code in outer block")
         }
         print("response \(responseObject)")
         MBProgressHUD.hide(for:self.view, animated: true)
         let dict = responseObject as? [String : Any]
         
         if let dict = dict?["data"] as? [String:Any] {
         
         
         self.responseDictionary = dict
         print("ResponseDictionary \(self.responseDictionary)")
         }
         
         self.name.text = self.responseDictionary["fullName"] as? String
         
         if let imageUrl = self.responseDictionary["image"] as? String, let  url = URL(string:imageUrl){
         
         // don't know why this line
         // self.userImage = imageUrl
         if let data = try? Data(contentsOf: url)  {
         self.nameimaAGE.image = UIImage(data: data)
         self.nameimaAGE.contentMode = .scaleAspectFill
         }
         }
         
         self.table.reloadData()
         
         }
         }
         
         
         }
         */
    }
    func setSideMenuData() {
        menuList.append(SideMenuList(name: "Home", imageName: "group4Copy3", menuType: .home))
        menuList.append(SideMenuList(name: "View Profile", imageName: "user1", menuType: .viewProfile))
        menuList.append(SideMenuList(name: "Change Password", imageName: "lock", menuType: .changePassword))
        menuList.append(SideMenuList(name: "My Wallet", imageName: "wallet4", menuType: .myWallet))
        menuList.append(SideMenuList(name: "Point System", imageName: "group4Copy3", menuType: .pointSystem))
        menuList.append(SideMenuList(name: "Invite Friend", imageName: "group4Copy3", menuType: .inviteFriend))
        menuList.append(SideMenuList(name: "FAQ", imageName: "help1", menuType: .fAQ))
        menuList.append(SideMenuList(name: "About Us", imageName: "information", menuType: .aboutUs))
        menuList.append(SideMenuList(name: "Legality", imageName: "legal", menuType: .legality))
        menuList.append(SideMenuList(name: "Terms & Conditions", imageName: "group4Copy3", menuType: .termsCondition))
        menuList.append(SideMenuList(name: "Privacy Policy", imageName: "group4Copy3", menuType: .privacyPolicy))
    }
}
