//
//  DPScorecardViewController.swift
//  DreamPlay
//
//  Created by MAC on 12/07/21.
//

import UIKit
import Alamofire
import SVProgressHUD
import SDWebImage
import SideMenu

class DPScorecardViewController: UIViewController {
   
    
    @IBOutlet weak var topView: UIView!
    var token:String?
    var responseDictionary:[String:Any] = [:]
    var dataArray:[[String:Any]] = []
    var fixtureIds:Int?
    var fixtureid:String?
    var isOpen = false
    var screenCheck = false
    var sectionsData: [Section] = []
    var storedOffsets = [Int: CGFloat]()
    var explandCellIndex = -1
    var defaultImage:UIImage?
    @IBOutlet weak var tableView: UITableView!
    

    @IBOutlet weak var contestLabel: UILabel!
    var topDictionary:[String:Any] = [:]
    @IBOutlet weak var dataNotAvailableLabel: UILabel!
    @IBOutlet weak var myTeamLabel: UILabel!
    @IBOutlet weak var myContestLabel: UILabel!
    @IBOutlet weak var teamAName: UILabel!
    @IBOutlet weak var amountLabel:UILabel!
    var paymentArray:[[String:Any]] = []
    @IBOutlet weak var scorecardLabel: UILabel!
    @IBOutlet weak var teamBImageView: UIImageView!
    @IBOutlet weak var teamAImageView: UIImageView!
    
    @IBOutlet weak var createTeamButton: UIButton!
    var fixtureDictionary:[String:Any] = [:]
    var dataDictionary:[String:Any] = [:]
    var userTeam:[[String:Any]] = []
    var fixtureId:String?
   // let fixtureId: Any? = UserDefaults.standard.object(forKey:"FixtureId") as Any?
    var contestDictionary:[String:Any] = [:]
    var userDictionary:[String:Any] = [:]
    var walletView : UIView!
    var walletlabel : UILabel!
    var batsmanList:[[String:Any]] = []
    var bowlerList:[[String:Any]] = []
    var fallWicketList:[[String:Any]] = []
    var extraList:[String:Any] = [:]
    var totalList:[String:Any] = [:]
    var sideMenu:SideMenuNavigationController?
    var timer = Timer()
    var scorecardDictionary:[String:Any] = [:]
    var fixtureID:String?
    var flags:Int?
    var matchStatus:String?
    
        
    @IBOutlet weak var teamBName: UILabel!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.setupMenu()
        self.setupWalletView()
        createTeamButton.cornerRadius = 8
        topView.cornerRadius = 8
        //topView.layer.borderWidth = 1
        // topView.layer.borderColor = UIColor.clear.cgColor
        // self.contestDictionary = UserDefaults.standard.object(forKey:"ContestDictionary") as? [String:Any] ?? [:]
        print("ContestDictionary", contestDictionary)
        self.matchStatus = contestDictionary["status"] as? String
        
        if self.matchStatus == "LIVE" || self.matchStatus == "COMPLETED" || self.matchStatus == "IN REVIEW" {
            self.createTeamButton.isHidden = true
        }
        
        self.downloadImage(from: URL(string:"https://cricket.entitysport.com/assets/uploads/2021/05/team-120x120.png")!)
        
        
        
        
        if self.flags == 1 {
            if let id = self.scorecardDictionary["id"] as? Int {
                self.fixtureId = String(id)
            }
            
        }else {
            
            if let id = self.contestDictionary["id"] as? Int {
                self.fixtureId = String(id)
            }
        }
        
        let logo = UIImage(named:"layer3")
        let imageView = UIImageView(image:logo)
        imageView.frame = CGRect(x: 150, y: 20, width: 100.0, height: 30.0)
        self.navigationItem.titleView = imageView
        
        token = UserDefaults.standard.string(forKey:"AccessToken")!
        print("Token :", token as Any)
        print("ScorecardDictionary", scorecardDictionary)
        print("Flags", flags)
        
     //   self.scorecard()
        
        
        
        self.contestLabel.isHidden = true
        self.myContestLabel.isHidden = true
        self.myTeamLabel.isHidden = true
        self.scorecardLabel.isHidden = false
        
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
        
        
        self.walletAmount()
        
        
        //  self.fixtureid = self.fixtureId as? String
        
