//
//  DPInviteFirendsVC.swift
//  DreamPlay
//
//  Created by MAC on 17/06/21.
//

import UIKit
import SideMenu
import Alamofire
import SVProgressHUD
import SSCWhatsAppActivity

class DPInviteFirendsVC: UIViewController {

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var inviteFriendButton: UIButton!
    @IBOutlet weak var couponView: UIView!
    @IBOutlet weak var referalCodeLabel: UILabel!
    @IBOutlet weak var midView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bonusPointLabel: UILabel!
    let referralCode: Any? = UserDefaults.standard.object(forKey:"ReferralCode") as Any?
    let phone: Any? = UserDefaults.standard.object(forKey:"Phone") as Any?
    @IBOutlet weak var bonusPointText: UILabel!
    var walletView : UIView!
    var walletlabel : UILabel!
    var token:String?
    var dataDictionary:[String:Any] = [:]
    var userRefferalArray:[[String:Any]] = []
    var userDictionary:[String:Any] = [:]
    var responseDictionary:[String:Any] = [:]
    var referralString:String! = nil
    var referralArray:[Double] = []
  
    @IBOutlet weak var referralCodeLabel: UILabel!
    
    @IBOutlet weak var clipBoardImageView: UIImageView!
    
    var sideMenu:SideMenuNavigationController?
    var isOpen = false
    var screenCheck = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupWalletView()
        self.setupMenu()
        self.referralArray.removeAll()
        
        self.tableView.backgroundColor = UIColor.clear
        midView.layer.cornerRadius = 8
         midView.layer.borderWidth = 1
         midView.layer.borderColor = UIColor.clear.cgColor
        couponView.layer.cornerRadius = 8
         couponView.layer.borderWidth = 1
        couponView.layer.borderColor = UIColor.clear.cgColor
       // bottomView.layer.cornerRadius = 8
        // bottomView.layer.borderWidth = 1
        //bottomView.layer.borderColor = UIColor.clear.cgColor
        inviteFriendButton.layer.cornerRadius = 8
         inviteFriendButton.layer.borderWidth = 1
        inviteFriendButton.layer.borderColor = UIColor.clear.cgColor
        let logo = UIImage(named:"layer3")
        let imageView = UIImageView(image:logo)
        imageView.frame = CGRect(x: 150, y: 20, width: 100.0, height: 30.0)
        self.navigationItem.titleView = imageView

        
        print("ReferenceCode \(String(describing: referralCode))")
        self.referralString = referralCode as? String
        token = UserDefaults.standard.string(forKey:"AccessToken")!
        print("Token :", token as Any)
        
