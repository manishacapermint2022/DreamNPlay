//
//  DPLeaderBoardVC.swift
//  DreamPlay
//
//  Created by MAC on 21/07/21.
//

import UIKit
import Alamofire
import SVProgressHUD
import SideMenu
import KSToastView

class DPLeaderBoardVC: UIViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomTableView: UITableView!
    var contestArrayData: [String: Any] = [:]
    var topData : [String] = []
    var downData = [String]()
    var isOpen = false
    @IBOutlet weak var teamAName: UILabel!
    @IBOutlet weak var teamBName: UILabel!
    @IBOutlet weak var lblWallet: UILabel!
    @IBOutlet weak var viewHeader: UIView!
    
    
    var defaultImage:UIImage?
    var screenCheck = false
    var prizeDictionary:[String:Any] = [:]
    var fixtureId:Int?
    var token:String?
    @IBOutlet weak var topTableView: UITableView!
    var prizeCellDictionary:[String:Any] = [:]
    var prizeArray:[[String:Any]] = []
   // var fixtureid: Any? = UserDefaults.standard.object(forKey:"FixtureId") as Any?
    var responseDictionary:[String:Any] = [:]
    var dataDictionary:[String:Any] = [:]
    var fixtureDictionary:[String:Any] = [:]
    var leaderDictionary:[String:Any] = [:]
    var contestID:Int?
    var contestid:String?
    var walletView : UIView!
   // var walletlabel : UILabel!
    var userDictionary:[String:Any] = [:]
    @IBOutlet weak var dataNotAvailableLabel: UILabel!
    var sideMenu:SideMenuNavigationController?
    var contestDictionary:[String:Any] = [:]
    var userTeam:[[String:Any]] = []
    var leaderboardArray:[[String:Any]] = []
    @IBOutlet weak var teamAImageView: UIImageView!
    @IBOutlet weak var teamBImageView: UIImageView!
    var matchStatus:String?
    var getContestArray:[[String:Any]] = []
    var contestId:Int?
    var contestArray:[[String:Any]] = []
    var fixtureid:String?
    var walletAmounts:NSNumber = 0
    var headerStatus = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupWalletView()
        self.setupMenu()
        
        self.dataNotAvailableLabel.isHidden = true
        self.bottomTableView.rowHeight = 100.0
        topView.layer.cornerRadius = 8
         topView.layer.borderWidth = 1
         topView.layer.borderColor = UIColor.clear.cgColor
        let logo = UIImage(named:"layer3")
        let imageView = UIImageView(image:logo)
        imageView.frame = CGRect(x: 150, y: 20, width: 100.0, height: 30.0)
        self.navigationItem.titleView = imageView

        self.topTableView.backgroundView = UIImageView(image: UIImage(named: "Background"))
        contestDictionary = UserDefaults.standard.object(forKey:"ContestDictionary") as? [String:Any] ?? [:]
    //    self.fixtureId = self.contestDictionary["id"] as? Int
        self.contestID = self.contestArrayData["id"] as? Int
//        if let id = self.fixtureId   {
//            self.fixtureid = String(id)
//            print("Fixtureid :",fixtureid)
//        }
        
        self.matchStatus = contestDictionary["status"] as? String
       // prizeCellDictionary = UserDefaults.standard.object(forKey:"PrizeBreakUPDictionary") as? [String:Any] ?? [:]
        
        self.topTableView.rowHeight = 180.0
        self.bottomTableView.rowHeight = 100.0
        topView.layer.cornerRadius = 8
         topView.layer.borderWidth = 1
         topView.layer.borderColor = UIColor.clear.cgColor
        token = UserDefaults.standard.string(forKey:"AccessToken")!
        print("Token :", token as Any)
        navigationController?.isNavigationBarHidden = true

