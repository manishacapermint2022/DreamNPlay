//
//  DPHomePageVC.swift
//  DreamPlay
//
//  Created by MAC on 15/06/21.
//

import UIKit
import Alamofire
import SVProgressHUD
import KYDrawerController
import SideMenu
import MZTimerLabel
import SDWebImage
import UPCarouselFlowLayout

class DPHomePageVC: UIViewController {

    var sideMenu:SideMenuNavigationController?
    @IBOutlet weak var secondCountryView: UIImageView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var firstCountryView: UIImageView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var dataNotAvailableLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var myMatchTableView: UITableView!
    @IBOutlet weak var selectUpcomingMatchesLabel: UILabel!
    @IBOutlet weak var myMatchesLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblWallet: UILabel!
    
    let accessToken: Any? = UserDefaults.standard.object(forKey:"AccessToken") as Any?
    let balance: Any? = UserDefaults.standard.object(forKey:"Balance") as Any?
    var isOpen = false
    var screenCheck = false
    var gameArray:[[String:Any]] = []
    var responseDictionary:[String:Any] = [:]
    var dataDictionary:[String:Any] = [:]
    var fixtureArray:[[String:Any]] = []
    var gamesArray:[[String:Any]] = []
    var token:String?
    var paymentArray:[[String:Any]] = []
    var userDictionary:[String:Any] = [:]
    var defaultImage:UIImage?
    var walletView : UIView!
   // var walletlabel : UILabel!
    
    
    //MARK:- View controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.downloadImage(from: URL(string:"https://cricket.entitysport.com/assets/uploads/2021/05/team-120x120.png")!)
    
        self.myMatchTableView.backgroundColor = .clear
        self.myMatchTableView.tableFooterView = UIView()
       // self.tableView.rowHeight = 80.0
        self.dataNotAvailableLabel.isHidden = true
        setupWalletView()
        setupMenu()
        
        let logo = UIImage(named:"layer3")
        let imageView = UIImageView(image:logo)
        imageView.frame = CGRect(x: 150, y: 20, width: 100.0, height: 30.0)
        self.navigationItem.titleView = imageView
        //if token != nil{
            token = UserDefaults.standard.string(forKey:"AccessToken")!
       // }
        print("HomeToken :", token as Any)
        print("BalanceToken :", balance as Any)
       self.walletAmount()
        self.myMatches()
        self.upcomingData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.myMatches()
        self.upcomingData()
       // self.navigationController?.isNavigationBarHidden = true
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let menuVC  = storyboard?.instantiateViewController(withIdentifier: "DPWalletVC") as? DPWalletVC
        