        self.referalCodeLabel.text = self.referralString
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(DPInviteFirendsVC.handleTap1(_:)))
      
      clipBoardImageView.addGestureRecognizer(tap2)
        self.referralUserList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
      //  self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.tabBarController?.tabBar.isHidden = true
        self.walletAmount()
    }
    
    func walletAmount(){
        
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data","Authorization":"Bearer" + " " + token!,"X-Requested-With":"XMLHttpRequest"]


                   AF.upload(
                       multipartFormData: { multipartFormData in
                       
                        
                   },
                    to: Constants.BaseUrl + "me", method: .get , headers: headers)
                       .responseJSON { response in
                        
                        
                        switch response.result {
                        case .failure(let error):
                            SVProgressHUD.dismiss()
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
                              print("responseObject \(responseObject)")
                                self.responseDictionary = responseObject as! [String:Any]
                                if let dict = self.responseDictionary["data"]
                                    as? [String:Any] {
                                    self.dataDictionary = dict
                                    print("DataDictionary \(self.dataDictionary)")
                                }
                                if let user = self.dataDictionary["user"] as? [String:Any] {
                                    self.userDictionary = user
                                    print("UserDictionary \(self.userDictionary)")
                                }
                                
//                                if let amount = self.userDictionary["balance"] as? Int {
////                                    self.amountLabel.text = "₹" + String(amount)
//                                    self.walletlabel.text = "₹" + String(amount)
//                                }
                                let stramount = self.getAmount(self.userDictionary["balance"] as Any )
                                self.walletlabel.text = "₹" + (stramount.isEmpty ? "0" : stramount)
                                
                                
                            }
                               
                                    }
                                
                                }
                            }
                        }
    
    func getAmount(_ value:Any)->String{
        var result = ""
        if let amount:NSNumber = value as? NSNumber{
            let stramount = String(format: "%0.2f", amount.floatValue)
            result = stramount
        }
        else if let amount = value as? Double {
            let stramount = String(format: "%0.2f", amount)
            result = stramount
        }
        else if let amount = value as? Int {
            result = String(amount)
        }
        else if let amount = value as? String {
            result = amount
        }
        else{
            let amount = "\(value)"
            result = amount
        }
        return result
    }
                       
    @IBAction func inviteFriendButtonTapped(_ sender: Any) {
    let menuVC  = storyboard?.instantiateViewController(withIdentifier: "ContactListViewController") as? ContactListViewController
        
        
        self.navigationController?.pushViewController(menuVC!, animated:true)
 
        print ("Ankit")
    }
    @IBAction func walletButtonTapped(_ sender: Any) {
        
        let stringToShare = "Download the dreamnplay app from here Link https://www.google.com/?client=safari Use My Invite code \(String(describing: self.referralString ?? ""))" + "                                                                             " +
            "Let us play!"
       // let urlToShare = URL(string: "https://github.com/sascha/SSCWhatsAppActivity")
        let whatsAppActivity = SSCWhatsAppActivity()
        let activityViewController = UIActivityViewController(activityItems: [stringToShare], applicationActivities: [whatsAppActivity])
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop,UIActivity.ActivityType.postToFacebook,UIActivity.ActivityType.mail,UIActivity.ActivityType.message,UIActivity.ActivityType.postToTwitter,UIActivity.ActivityType.postToFlickr,UIActivity.ActivityType.postToTencentWeibo,UIActivity.ActivityType.postToVimeo,UIActivity.ActivityType.postToWeibo]
        self.present(activityViewController, animated: true, completion:nil)
        
      /*  let message = "Download the dreamnplay app from here Link https://www.google.com/?client=safari Use My Invite code \(String(describing: self.referralString ?? ""))" + "                                                                             " +
           "Let us play!"
        UIPasteboard.general.string = message
        let queryCharSet = NSCharacterSet.urlQueryAllowed

         // if your text message contains special char like **+ and &** then add this line
      //   queryCharSet.remove(charactersIn: "+&")

        if let escapedString = message.addingPercentEncoding(withAllowedCharacters: queryCharSet) {
             if let whatsappURL = URL(string: "https://api.whatsapp.com/send?send?text=\(escapedString)") {
                if UIApplication.shared.canOpenURL(whatsappURL) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
                    }
                    else {
                        UIApplication.shared.openURL(whatsappURL)
                    }
                } else {
                    let alertController = UIAlertController(title: "Alert", message: "What's app is not installed", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                        print("you have pressed the Ok button");
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion:nil)
                }
             }
         }
 */
      /*  let phoneNumber =  self.phone as? String // you need to change this number
        let appURL = URL(string: "https://api.whatsapp.com/send?")!//phone=\(String(describing: phoneNumber))")!
        if UIApplication.shared.canOpenURL(appURL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
            }
            else {
                UIApplication.shared.openURL(appURL)
            }
        } else {
            let alertController = UIAlertController(title: "Alert", message: "What's app is not installed", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                print("you have pressed the Ok button");
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion:nil)
        }
 */
    }
    
    @IBAction func mesangerButtonTapped(_ sender: Any) {
        
        let message = "Download the dreamnplay app from here Link https://www.google.com/?client=safari Use My Invite code \(String(describing: self.referralString ?? ""))" + "                                                                             " +
           "Let us play!"
        UIPasteboard.general.string = message
        
        let urlString = "https://telegram.me/share/url?url=<URL>&text=<Download the dreamnplay app from here Link https://www.google.com/?client=safari Use My Invite code \(String(describing: self.referralString ?? ""))" + "                                                                             " +
            "Let us play!>"
        let tgUrl = URL.init(string:urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        if UIApplication.shared.canOpenURL(tgUrl!)
            {
                UIApplication.shared.openURL(tgUrl!)
            }else
            {
                let alertController = UIAlertController(title: "Alert", message: "App not installed", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                    print("you have pressed the Ok button");
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion:nil)
            }
        
        /*let message = "Download the dreamnplay app from here Link https://www.google.com/?client=safari Use My Invite code \(String(describing: self.referralString ?? ""))" + "                                                                             " +
           "Let us play!"
        UIPasteboard.general.string = message
        let screenName =  "DreamNPlay" // <<< ONLY YOU NEED TO CHANGE THIS
        let appURL = NSURL(string: "tg://msg?text=Download the dreamnplay app from here Link https://www.google.com/?client=safari Use My Invite code \(String(describing: self.referralString ?? ""))" + "                                                                             " +
                            "Let us play!")
        let webURL = NSURL(string: "https://web.telegram.org/k/")!
        if UIApplication.shared.canOpenURL(appURL! as URL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appURL! as URL, options: [:], completionHandler: nil)
            }
            else {
                UIApplication.shared.openURL(appURL! as URL)
            }
        }
        else {
            //redirect to safari because the user doesn't have Telegram
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(webURL as URL, options: [:], completionHandler: nil)
            }
            else {
                UIApplication.shared.openURL(webURL as URL)
            }
        }
 */
    }

    
    @IBAction func shareButtonTapped(_ sender: Any) {
        
        
        let text = "Download the dreamnplay app from here Link https://www.google.com/?client=safari Use My Invite code \(self.referralString ?? "")" + "                                                                             " +
            "Let us play!"
               
               // set up activity view controller
               let textToShare = [ text ]
               let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
               activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
               
               // exclude some activity types from the list (optional)
               activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop ]
               
               // present the view controller
               self.present(activityViewController, animated: true, completion: nil)
    }
    
    func referralUserList(){
        
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data","Authorization":"Bearer" + " " + token!,"X-Requested-With":"XMLHttpRequest"]


                   AF.upload(
                       multipartFormData: { multipartFormData in
                       
                        
                   },
                    to: Constants.BaseUrl + "get-referral-user", method: .get , headers: headers)
                       .responseJSON { response in
                        
                        
                        switch response.result {
                        case .failure(let error):
                            SVProgressHUD.dismiss()
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
                                SVProgressHUD.dismiss()
                              print("refferalResponseObject \(responseObject)")
                                self.responseDictionary = responseObject as! [String:Any]
                                if let dict = self.responseDictionary["data"]
                                    as? [String:Any] {
                                    self.dataDictionary = dict
                                    print("DataDictionary \(self.dataDictionary)")
                                }
                                if let user = self.dataDictionary["referral_user"] as? [[String:Any]] {
                                    self.userRefferalArray = user
                                    print("UserRefferalArray \(self.userRefferalArray)")
                                }
                                
                                for amount in self.userRefferalArray {
                                    
                                    let referralAmount = amount["referral_amount"] as? String
                                    let referalAmt = Double(referralAmount ?? "")
                                    self.referralArray.append(referalAmt ?? 0)
                                    let total = self.referralArray.reduce(0, +)
                                    self.bonusPointText.text = "Total Earned:" + " " + "₹" + String(total)

                                }
                                
                                self.tableView.reloadData()
                               
                                
                            }
                               
                           
                                    }
                                
                                
                            }
                        }
        
    }
    func setupWalletView(){
        walletView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 92, height: 33))
        walletView.backgroundColor = .clear
        let imageView = UIImageView(image:#imageLiteral(resourceName: "wallet"))
        walletView.addSubview(imageView)
        imageView.frame = CGRect(x: walletView.frame.width/2-20/2, y: 0, width: 20, height: 20)
        walletlabel = UILabel.init(frame: CGRect.init(x: 0, y: imageView.frame.maxY + 3, width: walletView.frame.width, height: 10))
        walletlabel.textColor = .white
        walletlabel.font = UIFont.systemFont(ofSize: 11)
        walletlabel.text = " "
        walletlabel.textAlignment = .center
        walletView.addSubview(walletlabel)
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(DPInviteFirendsVC.handleTap(_:)))
      
      walletView.addGestureRecognizer(tap1)
        let btn = UIBarButtonItem.init(customView: walletView)
        self.navigationItem.rightBarButtonItem = btn
        
    }
    
    @objc func handleTap1(_ sender: UITapGestureRecognizer) {
        UIPasteboard.general.string = referalCodeLabel.text
        print("Ankit")

    }
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let menuVC  = storyboard?.instantiateViewController(withIdentifier: "DPWalletVC") as? DPWalletVC
        
        
        self.navigationController?.pushViewController(menuVC!, animated:true)

    }
    @IBAction func btnMenu(_ sender: UIButton){
        present(sideMenu!, animated: true, completion: nil)
    }
    



    func setupMenu(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menuVC  = storyboard.instantiateViewController(withIdentifier: "LeftViewController") as! LeftViewController
        self.sideMenu = SideMenuNavigationController(rootViewController:menuVC)
        let screenWidth = UIScreen.main.bounds.width
        self.sideMenu!.menuWidth = screenWidth-100//(screenWidth > 400) ? 400 : screenWidth
        self.sideMenu?.leftSide = true
        self.sideMenu?.presentationStyle = .menuSlideIn
        self.sideMenu?.isNavigationBarHidden = true
        self.sideMenu?.presentationStyle.backgroundColor = .black
        self.sideMenu?.presentationStyle.presentingEndAlpha = 0.7
                
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        SideMenuManager.default.leftMenuNavigationController = self.sideMenu
       
    }


    @IBAction func toggleButtonTapped(_ sender: Any) {
        present(sideMenu!, animated: true, completion: nil)

      
    }
}
extension DPInviteFirendsVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userRefferalArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let dictionary = self.userRefferalArray[indexPath.row]
        print("UserRefferalDictionay \(dictionary)")
      if let nameLabel = cell.viewWithTag(20) as? UILabel {
        nameLabel.text = dictionary["name"] as? String
      }
        
        if let amountLabel = cell.viewWithTag(30) as? UILabel {
    
            if let amount = dictionary["referral_amount"] as? String{
            amountLabel.text = "Referral bonus point :" + " " + "(" + amount + ")"
            }
        }
        
        return cell
    
}
}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */



