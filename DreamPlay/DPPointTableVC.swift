//
//  DPPointTableVC.swift
//  DreamPlay
//
//  Created by MAC on 09/07/21.
//

import UIKit
import SideMenu
import Alamofire
import SVProgressHUD
import WMSegmentControl

class DPPointTableVC: UIViewController, CollapsibleTableViewHeaderDelegate {
    var sideMenu:SideMenuNavigationController?
    var dataDictionary:[String:Any] = [:]
    var userDictionary:[String:Any] = [:]
    var responseDictionary:[String:Any] = [:]
    var walletView : UIView!
    var walletlabel : UILabel!
    
    @IBOutlet weak var anotherSegment: WMSegment!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    var sectionsData: [Section] = []
//    var sectionsData: [[String:Any]] = []
    var token:String?
//    @IBOutlet weak var menuTblView : UITableView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupWalletView()
        self.setupMenu()
        let logo = UIImage(named:"layer3")
        let imageView = UIImageView(image:logo)
        imageView.frame = CGRect(x: 150, y: 20, width: 100.0, height: 30.0)
        self.navigationItem.titleView = imageView
        token = UserDefaults.standard.string(forKey:"AccessToken")!
        print("Token :", token as Any)
        segmentControl.backgroundColor = UIColor.black
        segmentControl.layer.borderColor = UIColor.white.cgColor
        if #available(iOS 13.0, *) {
            segmentControl.selectedSegmentTintColor = UIColor.white
        } else {
            // Fallback on earlier versions
        }
        segmentControl.layer.borderWidth = 1
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segmentControl.setTitleTextAttributes(titleTextAttributes, for:.normal)
        let titleTextAttributes1 = [NSAttributedString.Key.foregroundColor: UIColor.black]
        segmentControl.setTitleTextAttributes(titleTextAttributes1, for:.selected)
        
        // Do any additional setup after loading the view.
        
        
        //lblUserName.text = Constants.userDefaultObj.value(forKey: "userName") as? String ?? ""
        //if let strUrl = Constants.userDefaultObj.value(forKey: "userImg") as? String{
        // userImg.sd_setImage(with: URL(string: strUrl), placeholderImage: #imageLiteral(resourceName: "user-pic"))
        // }
        
        //  openShopButton.setTitle("Open a Shop", for: .normal)
        //  openShopButton.leftImage(image: UIImage(systemName: "checkmark.seal.fill")!, imagePading: 30, imageTint: .blue, renderMode: .alwaysOriginal, titlePadding: 30, titleColor: .ukmDarkBlue)
        
        self.tableView.rowHeight = 55.0
        tableView.tableFooterView = UIView()
        tableView.tableFooterView = nil
        tableView.backgroundColor = UIColor(red: 36.0/255.0, green: 48.0/255.0, blue: 114.0/255.0, alpha: 1.0)
        
        
        
        /*
         sectionsData = [
         Section(name: "BATTING POINTS", image:"battingP", items: [Item(name: "Address Management"),
         Item(name: "Billing & Payment"),
         Item(name: "Your Profile"),]),
         Section(name: "BALLING POINTS", image: "cricket1", items: [
         Item(name: "Address Management"),
         Item(name: "Billing & Payment"),
         Item(name: "Your Profile"),
         
         ]),
         Section(name: "FIELDING POINTS", image: "cricketBallCopy", items: [Item(name: "Address Management"),
         Item(name: "Billing & Payment"),
         Item(name: "Your Profile"),
         ]),
         Section(name: "OTHER POINTS", image: "cricket1", items: [Item(name: "Address Management"),
         Item(name: "Billing & Payment"),
         Item(name: "Your Profile"),
         ]),
         Section(name: "ECONOMIC RATE POINT", image: "battingP", items: [Item(name: "Address Management"),
         Item(name: "Billing & Payment"),
         Item(name: "Your Profile"),
         ]),
         Section(name: "STRIKE RATE(EXPECTED BALLER) POINTS", image: "cricketBallCopy", items: [Item(name: "Address Management"),
         Item(name: "Billing & Payment"),
         Item(name: "Your Profile"),
         ]),
         
         
         
         ]
         */
        segmentIndexChanged(segmentControl as Any)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.walletAmount()
      
    }
    
    @IBAction func segmentIndexChanged(_ sender: Any) {
        switch segmentControl.selectedSegmentIndex
            {
            case 0:
//                self.t20Match()
                self.getMatchList("t20")
               
            case 1:
//                self.t10Match()
                self.getMatchList("t10")
               case 2:
//                self.odiMatch()
                self.getMatchList("odi")
                
            case 3:
                self.getMatchList("test")
                
            default:
                break
            }
    }
    
    @IBAction func toggleButtonTapped(_ sender: Any) {
        present(sideMenu!, animated: true, completion: nil)
    }
    
    
    func walletAmount(){
        
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
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
    
    func toggleSection(_ header: CollapsibleTableViewHeader, section: Int) {
        
        
        
        let collapsed = !sectionsData[section].collapsed
        
        // Toggle collapse
        sectionsData[section].collapsed = collapsed
        header.setCollapsed(collapsed)
        
        tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
        
        if sectionsData[section].name == "Switch An Account"{
            
        }else if sectionsData[section].name == "Sell An Item"{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "toggleMenu"), object: nil)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContainerVC")
            self.navigationController?.pushViewController(vc!, animated: true)
        }else if sectionsData[section].name == "Search By Category"{
            
            
            
        }else if sectionsData[section].name == "Your Saved Searches"{
            
        }else if sectionsData[section].name == "Invite Your Friends"{
            let items = [self]
            let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
            present(ac, animated: true)
        }else if sectionsData[section].name == "Your Purchase"{
            
        }
    }
    
    
    
    func t20Match() {
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        else{
    
    let headers: HTTPHeaders = ["Content-type": "multipart/form-data","Authorization":"Bearer" + " " + token!,"X-Requested-With":"XMLHttpRequest"]


                AF.upload(
                    multipartFormData: { multipartFormData in
                    
                     
                },
                 to: Constants.BaseUrl + "fantasy_points?type=t20", method: .get , headers: headers)
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
                             SVProgressHUD.dismiss()
                             self.responseDictionary = responseObject as! [String:Any]
                             if let dict = self.responseDictionary["data"]
                                 as? [String:Any] {
                                 self.dataDictionary = dict
                                 print("DataDictionary \(self.dataDictionary)")
                                 if let myArray = self.dataDictionary["data"] as? [Section] {
                                     self.sectionsData = myArray
                                     print("DataArray \(self.sectionsData)")
                                 }
                                
                               
                                    
                               
                            

                                 self.tableView.reloadData()
                             }
                         }
                         }

                     }
                    }
    }
    
    func t10Match() {
        
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        else{
    
    let headers: HTTPHeaders = ["Content-type": "multipart/form-data","Authorization":"Bearer" + " " + token!,"X-Requested-With":"XMLHttpRequest"]


                AF.upload(
                    multipartFormData: { multipartFormData in
                    
                     
                },
                 to: Constants.BaseUrl + "fantasy_points?type=t10", method: .get , headers: headers)
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
                             SVProgressHUD.dismiss()
                             self.responseDictionary = responseObject as! [String:Any]
                             if let dict = self.responseDictionary["data"]
                                 as? [String:Any] {
                                 self.dataDictionary = dict
                                 print("DataDictionary \(self.dataDictionary)")
                                 if let myArray = self.dataDictionary["data"] as? [Section] {
                                     self.sectionsData = myArray
                                     print("DataArray \(self.sectionsData)")
                                 }

                                 self.tableView.reloadData()
                             }
                         }
                         }

                     }
                    }
    }
    
    func odiMatch() {
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        else{
            let headers: HTTPHeaders = ["Content-type": "multipart/form-data","Authorization":"Bearer" + " " + token!,"X-Requested-With":"XMLHttpRequest"]
            AF.upload(
                multipartFormData: { multipartFormData in
                    
                    
                },
                to: Constants.BaseUrl + "fantasy_points?type=odi", method: .get , headers: headers)
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
                        SVProgressHUD.dismiss()
                        self.responseDictionary = responseObject as! [String:Any]
                        if let dict = self.responseDictionary["data"]
                            as? [String:Any] {
                            self.dataDictionary = dict
                            print("DataDictionary \(self.dataDictionary)")
                            if let myArray = self.dataDictionary["data"] as? [Section] {
                                self.sectionsData = myArray
                                print("DataArray \(self.sectionsData)")
                            }
                            
                            self.tableView.reloadData()
                        }
                        
                    }
                }
            }
        }
    }
    
    func getMatchList(_ param:String) {
        
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        else{
    
    let headers: HTTPHeaders = ["Content-type": "multipart/form-data","Authorization":"Bearer" + " " + token!,"X-Requested-With":"XMLHttpRequest"]

        let url = Constants.BaseUrl + "fantasy_points?type=\(param)"
        print(url)
                AF.upload(
                    multipartFormData: { multipartFormData in
                    
                     
                },
                 to: url, method: .get , headers: headers)
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
                             SVProgressHUD.dismiss()
                             self.responseDictionary = responseObject as! [String:Any]
                             if let dict = self.responseDictionary["data"]
                                 as? [String:Any] {
                                 self.dataDictionary = dict
                                 print("DataDictionary \(self.dataDictionary)")
                                if let myArray = self.dataDictionary["data"] as? [[String:Any]]{//[Section] {
                                    self.sectionsData = self.convertArrToModel(myArray)
                                     print("DataArray \(self.sectionsData)")
                                    
                                    
                                 }

                             }
                            self.tableView.reloadData()
                         
                         }
                     }
                     }
                    }
    }
    
    func convertArrToModel(_ myArray:[[String:Any]])->[Section]{
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: myArray)
            let decoder = JSONDecoder()

            do {
                let result = try decoder.decode([Section].self, from: jsonData)
                return result
            } catch {
                print(error.localizedDescription)
            }
                
        } catch {
            print(error.localizedDescription)
        }
        return []
    }
    
   /* func userLogout() {
        
        // Declare Alert
        let dialogMessage = UIAlertController(title: nil, message: "Are you sure you want to Logout?", preferredStyle: .actionSheet)
        
        // Create Logout button with action handler
        let logout = UIAlertAction(title: "Logout", style: .destructive, handler: { (action) -> Void in
            print("Ok button click...")
            //self.logoutApi()
            
            Constants.userDefaultObj.removeObject(forKey: "userId")
            Constants.userDefaultObj.set(false, forKey: "status")
            Constants.userDefaultObj.synchronize()
            self.dismiss(animated: true, completion: {
                Switcher.updateRootVC()
                 //Constants.appObj.window?.rootViewController =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainNavBar")
            })
           
            
        })
        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            print("Cancel button click...")
        }
        
        //Add OK and Cancel button to dialog message
        dialogMessage.addAction(logout)
        dialogMessage.addAction(cancel)
        
        if let popoverController = dialogMessage.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        // Present dialog message to user
        self.present(dialogMessage, animated: true, completion: nil)
        
        
    }*/
    
    
    

                       

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
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(DPTeamHistoryVC.handleTap(_:)))
      
      walletView.addGestureRecognizer(tap1)
        let btn = UIBarButtonItem.init(customView: walletView)
        self.navigationItem.rightBarButtonItem = btn
        
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let menuVC  = storyboard?.instantiateViewController(withIdentifier: "DPWalletVC") as? DPWalletVC
        
        
        self.navigationController?.pushViewController(menuVC!, animated:true)

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
    
    @IBAction func btnMenu(_ sender: UIButton){
        present(sideMenu!, animated: true, completion: nil)
    }
}