        /*  let pref:UserDefaults = UserDefaults.standard
         pref.set(self.fixtureId, forKey:"FixtureId")
         pref.synchronize()
         */
        
        
        apiCardFixtures()
        
//        if let id = self.fixtureId  {
//            //self.tabBarController?.tabBar.isHidden = true
//            let headers: HTTPHeaders = ["Content-type": "multipart/form-data","Authorization":"Bearer" + " " + token!,"X-Requested-With":"XMLHttpRequest"]
//
//
//            AF.upload(
//                multipartFormData: { multipartFormData in
//
//
//                },
//                to: Constants.BaseUrl + "fixtures/" + id, method: .get , headers: headers)
//            .responseJSON { response in
//
//
//                switch response.result {
//                case .failure(let error):
//                    SVProgressHUD.dismiss()
//                    let alertController = UIAlertController(title: "Alert", message: "Some error Occured", preferredStyle: .alert)
//                    let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
//                        print("you have pressed the Ok button");
//                    }
//                    alertController.addAction(okAction)
//                    self.present(alertController, animated: true, completion:nil)
//                    print(error)
//                    if let data = response.data,
//                       let responseString = String(data: data, encoding: .utf8) {
//                        print(responseString)
//                        print("response \(responseString)")
//                    }
//                case .success(let responseObject):
//
//                    DispatchQueue.main.async {
//                        print("responseObjectFixture \(responseObject)")
//                        SVProgressHUD.dismiss()
//                        self.responseDictionary = responseObject as! [String:Any]
//                        if let dict = self.responseDictionary["data"]
//                            as? [String:Any] {
//                            self.dataDictionary = dict
//                            print("DataDictionary \(self.dataDictionary)")
//                            if let dict = self.dataDictionary["fixture"] as? [String:Any] {
//                                self.fixtureDictionary = dict
//
//                            }
//
//                            self.teamAName.text = self.fixtureDictionary["teama"] as? String
//                            self.teamBName.text = self.fixtureDictionary["teamb"] as? String
//
//                            if let imageUrl = self.fixtureDictionary["teama_image"] as? String,
//                               !imageUrl.isEmpty, let imgURl =  URL(string:imageUrl) {
//                                self.teamAImageView.sd_setImage(with: imgURl,placeholderImage:self.defaultImage, completed: nil)
//                            }
//
//
//
//                            if let imageUrl1 = self.fixtureDictionary["teamb_image"] as? String,
//                               !imageUrl1.isEmpty, let imgURl1 =  URL(string:imageUrl1) {
//                                self.teamBImageView.sd_setImage(with: imgURl1, completed: nil)
//                            }
//                        }
////                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
////                            self.tableView.reloadData()
////                        }
//
//
//                    }
//                }
//            }
//
//        }
        
        
        
    
        
        
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.scorecard()
        self.timer =  Timer.scheduledTimer(timeInterval: 60.0,
                                           target: self,
                                           selector: #selector(DPScorecardViewController.updates),
                                           userInfo: nil,
                                           repeats: true)
        
        
    }
    
    
    func apiCardFixtures() {
        if let id = self.fixtureId {
            //self.tabBarController?.tabBar.isHidden = true
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
                            
                            self.teamAName.text = self.fixtureDictionary["teama"] as? String
                            self.teamBName.text = self.fixtureDictionary["teamb"] as? String
                            
                            if let imageUrl = self.fixtureDictionary["teama_image"] as? String,
                               !imageUrl.isEmpty, let imgURl =  URL(string:imageUrl) {
                                self.teamAImageView.sd_setImage(with: imgURl, completed: nil)
                            }
                            
                            
                            
                            if let imageUrl1 = self.contestDictionary["teamb_image"] as? String,
                               !imageUrl1.isEmpty, let imgURl1 =  URL(string:imageUrl1) {
                                self.teamBImageView.sd_setImage(with: imgURl1, completed: nil)
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                self.tableView.reloadData()
                            }
                        }
                        
                    }
                }
            }
        }
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer.invalidate()
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
    
    func reloadView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.tableView.reloadData()
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
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(DPScorecardViewController.handleTap(_:)))
        walletView.addGestureRecognizer(tap1)
        let btn = UIBarButtonItem.init(customView: walletView)
        self.navigationItem.rightBarButtonItem = btn
    }
    @objc func updates(){
        if self.matchStatus == "LIVE" || self.matchStatus == "IN REVIEW"{
            self.scorecard()
        }
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
//                                    self.walletlabel.text =  "₹" + String(amount)
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
        
    @IBAction func toggleButtonTapped(_ sender: Any) {
        present(sideMenu!, animated: true, completion: nil)
      
    }
    
    @IBAction func createButtonTapped(_ sender: Any) {
      //  if kUserDefaults.getUserTeamName() == "" {
        let Name = UserDefaults.standard.string(forKey: "Name")
         if Name == "" {
            guard let menuVC  = storyboard?.instantiateViewController(withIdentifier: "CreateUsernameVC") as? CreateUsernameVC else { return  }
            self.present(menuVC, animated: true)
        } else {
            let menuVC  = storyboard?.instantiateViewController(withIdentifier: "DPTeamSelectionVC") as? DPTeamSelectionVC
           
            self.navigationController?.pushViewController(menuVC!, animated: true)
        }
    }
    
    
    @IBAction func contestButtonTapped(_ sender: Any) {
        self.contestLabel.isHidden = false
        self.myContestLabel.isHidden = true
        self.myTeamLabel.isHidden = true
        self.scorecardLabel.isHidden = true
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menuVC  = storyboard.instantiateViewController(withIdentifier: "DPContestVC") as? DPContestVC
       // menuVC?.contestDictionary = fixtureDictionary
        menuVC?.contestDictionary =  self.contestDictionary
        self.navigationController?.pushViewController(menuVC!, animated:false)
        
    }
    @IBAction func myContestTapped(_ sender: Any) {
        self.contestLabel.isHidden = true
        self.myContestLabel.isHidden = false
        self.myTeamLabel.isHidden = true
        self.scorecardLabel.isHidden = true
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menuVC  = storyboard.instantiateViewController(withIdentifier: "DPMyContestVC") as? DPMyContestVC
        menuVC?.contestDictionary = self.contestDictionary
        self.navigationController?.pushViewController(menuVC!, animated:false)
    }
    @IBAction func myTeamButtonTapped(_ sender: Any) {
        self.contestLabel.isHidden = true
        self.myContestLabel.isHidden = true
        self.myTeamLabel.isHidden = false
        self.scorecardLabel.isHidden = true
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menuVC  = storyboard.instantiateViewController(withIdentifier: "DPCreateTeamVC") as? DPCreateTeamVC
        menuVC?.contestDictionary = self.contestDictionary
        self.navigationController?.pushViewController(menuVC!, animated:false)
    }
    
    func scorecard(){
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        else{
            SVProgressHUD.show()
            if let id = self.fixtureId  {
                let headers: HTTPHeaders = ["Content-type": "multipart/form-data","Authorization":"Bearer" + " " + token!,"X-Requested-With":"XMLHttpRequest"]
                var AFManager = Session.default
                AFManager.session.configuration.timeoutIntervalForRequest = 45
                AFManager.upload(
                    multipartFormData: { multipartFormData in
                        
                        
                    },
                    to: Constants.BaseUrl + "scorecard?fixture_id=" + id//"49416" //"scorecard?fixture_id=49236"
                    , method: .get , headers: headers)
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
                            if let myArray = self.responseDictionary["data"]
                                as? [[String:Any]] {
                                self.dataArray = myArray
                                print("DataArraysss \(self.dataArray)")
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                }
                                /* for batsman in self.dataArray {
                                 
                                 if let myArray = batsman["batsmen"] as? [[String:Any]] {
                                 self.batsmanList = myArray
                                 print("BatsmanListssss \(self.batsmanList)")
                                 }
                                 
                                 }
                                 
                                 for bowler in self.dataArray {
                                 
                                 if let myArray = bowler["bowlers"] as? [[String:Any]] {
                                 self.bowlerList = myArray
                                 print("BowlerList \(self.bowlerList)")
                                 }
                                 
                                 }
                                 
                                 for wicket in self.dataArray {
                                 
                                 if let myArray = wicket["fows"] as? [[String:Any]] {
                                 self.fallWicketList = myArray
                                 print("FallWicketList \(self.fallWicketList)")
                                 }
                                 }
                                 
                                 for extra in self.dataArray {
                                 
                                 if let mydic = extra["extras"] as? [String:Any] {
                                 self.extraList = mydic
                                 print("ExtraList \(self.extraList)")
                                 }
                                 }
                                 for extra in self.dataArray {
                                 if let myArray = extra["total"] as? [String:Any] {
                                 self.totalList = myArray
                                 print("TotalList \(self.totalList)")
                                 }
                                 }
                                 */
                            }
                            
                        }
                    }
                    DispatchQueue.main.async {
                        self.dataNotAvailableLabel.isHidden = (self.dataArray.count > 0)
                    }
                }
            }
        }
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let menuVC  = storyboard?.instantiateViewController(withIdentifier: "DPWalletVC") as? DPWalletVC
        
        
        self.navigationController?.pushViewController(menuVC!, animated:true)

    }
    @IBAction func scorecardButtonTapped(_ sender: Any) {
        self.contestLabel.isHidden = true
        self.myContestLabel.isHidden = true
        self.myTeamLabel.isHidden = true
        self.scorecardLabel.isHidden = false
        
    }
}