        self.navigationController?.pushViewController(menuVC!, animated:true)

    }
    
    @IBAction func btnWalletClick(_ sender: UIButton){
        let menuVC  = storyboard?.instantiateViewController(withIdentifier: "DPWalletVC") as? DPWalletVC
        self.navigationController?.pushViewController(menuVC!, animated:true)
    }
    
    func setupWalletView(){
        walletView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 92, height: 33))
        walletView.backgroundColor = .clear
        let imageView = UIImageView(image:#imageLiteral(resourceName: "wallet"))
        walletView.addSubview(imageView)
        imageView.frame = CGRect(x: walletView.frame.width/2-20/2, y: 0, width: 20, height: 20)
//        walletlabel = UILabel.init(frame: CGRect.init(x: 0, y: imageView.frame.maxY + 3, width: walletView.frame.width, height: 10))
//        walletlabel.textColor = .white
//        walletlabel.font = UIFont.systemFont(ofSize: 11)
//        walletlabel.text = " "
//        walletlabel.textAlignment = .center
//        walletView.addSubview(walletlabel)
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(DPHomePageVC.handleTap(_:)))
      
      walletView.addGestureRecognizer(tap1)
        let btn = UIBarButtonItem.init(customView: walletView)
        self.navigationItem.rightBarButtonItem = btn
        
    }
    
    @IBAction func btnMenu(_ sender: UIButton){
       // viewHeader.isHidden = true
        present(sideMenu!, animated: true, completion: nil)
    }
    func walletAmount(){
        
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            let headers: HTTPHeaders = ["Content-type": "multipart/form-data","Authorization":"Bearer" + " " + (token ?? ""),"X-Requested-With":"XMLHttpRequest"]


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
                        self.lblWallet.text = "₹" + (stramount.isEmpty ? "0" : stramount)
                            
                               
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
                       
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }


    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from:url) { data, response, error in
           /* let activityIndicator = UIActivityIndicatorView(style: .white)
                        activityIndicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
                           activityIndicator.startAnimating()
 */
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            // always update the UI from the main thread
            DispatchQueue.main.async() { [weak self] in
                // activityIndicator.stopAnimating()
                //activityIndicator.hidesWhenStopped = true
                /*   cell.imageView.sd_setImageWithURL(url, placeholderImage:nil, completed: { (image, error, cacheType, url) -> Void in
                 if (error) {
                 // set the placeholder image here
                 
                 } else {
                 // success ... use the image
                 }
                 })
                 
                 */
                self?.defaultImage = UIImage(data: data)
                print("DefaultImage\(String(describing: self?.defaultImage))")
            }
        }
    }
         
    func myMatches(){
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        else{
            let headers: HTTPHeaders = ["Content-type": "multipart/form-data","Authorization":"Bearer" + " " + (token ?? ""),"X-Requested-With":"XMLHttpRequest"]


                   AF.upload(
                       multipartFormData: { multipartFormData in
                       
                        
                   },
                    to: Constants.BaseUrl + "fixtures/my?type=&page=", method: .get , headers: headers)
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
                                print("response New \(responseString)")
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
                                    if let myArray = self.dataDictionary["fixtures"] as? [[String:Any]] {
                                        self.gamesArray = myArray
                                        print("GamesArray \(self.gamesArray)")
                                        
                                        
                                        if let first = self.gamesArray.first{
                                            self.gameArray.removeAll()
                                            self.gameArray.append(first)
                                        }
                                    }
                                    
//                                    if self.gameArray.count == 0 {
//                                        self.dataNotAvailableLabel.isHidden = false
//                                        self.myMatchTableView.isHidden = true
//                                        self.myMatchesLabel.isHidden = true
                                      
                                       // self.tableView.frame = CGRect(x: 20.0, y: 20.0, width: self.tableView.frame.width, height: self.tableView.frame.height)
//                                    }
                                  /*  else {
                                        self.myMatchTableView.isHidden = false
                                        self.myMatchesLabel.isHidden = false
                                        self.tableView.frame = CGRect(x: 20.0, y: 200.0, width: self.tableView.frame.width, height: self.tableView.frame.height)
                                    }
 */
                                }
                                    
                                }
                            
                            }
                            DispatchQueue.main.async {
                                self.dataNotAvailableLabel.isHidden = !(self.fixtureArray.count == 0 && self.gameArray.count == 0)
                            }
                        
                       }
            }
    }
    
    func logout(){
        UserDefaults.standard.set(false, forKey:"isUserLoggedIn")
        UserDefaults.standard.synchronize()
        let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let centerVC = mainStoryBoard.instantiateViewController(withIdentifier:"DPLoginVC") as! DPLoginVC
        let nav = UINavigationController.init(rootViewController: centerVC)
        nav.isNavigationBarHidden = true
        let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDel.window!.rootViewController = nav
        appDel.window!.makeKeyAndVisible()
    }
    
    func upcomingData(){
        // self.tableView.backgroundView = UIImageView(image: UIImage(named: "Background"))
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        else{
        SVProgressHUD.show()
            let headers: HTTPHeaders = ["Content-type": "multipart/form-data","Authorization":"Bearer" + " " + (token ?? ""),"X-Requested-With":"XMLHttpRequest"]
                let url = Constants.BaseUrl + "fixtures"
                print("API URL:\(url)")

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
                                    
                                    DispatchQueue.main.async { [self] in
                                      print("responseObject \(responseObject)")
                                        SVProgressHUD.dismiss()
                                        self.responseDictionary = responseObject as! [String:Any]
                                        
                                        let success:Int = self.responseDictionary["status"] as? Int ?? 0
                                        if success == 1{
                                            print("Success")
                                        }
                                        else{
                                            print("Error")
                                            if response.response?.statusCode ?? 401 == 401{
                                                self.logout()
                                                return
                                            }
                                        }
                                        
                                        if let dict = self.responseDictionary["data"]
                                            as? [String:Any] {
                                            self.dataDictionary = dict
                                            print("DataDictionary \(self.dataDictionary)")
                                            if let myArray = self.dataDictionary["fixtures"] as? [[String:Any]] {
                                                self.fixtureArray = myArray
                                                print("FixtureArray \(self.fixtureArray)")
                                            }
                                           
                                            //self.tableView.reloadData()
                                        }
                                        self.myMatchTableView.reloadData()
                                    }
                                }
                                DispatchQueue.main.async {
                                    self.dataNotAvailableLabel.isHidden = !(self.fixtureArray.count == 0 && self.gameArray.count == 0)
                                }
                               }
        }
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
    