//        if headerStatus == "NavigationShow"{
//            viewHeader.isHidden = true
//        }else{
//            viewHeader.isHidden = false
//        }
        // self.getContest()
        // self.getContests()
        
        self.navigationItem.titleView = imageView
        self.topTableView.backgroundView = UIImageView(image: UIImage(named: "Background"))
        self.teamAName.text = self.contestDictionary["teama"] as? String
        self.teamBName.text = self.contestDictionary["teamb"] as? String
        
        if let imageUrl = self.contestDictionary["teama_image"] as? String,
               !imageUrl.isEmpty, let imgURl =  URL(string:imageUrl) {
            self.teamAImageView.sd_setImage(with: imgURl,placeholderImage:self.defaultImage, completed: nil)
           }
      
        if let imageUrl1 = self.contestDictionary["teamb_image"] as? String,
           !imageUrl1.isEmpty, let imgURl1 =  URL(string:imageUrl1) {
            self.teamBImageView.sd_setImage(with: imgURl1,placeholderImage:self.defaultImage, completed: nil)
       }
       
      //  self.fixtureId = self.prizeDictionary["id"] as? Int
        token = UserDefaults.standard.string(forKey:"AccessToken")!
        print("Token :", token as Any)
        print("FixtureId :", fixtureId as Any)
        print("LeaderDictionary :", leaderDictionary)
        print("PrizeCellDictionary :", prizeCellDictionary)
        //self.contestID = self.leaderDictionary["contest_category_id"] as? Int
        //print("ContestIDs :", self.contestID)
        
       /* if let id = self.contestID {
            self.contestid = String(id)
        }
 */
        
        
        self.walletAmount()
        
        //self.getContestID()
        
        
        if let myArray = self.prizeCellDictionary["prize_breakup"] as? [[String:Any]] {
            self.prizeArray = myArray
        }
        self.downloadImage(from: URL(string:"https://cricket.entitysport.com/assets/uploads/2021/05/team-120x120.png")!)
        
        self.bottomTableView.reloadData()
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
        
        if let id = self.fixtureid as? String {
           
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data","Authorization":"Bearer" + " " + token!,"X-Requested-With":"XMLHttpRequest"]

                   AF.upload(
                       multipartFormData: { multipartFormData in
                   },
                    to: Constants.BaseUrl + "fixtures/" + id, method: .get , headers: headers)
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
                              print("responseObjectFixture \(responseObject)")
                                SVProgressHUD.dismiss()
                                self.responseDictionary = responseObject as! [String:Any]
                                if let dict = self.responseDictionary["data"]
                                    as? [String:Any] {
                                    self.dataDictionary = dict
                                    print("DataDictionary \(self.dataDictionary)")
                                    if let dict = self.dataDictionary["fixture"] as? [String:Any] {
                                    self.fixtureDictionary = dict
                                        
                                    }
                                }
                                self.topTableView.reloadData()
                                self.bottomTableView.reloadData()
                            }
                         }
                       }
                   }
               }
            
        

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
      //  self.getContests()
        self.leaderBoardData()
          //self.tabBarController?.tabBar.isHidden = true
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
    
    func setupWalletView(){
           walletView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 92, height: 33))
           walletView.backgroundColor = .clear
           let imageView = UIImageView(image:#imageLiteral(resourceName: "wallet"))
           walletView.addSubview(imageView)
           imageView.frame = CGRect(x: walletView.frame.width/2-20/2, y: 0, width: 20, height: 20)
//           walletlabel = UILabel.init(frame: CGRect.init(x: 0, y: imageView.frame.maxY + 3, width: walletView.frame.width, height: 10))
//           walletlabel.textColor = .white
//           walletlabel.font = UIFont.systemFont(ofSize: 11)
//           walletlabel.text = " "
//           walletlabel.textAlignment = .center
//           walletView.addSubview(walletlabel)
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(DPPrizeBreakupController.handleTap(_:)))
      
      walletView.addGestureRecognizer(tap1)
           let btn = UIBarButtonItem.init(customView: walletView)
           self.navigationItem.rightBarButtonItem = btn
           
       }
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let menuVC  = storyboard?.instantiateViewController(withIdentifier: "DPWalletVC") as? DPWalletVC
        
        
        self.navigationController?.pushViewController(menuVC!, animated:true)

    }
    @IBAction func btnWalletClick(_ sender: UIButton){
        let menuVC  = storyboard?.instantiateViewController(withIdentifier: "DPWalletVC") as? DPWalletVC
        self.navigationController?.pushViewController(menuVC!, animated:true)
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
                        
                        //                                   if let amount = self.userDictionary["balance"] as? Int {
                        //                                    self.walletAmounts = amount
                        //                                       self.walletlabel.text = "₹" + String(amount)
                        //                                   }
                        
                        let stramount = self.getAmount(self.userDictionary["balance"] as Any )
                        self.lblWallet.text = "₹" + (stramount.isEmpty ? "0" : stramount)
                        guard let wAmount  = NumberFormatter().number(from: stramount.isEmpty ? "0" : stramount) else {return}
                        self.walletAmounts =  wAmount
                        
                        
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
    
    func getContestID(){
        
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        else{
            
            if let id = self.fixtureid as? String {
                print("contestIdsss \(id)")
                SVProgressHUD.show()
                let headers: HTTPHeaders = ["Content-type": "multipart/form-data","Authorization":"Bearer" + " " + token!,"X-Requested-With":"XMLHttpRequest"]
                
                
                AF.upload(
                    multipartFormData: { multipartFormData in
                        
                        
                    },
                    
                    to: Constants.BaseUrl + "contests?fixture_id=" + id, method: .get , headers: headers)
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
                            print("responseObjectssss \(responseObject)")
                            SVProgressHUD.dismiss()
                            self.responseDictionary = responseObject as! [String:Any]
                            if let dict = self.responseDictionary["data"]
                                as? [String:Any] {
                                self.dataDictionary = dict
                                print("DataDictionary \(self.dataDictionary)")
                                if let myArray = self.dataDictionary["contests"] as? [[String:Any]] {
                                    self.getContestArray = myArray
                                    print("GetContestArray\(self.getContestArray)")
                                    let dict = self.getContestArray.first
                                    print("Dictionarysss\(String(describing: dict))")
                                    self.contestId = dict?["id"] as? Int
                                    print("ContestID\(String(describing: self.contestId))")
                                    if let id = self.contestId  {
                                        self.contestid = String(id)
                                    }
                                    
                                    
                                    
                                    
                                    self.topTableView.reloadData()
                                    self.bottomTableView.reloadData()
                                  //  self.leaderBoardData()
                                }
                            }
                        }
                    }
                }
            }
            
        }
        
    }
    
    func getContests(){
        
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
        SVProgressHUD.show()
            if let id = self.fixtureid as? String {
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data","Authorization":"Bearer" + " " + token!,"X-Requested-With":"XMLHttpRequest"]


           AF.upload(
                       multipartFormData: { multipartFormData in
                       
                        
                   },
                    to: Constants.BaseUrl + "contests?fixture_id=" + id, method: .get , headers: headers)
                       .responseJSON { response in
                        
                        SVProgressHUD.dismiss()
                        switch response.result {
                        case .failure(let error):
                            
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
                            SVProgressHUD.dismiss()
                            DispatchQueue.main.async {
                              print("responseObject \(responseObject)")
                                SVProgressHUD.dismiss()
                                self.responseDictionary = responseObject as! [String:Any]
                                if let dict = self.responseDictionary["data"]
                                    as? [String:Any] {
                                    self.dataDictionary = dict
                                    print("DataDictionary \(self.dataDictionary)")
                                    if let myArray = self.dataDictionary["contests"] as? [[String:Any]] {
                                        self.contestArray = myArray.filter({ dict in
                                            let key = dict["contest_category_id"] as? Int ?? 0
                                            let key2 = self.prizeCellDictionary["contest_category_id"] as? Int ?? 0
                                            return key != 0 && key2 != 0 && key == key2
                                        })
                                        print("ContestArray \(self.contestArray)")
                                    }
                                    if self.contestArray.count == 0 {
                                       // self.dataNotAvailableLabel.isHidden = false
                                    }
                                    self.topTableView.reloadData()
                                    self.bottomTableView.reloadData()
                                }
                            
                            }
                        }
//                        DispatchQueue.main.async {
                           // self.dataNotAvailableLabel.isHidden = (self.contestArray.count > 0)
//                        }
                        }
                       }
        }
    }
    
    func getContest(){
        
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
        SVProgressHUD.show()
            if let id = self.fixtureid as? String {
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data","Authorization":"Bearer" + " " + token!,"X-Requested-With":"XMLHttpRequest"]


           AF.upload(
                       multipartFormData: { multipartFormData in
                       
                        
                   },
                    to: Constants.BaseUrl + "my_contests?fixture_id=" + id, method: .get , headers: headers)
                       .responseJSON { response in
                        
                        SVProgressHUD.dismiss()
                        switch response.result {
                        case .failure(let error):
                            
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
                            SVProgressHUD.dismiss()
                            DispatchQueue.main.async {
                              print("responseObject \(responseObject)")
                                SVProgressHUD.dismiss()
                                self.responseDictionary = responseObject as! [String:Any]
                                if let dict = self.responseDictionary["data"]
                                    as? [String:Any] {
                                    self.dataDictionary = dict
                                    print("DataDictionary \(self.dataDictionary)")
                                    if let myArray = self.dataDictionary["contests"] as? [[String:Any]] {
                                        self.contestArray = myArray
                                        print("ContestArray \(self.contestArray)")
                                    }
                                    if self.contestArray.count == 0 {
                                       // self.dataNotAvailableLabel.isHidden = false
                                    }
                                    self.topTableView.reloadData()
                                    self.bottomTableView.reloadData()
                                }
                            
                            }
                        }
//                        DispatchQueue.main.async {
                           // self.dataNotAvailableLabel.isHidden = (self.contestArray.count > 0)
//                        }
                        }
                       }
        }
    }
    

    
    @IBAction func prizeBreakupButtonTapped(_ sender: Any) {
        
        let menuVC  = storyboard?.instantiateViewController(withIdentifier: "DPPrizeBreakupController") as? DPPrizeBreakupController
        menuVC?.contestArrayData = contestArrayData
      //  menuVC?.leaderDictionary = prizeCellDictionary
        menuVC?.prizeCellDictionary = prizeCellDictionary
        menuVC?.headerController = "Navigation"
        self.navigationController?.pushViewController(menuVC!, animated: false)

    }
    
    func checkAvailableTeam(_ contest_id:Int){
        
        if let id = self.fixtureId  {
            self.fixtureid = String(id)
        }
        
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
        
        if let id = self.fixtureid as? String {
        
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data","Authorization":"Bearer" + " " + token!,"X-Requested-With":"XMLHttpRequest"]


                   AF.upload(
                       multipartFormData: { multipartFormData in
                       
                        
                   },
                    to: Constants.BaseUrl + "user_teams?fixture_id=" + id, method: .get , headers: headers)
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
                                    if let myArray = self.dataDictionary["user_teams"] as? [[String:Any]] {
                                        self.userTeam = myArray
                                        print("UserTeam\(self.userTeam)")
                                        
                                        if self.userTeam.count == 0 {
                                            
                                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    let menuVC  = storyboard.instantiateViewController(withIdentifier: "DPTeamSelectionVC") as? DPTeamSelectionVC
                                            
                                            self.navigationController?.pushViewController(menuVC!, animated: true)
                                        }
                                        else {
                                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                                    let menuVC  = storyboard.instantiateViewController(withIdentifier: "DPMyContestVC") as? DPMyContestVC
//                                            menuVC?.flag = self.flag
                                            let menuVC  = storyboard.instantiateViewController(withIdentifier: "DPJoinContestTeamVC") as! DPJoinContestTeamVC
                                            menuVC.contestId = contest_id
                                            self.navigationController?.pushViewController(menuVC, animated: true)
                                            
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
   
    
    func leaderBoardData(){
        
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            
            if let id = self.contestID  {
                
                
                let headerss: HTTPHeaders = ["Content-type": "multipart/form-data","Authorization":"Bearer" + " " + token!,"X-Requested-With":"XMLHttpRequest"]
                
                AF.request(Constants.BaseUrl + "contests/leaderboard", method: .get, parameters: ["contest_id": id], headers: headerss)
                
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
                                print("responseObjectFixturessLeaderBoard \(responseObject)")
                                SVProgressHUD.dismiss()
                                self.responseDictionary = responseObject as! [String:Any]
                                if let dict = self.responseDictionary["data"] as? [String:Any] {
                                    self.dataDictionary = dict
                                    print("LeaderboardDataDictionary \(self.dataDictionary)")
                                }
                                if let myArray = self.dataDictionary["leaderboard"] as? [[String:Any]] {
                                    
                                    self.leaderboardArray = myArray
                                    print("LeaderboardArray \(self.leaderboardArray)")
                                    if self.leaderboardArray.count == 0 {
                                        self.dataNotAvailableLabel.isHidden = false
                                    }
                                    self.topTableView.reloadData()
                                    self.bottomTableView.reloadData()
                                }
                                
                            }
                        }
                    }
                }
           }
      }
    
    @IBAction func toggleButtonTapped(_ sender: Any) {
        present(sideMenu!, animated: true, completion: nil)
    }
}