extension DPPointTableVC:UITableViewDataSource,UITableViewDelegate {
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsData.count
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sectionsData[section].collapsed ? 0 : sectionsData[section].items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CollapsibleTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as? CollapsibleTableViewCell ??
            CollapsibleTableViewCell(style: .default, reuseIdentifier: "cell")
        let item: Item = sectionsData[indexPath.section].items[indexPath.row]
        cell.nameLabel.frame = CGRect(x: 20, y: cell.nameLabel.frame.origin.y, width: cell.nameLabel.frame.size.width-20, height: cell.nameLabel.frame.size.height)
        cell.nameLabel.text = item.name
        cell.nameLabel.textColor = UIColor.white
        cell.backgroundColor = UIColor(red: 36.0/255.0, green: 48.0/255.0, blue: 114.0/255.0, alpha: 1.0)
        return cell
    }
    
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // Header
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       
         let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CollapsibleTableViewHeader ?? CollapsibleTableViewHeader(reuseIdentifier: "header")
        
    
        
    
        let url = sectionsData[section].image_path //+ sectionsData[section].images
        let imageView = UIImageView()
        
        
       if let  imageURL = URL(string:url) {
        header.imagess.sd_setImage(with: imageURL, completed: nil)
       }
       else{
        let headerImage = #imageLiteral(resourceName: "cricketBallCopy")//UIImage(named: url)
        header.imagess.image = headerImage
       }