extension DPHomePageVC:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return gameArray.count
        case 1:
            return fixtureArray.count
        default:
            return 0
        }
       /*
        if tableView == self.myMatchTableView {
            return 1
        }
        else if tableView == self.tableView {
            return self.fixtureArray.count 
        }
        
        return gamesArray.count
         */
        

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 130
        case 1:
            return 120
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cellA = tableView.dequeueReusableCell(withIdentifier: "DPHomePageCell2",for: indexPath as IndexPath) as! DPHomePageCell2
            let dictionary = self.gamesArray
            cellA.getCompletedGame(data: dictionary, vc: navigationController)
            print("Dictionaryssssss \(String(describing: dictionary))")
            
//            cellA.borderView.layer.cornerRadius = 8
//            cellA.borderView.layer.borderWidth = 1
//            cellA.borderView.layer.borderColor = UIColor.clear.cgColor
//            cellA.borderView.layer.masksToBounds = true
//            cellA.borderView.clipsToBounds = true
//            //             }
//            cellA.lblTeamAScore.text = dictionary?["teama_score"] as? String ?? ""
//            cellA.lblTeamBScore.text = dictionary?["teamb_score"] as? String ?? ""
//            if let teamAIcon = cellA.viewWithTag(40) as? UIImageView {
//                if let imageUrl = dictionary?["teama_image"] as? String,
//                   !imageUrl.isEmpty, let imgURl =  URL(string:imageUrl) {
//                    teamAIcon.sd_setImage(with: imgURl,placeholderImage: self.defaultImage, completed: nil)
//
//                }
//                else {
//                    teamAIcon.image = self.defaultImage
//                }
//
//
//
//
//            }
//
//
//            if let teamBIcon = cellA.viewWithTag(50) as? UIImageView {
//
//                if let imageUrl = dictionary?["teamb_image"] as? String,
//                   !imageUrl.isEmpty, let imgURl =  URL(string:imageUrl) {
//                    teamBIcon.sd_setImage(with: imgURl,placeholderImage: self.defaultImage, completed: nil)
//
//                }
//                else {
//                    teamBIcon.image = self.defaultImage
//
//                }
//            }
//
//            if let teamA = cellA.viewWithTag(60) as? UILabel {
//                teamA.text = dictionary?["teama_short_name"] as? String
//            }
//
//            if let teamB = cellA.viewWithTag(70) as? UILabel {
//                teamB.text = dictionary?["teamb_short_name"] as? String
//            }
//            if let gameStatus = cellA.viewWithTag(80) as? UILabel {
//                gameStatus.backgroundColor = .red
//                gameStatus.textColor = .white
//                if  let stats = dictionary?["status"] as? String {
//                    if stats == "LIVE" {
//                        gameStatus.text = "Time's up!"
//                    }
//                    else{
//                        gameStatus.text = dictionary?["status"] as? String
//                    }
//                }
//
//            }
//            if let gameType = cellA.viewWithTag(90) as? UILabel {
//                gameType.text = dictionary?["type"] as? String
//            }
            return cellA
        }
            
        else if indexPath.section == 1 {
            let cellB = tableView.dequeueReusableCell(withIdentifier: DPHomePageCell.ID,for: indexPath as IndexPath) as! DPHomePageCell
            
            
           
        let dictionary = self.fixtureArray[indexPath.row]
        print("Dictionary \(dictionary)")
        
//       if let borderView = cellB.viewWithTag(10) {
            
            

        cellB.borderView.layer.cornerRadius = 8
        cellB.borderView.layer.borderWidth = 1
        cellB.borderView.layer.borderColor = UIColor.clear.cgColor
        cellB.borderView.layer.masksToBounds = true
        cellB.borderView.clipsToBounds = true
//        }
        
       if let matchName = cellB.viewWithTag(20) as? UILabel {
        matchName.text = dictionary["competition"] as? String
        }
            
            if let teamAIcon = cellB.viewWithTag(40) as? UIImageView {
                
                if let imageUrl = dictionary["teama_image"] as? String,
                        !imageUrl.isEmpty, let imgURl =  URL(string:imageUrl) {
                    teamAIcon.sd_setImage(with: imgURl,placeholderImage: self.defaultImage, completed: nil)
                    }
                
                }
        
      
        
        if let teamBIcon = cellB.viewWithTag(50) as? UIImageView {
            
            if let imageUrl = dictionary["teamb_image"] as? String,
                    !imageUrl.isEmpty, let imgURl =  URL(string:imageUrl) {
                teamBIcon.sd_setImage(with: imgURl,placeholderImage: self.defaultImage, completed: nil)
                
            }
           
        }
            
            if let teamA = cellB.viewWithTag(60) as? UILabel {
            teamA.text = dictionary["teama_short_name"] as? String
             }
        
        
        if let teamA = cellB.viewWithTag(70) as? UILabel {
            teamA.text = dictionary["teamb_short_name"] as? String
        }
        
            if let status = dictionary["status"] as? String {
                switch status {
                case "NOT STARTED":
                    if !cellB.isStarted{
                        if let time = dictionary["starting_at"] as? String, !time.isEmpty{
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat="yyyy-MM-dd HH:mm:ss"
                            dateFormatter.timeZone = TimeZone.current
                            let date = dateFormatter.date(from: time)
        //                    let dateStamp:TimeInterval = date!.timeIntervalSince1970
                            let now = Date()
                            
                            let dateStamp:TimeInterval = date!.timeIntervalSince1970 - now.timeIntervalSince1970
                            
                            cellB.lblTimer.timeFormat = "HH'h':mm'm':ss's'";
                            cellB.lblTimer.setCountDownTime(dateStamp)
                            cellB.lblTimer.timerType = MZTimerLabelTypeTimer
                            cellB.isStarted = true
                            cellB.lblTimer.endedBlock = { (countTime) in
                                //oh my gosh, it's awesome!!
                                cellB.lblTimer.text = "Time's up!"
                            };
                            cellB.lblTimer.start()
                            
                        }
                        else{
                            cellB.lblTimer.text = status
                        }
                    }

                    break
                 
                default:
                    cellB.lblTimer.text = status
                    break
                }
                
            }
            
//        if let gameStatus = cellB.viewWithTag(80) as? UILabel {
//        gameStatus.text = dictionary["status"] as? String
//         }
        if let gameType = cellB.viewWithTag(90) as? UILabel {
        gameType.text = dictionary["type"] as? String
         }
        
        
       /* if let firstCountryFlag = cell.viewWithTag(40) {
            firstCountryFlag.layer.borderWidth = 1.0
            firstCountryFlag.layer.masksToBounds = true
            firstCountryFlag.layer.borderColor = UIColor.clear.cgColor
            // self.profileImageView.borderColor = UIColor(red: 0.0/255, green: 145.0/255, blue: 186.0/255, alpha: 1.0)
            firstCountryFlag.layer.cornerRadius = self.firstCountryView.frame.size.width / 2
            firstCountryFlag.clipsToBounds = true
         }
        if let secondCountryFlag = cell.viewWithTag(50) {
           secondCountryFlag.layer.borderWidth = 1.0
            secondCountryFlag.layer.masksToBounds = true
            secondCountryFlag.layer.borderColor = UIColor.clear.cgColor
            // self.profileImageView.borderColor = UIColor(red: 0.0/255, green: 145.0/255, blue: 186.0/255, alpha: 1.0)
            secondCountryFlag.layer.cornerRadius = self.firstCountryView.frame.size.width / 2
            secondCountryFlag.clipsToBounds = true
         }
 */
        
        return cellB
    }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            
            let dictionary = self.fixtureArray[indexPath.row]
            print("HomeDictionary \(dictionary)")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let menuVC  = storyboard.instantiateViewController(withIdentifier: "DPContestVC") as? DPContestVC
            menuVC?.contestDictionary = dictionary
            //            print("MenuVC.ContestDictionary \(menuVC?.contestDictionary)")
            let pref:UserDefaults = UserDefaults.standard
            pref.set(dictionary, forKey:"ContestDictionary")
            // pref.set(self.flag, forKey: "Flag")
            pref.synchronize()
            menuVC?.tagController = "homeDetail"
            menuVC?.modalPresentationStyle = .fullScreen
            self.navigationController?.present(menuVC!, animated: false)
          //  self.navigationController?.pushViewController(menuVC!, animated: true)
        }
        else if indexPath.section == 0 {
            
            
            let dictionary = self.gameArray[indexPath.row]
            print("Dictionary \(dictionary)")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let menuVC  = storyboard.instantiateViewController(withIdentifier: "DPContestVC") as? DPContestVC
            menuVC?.contestDictionary = dictionary
            
            self.navigationController?.pushViewController(menuVC!, animated: true)
        }
    }
        
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var height:CGFloat = 0.0
        if section == 0{
            if gameArray.count > 0{
                height = 46
            }
        }
        if section == 1{
            if fixtureArray.count > 0{
                height = 46
            }
        }
        return height
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0{
            let totalHeight = 46
            let labelHeight = 30
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: Int(tableView.frame.width), height: totalHeight))
            let label = UILabel.init(frame: CGRect.init(x: 8, y: totalHeight/2 - labelHeight/2 , width: Int(tableView.frame.width)-16, height: labelHeight))
            label.font = UIFont.systemFont(ofSize: 17)
            label.textColor = .white
            label.text = "My Matches"
            headerView.backgroundColor = view.backgroundColor//UIColor.init(red: 0/255, green: 5/255, blue: 73/255, alpha: 1.0)
            headerView.addSubview(label)
            return headerView
        }
        else if section == 1{
            let totalHeight = 46
            let labelHeight = 30
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: Int(tableView.frame.width), height: totalHeight))
            let label = UILabel.init(frame: CGRect.init(x: 8, y: totalHeight/2 - labelHeight/2 , width: Int(tableView.frame.width)-16, height: labelHeight))
            label.font = UIFont.systemFont(ofSize: 17)
            label.textColor = .white
            label.text = "Select Upcoming Matches"
            headerView.backgroundColor = view.backgroundColor//UIColor.init(red: 0/255, green: 5/255, blue: 73/255, alpha: 1.0)
            headerView.addSubview(label)
            return headerView
        }
        else{
            return nil
        }
    }
}
    
class DPHomePageCell: UITableViewCell {
    static let ID = "DPHomePageCell"
    @IBOutlet weak var borderView: UIView!
    
    @IBOutlet weak var lblTimer: MZTimerLabel!
    
    var isStarted:Bool = false
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}