extension DPLeaderBoardVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRow = 1
        switch tableView {
        case topTableView:
            numberOfRow = 1 //self.contestArray.count //topData.count
        case bottomTableView:
            numberOfRow = self.leaderboardArray.count//downData.count
        default:
            print("Some things Wrong!!")
        }
        return numberOfRow
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        switch tableView {
        case topTableView:
            cell = tableView.dequeueReusableCell(withIdentifier: "topCell", for: indexPath)
            let dictionary = contestArrayData //self.contestArray[indexPath.row]
            
            print("dictionaryssss \(dictionary)")
            
            if let button = cell.viewWithTag(200) as? UIButton {
                if self.matchStatus == "LIVE" || self.matchStatus == "COMPLETED"  || self.matchStatus == "IN REVIEW"{
                    button.backgroundColor = UIColor.lightGray
                }
                button.tag = indexPath.row
                button.makeCornerRadius(5)
                button.addTarget(self, action: #selector(DPLeaderBoardVC.buttonClicked), for: UIControl.Event.touchUpInside)
                
                if let fee = dictionary["entry_fee"] as? Int {
                    let entry = "₹" + String(fee)
                    button.setTitle(entry, for: UIControl.State.normal)
                }
            }
            if let prize = cell.viewWithTag(40) as? UILabel {
                if let prizes = dictionary["prize"] as? Int{
                    let entry = "₹" + String(prizes)
                    prize.text = String(entry)
                }
            }
            
           
            
            if let totalTeam = cell.viewWithTag(50) as? UILabel {
                if let total = dictionary["total_teams"] as? Int {
                    let totalTeams = String(total)
                    
                    let maxTeam = dictionary["joined"] as? Int
                    print("Joined \(String(describing:maxTeam))")
                    let max = String(maxTeam!)
                    let value =  max + "/" + totalTeams //totalTeams//
                    
                    totalTeam.text =  value
                    
                }
            }
            
            if let totalTeam = cell.viewWithTag(11) as? UIProgressView {
                if let total = dictionary["total_teams"] as? Int {
                    let totalTeams = String(total)
                    let maxTeam = dictionary["joined"] as? Int
                    let max = String(maxTeam!)
                    let progress = (Float((Int(max) ?? 0))/Float((Int(totalTeams) ?? 0)))
                    totalTeam.progress = progress
                }
            }
            /* if let totalTeam = cell.viewWithTag(60) as? UILabel {
             if let total = dictionary["total_teams"] as? Int {
             let maxTeam = dictionary["joined"] as? Int
             print("Joined \(String(describing:maxTeam))")
             let sum = total - maxTeam!
             
             totalTeam.text =  String(sum) + " " + "Seats" + " " + "Left"
             
             }
             }
             */
            
            if let totalTeam = cell.viewWithTag(70) as? UILabel {
                if let total = dictionary["total_teams"] as? Int {
                    totalTeam.text = String(total) + " " + "Total" + " " + "Seats"
                }
            }
            
            //            if let entryFee = cell.viewWithTag(80) as? UILabel {
            //                if let fee = dictionary["entry_fee"] as? Int {
            //                    entryFee.text = "₹" + String(fee)
            //                }
            //
            //             }
            if let gameType = cell.viewWithTag(90) as? UILabel {
                gameType.text = dictionary["type"] as? String
            }
            
            
            // cell.textLabel?.text = "A"//topData[indexPath.row]
            // cell.backgroundColor = UIColor.green
            
        case bottomTableView:
            cell = tableView.dequeueReusableCell(withIdentifier: "bottomCell", for: indexPath)
            let dictionary = self.leaderboardArray[indexPath.row]
            
            print("Leaderboarddictionaryssss \(dictionary)")
            if indexPath.row == 0 {
                if let stack = cell.viewWithTag(101) as? UIStackView {
                    stack.isHidden = false
                }
            } else {
                if let stack = cell.viewWithTag(101) as? UIStackView {
                    stack.isHidden = true
                }
            }
            
            if let rankLabel = cell.viewWithTag(10) as? UILabel {
                if let rank = dictionary["rank"] as? Int {
                    rankLabel.text = String(rank)
                }
            }
            if let totalPointLabel = cell.viewWithTag(30) as? UILabel {
                if let point = dictionary["total_points"] as? Double {
                    totalPointLabel.text = String(point)
                }
            }
            
            if let userNameLabel = cell.viewWithTag(20) as? UILabel {
                userNameLabel.text = dictionary["name"] as? String
            }
            
            print("dictionaryssss \(dictionary)")
            //   cell.textLabel?.text = "B"//downData[indexPath.row]
            // cell.backgroundColor = UIColor.yellow
        default:
            print("Some things Wrong!!")
        }
        
        return cell
    }
    @objc func buttonClicked(sender : UIButton!) {
        if self.matchStatus == "LIVE" || self.matchStatus == "COMPLETED" || self.matchStatus == "IN REVIEW"{
            return;
        }
        let index = sender.tag
        
        let dictionary = self.contestArray[index]
        
        print("WalletAmountss \(self.walletAmounts)")
        
        if let entry_fee = dictionary["entry_fee"] as? Int{
            var wallet = self.walletAmounts.intValue
            wallet = (wallet == 0) ? -1 : wallet
            print("Wallet \(String(describing: wallet))")
            if wallet < entry_fee{
                KSToastView.ks_showToast("Insufficient Balance", duration: 4.0)
                return
            }
            if let id = dictionary["id"] as? Int{
                self.checkAvailableTeam(id)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == bottomTableView {
            if indexPath.row == 0 {
                return 100
            } else {
                return 50
            }
        }
        return UITableView.automaticDimension
    }
    
    @objc func buttonClicked2(sender : UIButton!) {
        
        if self.matchStatus == "LIVE" || self.matchStatus == "COMPLETED" {
           print("Ankit")
        }
        if self.walletAmounts.intValue < 100  {
            KSToastView.ks_showToast("Insufficient Balance", duration: 4.0) {
                      // KSToastView.ks_showToast("Game Over!", delay: 0.5)
            }
        }
        else if self.walletAmounts.intValue >= 100  {
        self.checkAvailableTeam(0)
       }

    }
  
}