//        imageView.image = headerImage
//       imageView.frame = CGRect(x: 20, y: 5, width: 30, height: 30)
//       imageView.contentMode = .scaleAspectFit
//        header.addSubview(imageView)
           // header.imagess.image = headerImage
//        let titleLabel = UILabel()
//        titleLabel.frame = CGRect(x: 70, y: 5, width: 300, height: 20)
//        titleLabel.font = titleLabel.font.withSize(14)
//        titleLabel.text = self.sectionsData[section].name
        header.titleLabel.text = self.sectionsData[section].name
        
//        header.addSubview(titleLabel)
        if sectionsData[section].items.count == 0{
          
            header.arrowLabel.text = ""
        }else{
            header.arrowLabel.text = ">"
        }
       
        header.setCollapsed(sectionsData[section].collapsed)
        header.section = section
        header.delegate = self
        
        
        return header
//     }
//        return nil
    }
    
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
    
     func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }


     func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor =  UIColor(red: 36.0/255.0, green: 48.0/255.0, blue: 114.0/255.0, alpha: 1.0)



        return headerView
    }
    
}
    
extension DPPointTableVC{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        tableView.deselectRow(at: indexPath, animated: true)
        
//        if indexPath.row == 0{
//
//             // let controller = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
//            // navigationController?.pushViewController(controller, animated: true)
//        }
//        else
        if sectionsData[indexPath.section].items[indexPath.row].name == "Sell An Item"{
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "toggleMenu"), object: nil)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContainerVC")
            self.navigationController?.pushViewController(vc!, animated: true)
            
        }
        else if indexPath.row == 8{
           
        }
        else if sectionsData[indexPath.section].items[indexPath.row].name == "Logout"{
            
          
            
        }
        else if sectionsData[indexPath.section].items[indexPath.row].name == "Notifications"{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ContactUs")
            self.navigationController?.show(vc, sender: nil)
            
            
            /*  let vc = Helper.instantiateViewController(with: .search, storyboardId: .notificationSettingsVC) as? NotificationSettingsVC
             // self.tabBarController?.setTabBarVisible(visible: false, duration: 0.3, animated: true)
             self.navigationController?.pushViewController(vc!, animated: true)
             */
            
        }
        else if sectionsData[indexPath.section].items[indexPath.row].name == "Change Password"{
            
            
            
        }
        else if sectionsData[indexPath.section].items[indexPath.row].name == "Question & Answer"{
            
            
            
        }
    }
    
}

class PointTblCell: UITableViewCell {
   
    @IBOutlet weak var lblTxt: UILabel!
}