extension DPScorecardViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.tableView == tableView{
            return 1
        }
        else{
            return 4
        }
    }
    
    func scrollToIndex(_ index:Int){
        let indexPath = NSIndexPath(row: index, section: 0)
        tableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
    }
    
    func getTotalCellHieght(_ section: Int)->CGFloat{
        var height = 0
//        let count = batsmanList.count+(extraList.count > 0 ? 1 : 0)+(totalList.count > 0 ? 1 : 0)
        let count = getBatsmanList(section).count+(getExtra(section).count > 0 ? 1 : 0)+(getTotal(section).count > 0 ? 1 : 0)
        height = 50 * count
//        height +=  45 * bowlerList.count
        
        height +=  45 * getBowlersList(section).count
//        height +=  45 * fallWicketList.count
        height +=  45 * getFowsList(section).count
        return CGFloat(height)
        
    }
    
    func getTotalHeaderHieght(_ section: Int)->CGFloat{
        var height = 0
//        let count = batsmanList.count+(extraList.count > 0 ? 1 : 0)+(totalList.count > 0 ? 1 : 0)
        let count = getBatsmanList(section).count+(getExtra(section).count > 0 ? 1 : 0)+(getTotal(section).count > 0 ? 1 : 0)
        height = 45 * (count > 0 ? 1 : 0)
//        height +=  45 * (bowlerList.count > 0 ? 1 : 0)
        height += 35 * 1

        height +=  45 * (getBowlersList(section).count > 0 ? 1 : 0)
//        height +=  45 * (fallWicketList.count > 0 ? 1 : 0)
        height +=  45 * (getFowsList(section).count > 0 ? 1 : 0)
        return CGFloat(height)
        
    }
    
    func getBatsmanList(_ section: Int)->[[String:Any]]{
        
        let dict = self.dataArray[section]
            
            if let myArray = dict["batsmen"] as? [[String:Any]] {
//                self.batsmanList = myArray
//                print("BatsmanListssss \(self.batsmanList)")
                return myArray
            }
        return []
    }

    func getBowlersList(_ section: Int)->[[String:Any]]{
//        for bowler in self.dataArray {
        let dict = self.dataArray [section]
            if let myArray = dict["bowlers"] as? [[String:Any]] {
//                self.bowlerList = myArray
//                print("BowlerList \(self.bowlerList)")
                return myArray
            }
            
//        }
        return []
    }
    func getFowsList(_ section: Int)->[[String:Any]]{
        let dict = self.dataArray [section]
//        for wicket in self.dataArray {
            
            if let myArray = dict["fows"] as? [[String:Any]] {
//                self.fallWicketList = myArray
//                print("FallWicketList \(self.fallWicketList)")
                return myArray
            }
//        }
        return []
    }
    func getExtra(_ section: Int)->[String:Any]{
        let dict = self.dataArray [section]
//        for extra in self.dataArray {
                                                   
            if let mydic = dict["extras"] as? [String:Any] {
//                self.extraList = mydic
//                print("ExtraList \(self.extraList)")
                return mydic
            }
//        }
        return [:]
    }
    func getTotal(_ section: Int)->[String:Any]{
        let dict = self.dataArray [section]
//        for extra in self.dataArray {
            if let mydic = dict["total"] as? [String:Any] {
//                self.totalList = myArray
//                print("TotalList \(self.totalList)")
                return mydic
            }
//        }
        return [:]
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 0
        if self.tableView == tableView{
            rows = self.dataArray.count
        }
        else{
            let tag = tableView.tag
            
            switch section {
            case 0: rows = 0
            case 1:
                rows = getBatsmanList(tag).count+(getExtra(tag).count > 0 ? 1 : 0)+(getTotal(tag).count > 0 ? 1 : 0)
//                rows = batsmanList.count+(extraList.count > 0 ? 1 : 0)+(totalList.count > 0 ? 1 : 0)
            case 2:
                rows = getBowlersList(tag).count
//                rows = bowlerList.count
            case 3:
                rows = getFowsList(tag).count
//                rows = fallWicketList.count
            default:
                return 0
            }
        }
        
        return rows//1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = 0
        if self.tableView == tableView{
//            height = getTotalCellHieght() + getTotalHeaderHieght()
//            if explandCellIndex < 0{
//                height = 45
//            }
//            else{
            //    height = explandCellIndex == indexPath.row ? (getTotalCellHieght(indexPath.row) + getTotalHeaderHieght(indexPath.row)) : 45//700
//            }
            
            if explandCellIndex == indexPath.row {
                height = (getTotalCellHieght(indexPath.row) + getTotalHeaderHieght(indexPath.row))
            } else {
                height = 45
            }
        }
        else{
            switch indexPath.section {
            case 0:height = 0
            case 1:height = 50
            case 2:height = 45
            case 3:height = 45
            default:
                break
            }
        }
        return height//1000
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.tableView == tableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
            //cell.backgroundColor = .red
            return cell
        }
        else {
            let tag = tableView.tag
            if indexPath.section == 1 {
//                if  indexPath.row <= (self.batsmanList.count > 0 ? (self.batsmanList.count - 1) : 0) {
                if  indexPath.row <= (getBatsmanList(tag).count > 0 ? (getBatsmanList(tag).count - 1) : 0) {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? DPScoreCardCell
//                    let cell = tableView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? DPScoreCardCell
                    let batsmanList = getBatsmanList(tag)
//                    let dictionary = self.batsmanList[indexPath.row]
                    if batsmanList.count > indexPath.row {
                        let dictionary = batsmanList[indexPath.row]
                        print("BatsmanLisDict \(dictionary)")
                        cell?.batsmanName.text = "\(dictionary["name"] ?? "")"
                        cell?.batsmanRun.text = "\(dictionary["runs"] ?? "")"
                        cell?.batsmanBallFaced.text = "\(dictionary["balls_faced"] ?? "")"
                        cell?.batsman4Run.text = "\(dictionary["fours"] ?? "")"
                        cell?.batsman6Run.text = "\(dictionary["sixes"] ?? "")"
                        cell?.batsmanSR.text = "\(dictionary["strike_rate"] ?? "")"
                        cell?.batsmanOutStatus.text = "\(dictionary["how_out"] ?? "")"
                        if cell?.batsmanOutStatus.text == "Not out" {
                            cell?.batsmanOutStatus.textColor = UIColor.red
                        }
                        else{
                            cell?.batsmanOutStatus.textColor = UIColor.black
                        }
                        return cell!
                    }
                }
                else {
//                    let index = indexPath.row - (self.batsmanList.count > 0 ? (self.batsmanList.count - 1) : 0)
                    let index = indexPath.row - (getBatsmanList(tag).count > 0 ? (getBatsmanList(tag).count - 1) : 0)
                    if index == 1 {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "DPExtraCell", for: indexPath) as? DPExtraCell
//                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DPExtraCell", for: indexPath) as? DPExtraCell
                        let dictionary = getExtra(tag)//self.extraList
                        print("ExtraLisDict \(dictionary)")
                        cell?.lblTitle.text = "\(dictionary["label"] ?? "")"
                        cell?.totalExtra.text = "\(dictionary["value"] ?? "")"// String(value)
                        cell?.note.text = "\(dictionary["notes"] ?? "")"
                        return cell!
                    }
                    else if index == 2 {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "DPTotalCell", for: indexPath) as? DPTotalCell
//                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DPTotalCell", for: indexPath) as? DPTotalCell
                        let dictionary = getTotal(tag)//self.totalList
                        print("TotalLisDict \(dictionary)")
                        cell?.lblTitle.text = "\(dictionary["label"] ?? "")"
                        cell?.totalRun.text = "\(dictionary["value"] ?? "")"
                        cell?.overWicketLabel.text = "\(dictionary["notes"] ?? "")"
                        return cell!
                    }
                }

        }
            else if indexPath.section == 2 {
                let cell1 = tableView.dequeueReusableCell(withIdentifier: "DPBowlerCardCell", for: indexPath) as? DPBowlerCardCell
//            let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "DPBowlerCardCell", for: indexPath) as? DPBowlerCardCell
                let bowlerList = getBowlersList(tag)
//                let dictionary = self.bowlerList[indexPath.row]
                let dictionary = bowlerList[indexPath.row]
                print("BowlerLisDict \(dictionary)")

               
                cell1?.bowlerName.text = "\(dictionary["name"] ?? "")"
                cell1?.run.text = "\(dictionary["runs"] ?? "")"
                cell1?.overSpell.text = "\(dictionary["overs"] ?? "")"
                cell1?.maidenOverSpell.text = "\(dictionary["maidens"] ?? "")"
                cell1?.WicketTaken.text = "\(dictionary["wickets"] ?? "")"
                cell1?.economy.text = "\(dictionary["econ"] ?? "")"
                

                return cell1!
                
            }
            else if indexPath.section == 3 {
                let cell2 = tableView.dequeueReusableCell(withIdentifier: "DPFallWicketCell", for: indexPath) as? DPFallWicketCell
                let fallWicketList = getFowsList(tag)
//                let dictionary = self.fallWicketList[indexPath.row]
                let dictionary = fallWicketList[indexPath.row]
                print("WicketLisDict \(dictionary)")
                cell2?.batmanName.text = "\(dictionary["name"] ?? "")"
                cell2?.over.text = "\(dictionary["overs"] ?? "")"
                cell2?.score.text = "\(dictionary["score"] ?? "")"
                return cell2!
                
            }
        }
        
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        guard let tableViewCell = cell as? TableViewCell else { return }
        
        if self.tableView == tableView{

            tableViewCell.setTableViewDataSourceDelegate(self, forRow: indexPath.row)
//            tableViewCell.tableViewOffset = storedOffsets[indexPath.section] ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        explandCellIndex = explandCellIndex == indexPath.row ? -1 : indexPath.row
        
        self.tableView.reloadData()
        scrollToIndex(indexPath.row)
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {

//        guard let tableViewCell = cell as? TableViewCell else { return }
//        if self.tableView == tableView{
////            storedOffsets[indexPath.section] = tableViewCell.tableViewOffset
//        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.tableView == tableView{
         return nil
        }
        else{
            let tag = tableView.tag
            
//            if explandCellIndex == tag {
//
//            }
            let isExpand: Bool = explandCellIndex == tag  //explandCellIndex >= 0
            switch section {
            case 0:
                let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 45))
                let cell = tableView.dequeueReusableCell(withIdentifier: "DPMatchHeaderCell") as? DPMatchHeaderCell
                cell?.frame = header.frame
               // header.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 45)
                header.addSubview(cell!)
                cell?.constraintsBotttomMargin.constant = isExpand ? -5 : 0
                cell?.constraintCenterY.constant = isExpand ? -5 : 0
                cell?.constraintsBotttomMarginSeparatorLine.constant = isExpand ? -5 : 0
                
                let dictionary = dataArray[tag]
                print("MatchDict \(dictionary)")
                cell?.lblTitle.text = "\(dictionary["name"] ?? "")"
                cell?.over.text = "(\(dictionary["overs"] ?? ""))"
                cell?.score.text = "\(dictionary["scores"] ?? "")"
                
                return header
            case 1:
                
                let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 35))
                let cell = tableView.dequeueReusableCell(withIdentifier: "DPBatsmanHeaderCell") as? DPBatsmanHeaderCell
                
                cell?.frame = header.frame
                header.addSubview(cell!)
//                cell?.constraintsBotttomMargin.constant = isExpand ? -5 : 0
//                cell?.constraintCenterY.constant = isExpand ? -5 : 0
//                cell?.constraintsBotttomMarginSeparatorLine.constant = isExpand ? 5 : 0
                return header
            case 2:
                
                let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 45))
                let cell = tableView.dequeueReusableCell(withIdentifier: "DPBowlerHeaderCell") as? DPBowlerHeaderCell
                cell?.frame = header.frame
                header.addSubview(cell!)
                cell?.constraintsBotttomMargin.constant = isExpand ? -5 : 0
                cell?.constraintCenterY.constant = isExpand ? -5 : 0
                cell?.constraintsBotttomMarginSeparatorLine.constant = isExpand ? 5 : 0
                return header
            case 3:
                
                let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 45))
                let cell = tableView.dequeueReusableCell(withIdentifier: "DPFallWicketHeaderCell") as? DPFallWicketHeaderCell
                cell?.frame = header.frame
                header.addSubview(cell!)
                cell?.constraintsBotttomMargin.constant = isExpand ? -5 : 0
                cell?.constraintCenterY.constant = isExpand ? -5 : 0
                cell?.constraintsBotttomMarginSeparatorLine.constant = isExpand ? 5 : 0
                return header
            default:
                return nil
                
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.tableView == tableView{
            return 0
        }
        else{
            let tag = tableView.tag
            switch section {
            case 0:
//                let count = batsmanList.count+(extraList.count > 0 ? 1 : 0)+(totalList.count > 0 ? 1 : 0)
                let count = getBatsmanList(tag).count+(getExtra(tag).count > 0 ? 1 : 0)+(getTotal(tag).count > 0 ? 1 : 0)
                return count > 0 ? 45 : 0
//            case 1:return bowlerList.count > 0 ? 45 : 0
            case 1: return 35
            case 2:return getBowlersList(tag).count > 0 ? 45 : 0
//            case 2:return fallWicketList.count > 0 ? 45 : 0
            case 3:return getFowsList(tag).count > 0 ? 45 : 0
            default: return 0
            }
        }
    }
}
/*
extension DPScorecardViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return batsmanList.count+(extraList.count > 0 ? 1 : 0)+(totalList.count > 0 ? 1 : 0)
        case 1:
            return bowlerList.count
        case 2:
            return fallWicketList.count
        default:
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            if  indexPath.row <= (self.batsmanList.count > 0 ? (self.batsmanList.count - 1) : 0) {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? DPScoreCardCell
                let dictionary = self.batsmanList[indexPath.row]
                print("BatsmanLisDict \(dictionary)")

               
                cell?.batsmanName.text = dictionary["name"] as? String
                cell?.batsmanRun.text = dictionary["runs"] as? String
                cell?.batsmanBallFaced.text = dictionary["balls_faced"] as? String
                cell?.batsman4Run.text = dictionary["fours"] as? String
                cell?.batsman6Run.text = dictionary["sixes"] as? String
                cell?.batsmanSR.text = dictionary["strike_rate"] as? String
                cell?.batsmanOutStatus.text = dictionary["how_out"] as? String
            
                return cell!
            }
            else {
                let index = indexPath.row - (self.batsmanList.count > 0 ? (self.batsmanList.count - 1) : 0)
                if index == 1 {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DPExtraCell", for: indexPath) as? DPExtraCell
                        let dictionary = self.extraList
                        print("ExtraLisDict \(dictionary)")
                    if let value = dictionary["value"] as? Int {
                    cell?.totalExtra.text = String(value)
                    }
                    cell?.note.text = dictionary["notes"] as? String
          
                    return cell!

                }
                else if index == 2{
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DPTotalCell", for: indexPath) as? DPTotalCell
                        let dictionary = self.totalList
                            print("ExtraLisDict \(dictionary)")
//                        if let value = dictionary["value"] as? Int {
//                        cell?.totalRun.text = String(value)
//                        }
//                        cell?.overWicketLabel.text = dictionary["notes"] as? String
              
                        return cell!
                }
            }

    }
        else if indexPath.section == 1 {
        let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "DPBowlerCardCell", for: indexPath) as? DPBowlerCardCell
            
            let dictionary = self.bowlerList[indexPath.row]
            print("BowlerLisDict \(dictionary)")

           
            cell1?.bowlerName.text = dictionary["name"] as? String
            cell1?.run.text = dictionary["runs"] as? String
            cell1?.overSpell.text = dictionary["overs"] as? String
            cell1?.maidenOverSpell.text = dictionary["maidens"] as? String
            cell1?.WicketTaken.text = dictionary["wickets"] as? String
            cell1?.economy.text = dictionary["econ"] as? String
            

            return cell1!
            
        }
        else if indexPath.section == 2 {
        let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "DPFallWicketCell", for: indexPath) as? DPFallWicketCell
            
            let dictionary = self.fallWicketList[indexPath.row]
            print("WicketLisDict \(dictionary)")

           
            cell2?.batmanName.text = dictionary["name"] as? String
            cell2?.over.text = dictionary["overs"] as? String
            cell2?.score.text = dictionary["score"] as? String
           
            

            return cell2!
            
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if indexPath.section == 0 {

        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "DPBatsmanHeaderCell", for: indexPath) as? DPBatsmanHeaderCell{
           // sectionHeader.sectionHeaderlabel.text = "Section \(indexPath.section)"
            return sectionHeader
        }
        }
        else if indexPath.section == 1 {
            if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "DPBowlerHeaderCell", for: indexPath) as? DPBowlerHeaderCell{
               // sectionHeader.sectionHeaderlabel.text = "Section \(indexPath.section)"
                return sectionHeader
            }
        }
        else if indexPath.section == 2 {
            if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "DPFallWicketHeaderCell", for: indexPath) as? DPFallWicketHeaderCell{
               // sectionHeader.sectionHeaderlabel.text = "Section \(indexPath.section)"
                return sectionHeader
            }
        }
        return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40.0)
        }
    
}
*/
class DPScoreCardCell: UITableViewCell/*UICollectionViewCell*/ {
    @IBOutlet weak var batsmanName:UILabel!
    @IBOutlet weak var batsmanBallFaced:UILabel!
    @IBOutlet weak var batsmanOutStatus:UILabel!
    @IBOutlet weak var batsmanRun:UILabel!
    @IBOutlet weak var batsmanSR:UILabel!
    @IBOutlet weak var batsman4Run:UILabel!
    @IBOutlet weak var batsman6Run:UILabel!
    
    

    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

class DPBowlerCardCell: UITableViewCell {
    @IBOutlet weak var bowlerName:UILabel!
    @IBOutlet weak var overSpell:UILabel!
    @IBOutlet weak var maidenOverSpell:UILabel!
    @IBOutlet weak var WicketTaken:UILabel!
    @IBOutlet weak var run:UILabel!
    @IBOutlet weak var economy:UILabel!
    
    
    

    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

class DPFallWicketCell: UITableViewCell {
    @IBOutlet weak var batmanName:UILabel!
    @IBOutlet weak var score:UILabel!
    @IBOutlet weak var over:UILabel!
    
    
override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

class DPExtraCell: UITableViewCell {
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var totalExtra:UILabel!
    @IBOutlet weak var note:UILabel!
   
    
    
    
    
override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

class DPTotalCell: UITableViewCell {
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var totalRun:UILabel!
    @IBOutlet weak var overWicketLabel:UILabel!
    
override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

class DPBatsmanHeaderCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle:UILabel!
    
    @IBOutlet weak var viContainerBG:UIView!
    @IBOutlet weak var constraintsBotttomMargin: NSLayoutConstraint!
    @IBOutlet weak var constraintCenterY: NSLayoutConstraint!
    @IBOutlet weak var constraintsBotttomMarginSeparatorLine: NSLayoutConstraint!
    override func layoutSubviews() {
        super.layoutSubviews()
//        clipsToBounds = true
//        viContainerBG.clipsToBounds = true
//        viContainerBG.cornerRadius = 8.0
    }
}

class DPBowlerHeaderCell: UITableViewCell {
    @IBOutlet weak var viContainerBG:UIView!
    @IBOutlet weak var constraintsBotttomMargin: NSLayoutConstraint!
    @IBOutlet weak var constraintCenterY: NSLayoutConstraint!
    @IBOutlet weak var constraintsBotttomMarginSeparatorLine: NSLayoutConstraint!

    override func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = true
        viContainerBG.clipsToBounds = true
        viContainerBG.cornerRadius = 8.0
//        viContainerBG.roundCorners(corners: [.topLeft, .topRight], radius: 8.0)
    }
    
}

class DPFallWicketHeaderCell: UITableViewCell/*UICollectionReusableView*/ {
    @IBOutlet weak var viContainerBG:UIView!
    @IBOutlet weak var constraintsBotttomMargin: NSLayoutConstraint!
    @IBOutlet weak var constraintCenterY: NSLayoutConstraint!
    @IBOutlet weak var constraintsBotttomMarginSeparatorLine: NSLayoutConstraint!

    override func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = true
        viContainerBG.clipsToBounds = true
        viContainerBG.cornerRadius = 8.0
//        viContainerBG.roundCorners(corners: [.topLeft, .topRight], radius: 8.0)
    }
    
}


class DPMatchHeaderCell: UITableViewCell/*UICollectionReusableView*/ {
    
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var score:UILabel!
    @IBOutlet weak var over:UILabel!
    
    @IBOutlet weak var viContainerBG:UIView!
    @IBOutlet weak var constraintsBotttomMargin: NSLayoutConstraint!
    @IBOutlet weak var constraintCenterY: NSLayoutConstraint!
    @IBOutlet weak var constraintsBotttomMarginSeparatorLine: NSLayoutConstraint!

    override func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = true
        viContainerBG.clipsToBounds = true
        viContainerBG.cornerRadius = 8.0
//        viContainerBG.roundCorners(corners: [.topLeft, .topRight], radius: 8.0)
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




