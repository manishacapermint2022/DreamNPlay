//
//  DPCreateTeamVC.swift
//  DreamPlay
//
//  Created by MAC on 21/06/21.
//

import UIKit
import Alamofire
import SVProgressHUD
import SDWebImage
import SideMenu



public extension UITableView {
  
    func indexPathForView(_ view: UIView) -> IndexPath? {
        let center = view.center
        let viewCenter = self.convert(center, from: view.superview)
        let indexPath = self.indexPathForRow(at: viewCenter)
        return indexPath
    }
}
 

protocol createPassData{
    func passingCreateData(name:String)
}
class DPCreateTeamVC: UIViewController,UIGestureRecognizerDelegate {
    @IBOutlet weak var scorecardLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var contestLabel: UILabel!
    @IBOutlet weak var myTeamLabel: UILabel!
    @IBOutlet weak var amountLabel:UILabel!
    @IBOutlet weak var myContestLabel: UILabel!
    @IBOutlet weak var dataNotAvailableLabel: UILabel!
    var isOpen = false
    var screenCheck = false
    @IBOutlet weak var createTeamButton: UIButton!
    @IBOutlet weak var teamBImageView: UIImageView!
    @IBOutlet weak var topView: UIView!
    var token:String?
    @IBOutlet weak var teamBName: UILabel!
    var responseDictionary:[String:Any] = [:]
    var dataDictionary:[String:Any] = [:]
    var paymentArray:[[String:Any]] = []
    var userDictionary:[String:Any] = [:]
    //let fixtureId: Any? = UserDefaults.standard.object(forKey:"FixtureId") as Any?
    let flag: Any? = UserDefaults.standard.object(forKey:"Flag") as Any?
    //    var fixtureid:String?
    var fixtureDictionary:[String:Any] = [:]
    var delegate:createPassData?
    var sideMenu:SideMenuNavigationController?
    var message:String?
    var duplicateArray:[[String:Any]] = []
    
    var playerList:[[String:Any]] = []
    var fixtureArray:[[String:Any]] = []
    @IBOutlet weak var teamALabel: UILabel!
    var createGameArray:[[String:Any]] = []
    var userTeam:[[String:Any]] = []
    var playerArray:[[String:Any]] = []
    var createDictionary:[String:Any] = [:]
    var flags:Int?
    var contestDictionary:[String:Any] = [:]
    var fixtureId:String?
    var walletView : UIView!
    var walletlabel : UILabel!
    var viceCaptainId:Int?
    var captainId:Int?
    var playerIds:Int?
    var playerArrayIds:[Int] = []
    var defaultImage:UIImage?
    @IBOutlet weak var teamAImageView: UIImageView!
    var matchStatus:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenu()
        self.setupWalletView()
        self.dataNotAvailableLabel.isHidden = true
        //self.contestDictionary = UserDefaults.standard.object(forKey:"ContestDictionary") as? [String:Any] ?? [:]
        
        print("ContestDictionary", contestDictionary)
        self.matchStatus = contestDictionary["status"] as? String
        
        if self.matchStatus == "LIVE" || self.matchStatus == "COMPLETED" || self.matchStatus == "IN REVIEW" {
            self.createTeamButton.isHidden = true
        }
        if let id = self.contestDictionary["id"] as? Int {
            self.fixtureId = String(id)
        }
        
        self.tableView.rowHeight = 254.0
        topView.layer.cornerRadius = 8
        topView.layer.borderWidth = 1
        topView.layer.borderColor = UIColor.clear.cgColor
        createTeamButton.layer.cornerRadius = 8
        createTeamButton.layer.borderWidth = 1
        createTeamButton.layer.borderColor = UIColor.clear.cgColor
        let logo = UIImage(named:"layer3")
        let imageView = UIImageView(image:logo)
        imageView.frame = CGRect(x: 150, y: 20, width: 100.0, height: 30.0)
        self.navigationItem.titleView = imageView
        
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "Background"))
        token = UserDefaults.standard.string(forKey:"AccessToken")!
        print("Token :", token as Any)
        print("CreateFixtureId",self.fixtureId)
        // self.delegate?.passingCreateData(name: fixtureId as! String)
        
        self.contestLabel.isHidden = true
        self.myContestLabel.isHidden = true
        self.myTeamLabel.isHidden = false
        self.scorecardLabel.isHidden = true
        self.teamALabel.text = self.contestDictionary["teama"] as? String
        self.teamBName.text = self.contestDictionary["teamb"] as? String
        
        if let imageUrl = self.contestDictionary["teama_image"] as? String,
           !imageUrl.isEmpty, let imgURl =  URL(string:imageUrl) {
            self.teamAImageView.sd_setImage(with: imgURl, completed: nil)
        }
        
        if let imageUrl1 = self.contestDictionary["teamb_image"] as? String,
           !imageUrl1.isEmpty, let imgURl1 =  URL(string:imageUrl1) {
            self.teamBImageView.sd_setImage(with: imgURl1, completed: nil)
        }
        
        
        
        //self.teamALabel.text = self.createDictionary["teama"] as? String
        // self.teamBName.text = self.createDictionary["teamb"] as? String
        token = UserDefaults.standard.string(forKey:"AccessToken")!
        self.downloadImage(from: URL(string:"https://cricket.entitysport.com/assets/uploads/2021/05/team-120x120.png")!)
        
        
        /*let pref:UserDefaults = UserDefaults.standard
         pref.set(self.fixtureid, forKey:"FixtureId")
         pref.synchronize()
         */
        
        
        if let fl = self.flag as? Int {
            self.flags = fl
            
        }
        
        
    }
    
    func myTeamApiCall() {
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            if let ID = self.fixtureId, !ID.isEmpty {
                let headers: HTTPHeaders = ["Content-type": "multipart/form-data","Authorization":"Bearer" + " " + token!,"X-Requested-With":"XMLHttpRequest"]
                AF.upload(
                    multipartFormData: { multipartFormData in
                        
                        
                    },
                    to: Constants.BaseUrl + "user_teams?fixture_id=\(ID)&contest_id=1", method: .get , headers: headers)
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
                            print("responseObjectFixturessss \(responseObject)")
                            SVProgressHUD.dismiss()
                            self.responseDictionary = responseObject as! [String:Any]
                            if let dict = self.responseDictionary["data"]
                                as? [String:Any] {
                                self.dataDictionary = dict
                                print("DataDictionary \(self.dataDictionary)")
                                if let myArray = self.dataDictionary["user_teams"] as? [[String:Any]] {
                                    self.fixtureArray = myArray
                                    print("FixtureArray \(self.fixtureArray)")
                                    
                                }
                                if self.fixtureArray.count == 0 {
                                self.dataNotAvailableLabel.isHidden = false
                                }
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
            self.walletAmount()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.myTeamApiCall()
        }
        //self.tabBarController?.tabBar.isHidden = true
        
        
        
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
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(DPCreateTeamVC.handleTap(_:)))
        
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
    
    
    
    @IBAction func scorecardButtonTapped(_ sender: Any) {
        self.contestLabel.isHidden = true
        self.myContestLabel.isHidden = true
        self.myTeamLabel.isHidden = true
        self.scorecardLabel.isHidden = false
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menuVC  = storyboard.instantiateViewController(withIdentifier: "DPScorecardViewController") as? DPScorecardViewController
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
    
    @IBAction func myContestButtonTapped(_ sender: Any) {
        self.contestLabel.isHidden = true
        self.myContestLabel.isHidden = false
        self.myTeamLabel.isHidden = true
        self.scorecardLabel.isHidden = true
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menuVC  = storyboard.instantiateViewController(withIdentifier: "DPMyContestVC") as? DPMyContestVC
        menuVC?.contestDictionary = self.contestDictionary
        
        self.navigationController?.pushViewController(menuVC!, animated: false)
    }
    @IBAction func contestButtonTapped(_ sender: Any) {
        self.contestLabel.isHidden = false
        self.myContestLabel.isHidden = true
        self.myTeamLabel.isHidden = true
        self.scorecardLabel.isHidden = true
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menuVC  = storyboard.instantiateViewController(withIdentifier: "DPContestVC") as? DPContestVC
        menuVC?.contestDictionary = contestDictionary//fixtureDictionary
        
        
        self.navigationController?.pushViewController(menuVC!, animated: false)
    }
    
    @objc func previewButtonTapped(_ sender:UIButton){
        let row = sender.tag
        let dictionary = self.fixtureArray[row]
        print("PickDictionary \(String(describing:dictionary))")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menuVC  = storyboard.instantiateViewController(withIdentifier: "DPPickTeamViewController") as? DPPickTeamViewController
        menuVC?.pickTeamDictionary = dictionary
        menuVC?.topViewDictionary = self.createDictionary
        
        self.navigationController?.pushViewController(menuVC!, animated: true)
        
    }
    
    
    @objc func editButtonTapped(_ sender:UIButton){
        let row = sender.tag
        
        let dictionary = self.fixtureArray[row]
        print ("Edit")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menuVC  = storyboard.instantiateViewController(withIdentifier: "DPTeamSelectionVC") as? DPTeamSelectionVC
        menuVC?.editDictionary = dictionary
        print("EditDictionary \(String(describing:menuVC?.editDictionary))")
        
        
        
        
        self.navigationController?.pushViewController(menuVC!, animated: true)
        /* if let playerId = dictionary["player_id"] as? Int{
         viceCaptainId = "\(playerId)"
         
         }
         */
        self.tableView.reloadData()
    }
    @objc func duplicateButtonTapped(_ sender:UIButton){
        let row = sender.tag
        
        let dictionary = self.fixtureArray[row]
        print("DuplicateDictionary\(dictionary)")
        print ("Duplicate")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menuVC  = storyboard.instantiateViewController(withIdentifier: "DPTeamSelectionVC") as? DPTeamSelectionVC
        menuVC?.editDictionary = dictionary
        print("EditDictionary \(String(describing:menuVC?.editDictionary))")
        self.navigationController?.pushViewController(menuVC!, animated: true)
        
        
        /*if let playerId = dictionary["player_id"] as? Int{
         viceCaptainId = "\(playerId)"
         
         }
         */
        self.tableView.reloadData()
        
        /* if let myArray = dictionary["players"] as? [[String:Any]] {
         self.duplicateArray = myArray
         print("DuplicateArray\(duplicateArray)")
         }
         for playerId in self.duplicateArray {
         
         if let playerIds = playerId["player_id"] as? Int {
         self.playerArrayIds.append(playerIds)
         }
         }
         self.viceCaptainId = dictionary["vice_captain_id"] as? Int
         self.captainId = dictionary["captain_id"] as? Int
         if isInternetAvailable() == false{
         let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
         alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
         self.present(alert, animated: true, completion: nil)
         }
         else{
         
         if let apiString = URL(string:Constants.BaseUrl + "user_teams") {
         var request = URLRequest(url:apiString)
         request.httpMethod = "POST"
         request.setValue("application/json",
         forHTTPHeaderField: "Content-Type")
         request.setValue("Bearer" + " " + token!, forHTTPHeaderField: "Authorization")
         
         let values = ["fixture_id":self.fixtureId as Any,
         "players":self.playerArrayIds,
         "captain_id":self.captainId as Any,
         "vice_captain_id":self.viceCaptainId as Any] as [String:Any]//self.viceCaptainId as Any] as [String : Any]
         print("Values \(values)")
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
         print("TeamResponse \(responseString)")
         }
         case .success(let responseObject):
         DispatchQueue.main.async {
         
         print("This is run on the main queue, after the previous code in outer block")
         }
         print("TeamCreateResponse \(responseObject)")
         
         SVProgressHUD.dismiss()
         self.responseDictionary = responseObject as! [String:Any]
         self.message = self.responseDictionary["message"] as? String
         let alertController = UIAlertController(title: "Alert", message:self.message, preferredStyle: .alert)
         let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
         let menuVC  = storyboard.instantiateViewController(withIdentifier: "DPTeamSelectionVC") as? DPTeamSelectionVC
         
         self.navigationController?.pushViewController(menuVC!, animated: true)
         
         }
         alertController.addAction(okAction)
         self.present(alertController, animated: true, completion:nil)
         
         /*     if let dict = responseObject as? [String:Any] {
          self.message = dict["msg"] as? String
          
          let alertController = UIAlertController(title: "Alert", message:self.message, preferredStyle: .alert)
          let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
          print("you have pressed the Ok button");
          }
          alertController.addAction(okAction)
          self.present(alertController, animated: true, completion:nil)
          }
          */
         }
         }
         
         
         
         
         }
         }
         */
        
        
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
    
    @IBAction func createButtonTapped(_ sender: Any) {
        
        let Name = UserDefaults.standard.string(forKey: "Name")
         if Name == "" {
       // if kUserDefaults.getUserTeamName() == "" {
            guard let menuVC  = storyboard?.instantiateViewController(withIdentifier: "CreateUsernameVC") as? CreateUsernameVC else { return  }
            self.present(menuVC, animated: true)
        } else {
            let menuVC  = storyboard?.instantiateViewController(withIdentifier: "DPTeamSelectionVC") as? DPTeamSelectionVC
           
            self.navigationController?.pushViewController(menuVC!, animated: true)
        }
    }
    @IBAction func toggleButtonTapped(_ sender: Any) {
        present(sideMenu!, animated: true, completion: nil)
        
    }
    
}


extension DPCreateTeamVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fixtureArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "DPCreateTeamCell", for: indexPath) as! DPCreateTeamCell
        let dictionary = self.fixtureArray[indexPath.row]
        print("CreatedGameDictionary \(dictionary)")
        if let wicketKeeper = dictionary["wicket_keeper"] as? Int {
            cell.wicketKeeperCount.text = String(wicketKeeper)
        }
        if let batsman = dictionary["batsmen"] as? Int {
            cell.batsmanCount.text = String(batsman)
        }
        if let alrounder = dictionary["all_rounders"] as? Int {
            cell.alrounderBCount.text = String(alrounder)
        }
        if let bowler = dictionary["bowlers"] as? Int {
            cell.bowlerCount.text = String(bowler)
        }
        if let teamaDictionary = dictionary["teama"] as? [String:Any] {
            if let count = teamaDictionary["count"] as? Int {
                cell.teamACount.text = String(count)
            }
        }
        if let teambDictionary = dictionary["teamb"] as? [String:Any] {
            if let count = teambDictionary["count"] as? Int {
                cell.teamBCount.text = String(count)
            }
        }
        if let teamaDictionary = dictionary["teama"] as? [String:Any] {
            if let imageUrl = teamaDictionary["image"] as? String,
               !imageUrl.isEmpty, let imgURl =  URL(string:imageUrl) {
                self.teamAImageView.sd_setImage(with: imgURl,placeholderImage:self.defaultImage, completed: nil)
            }
        }
        if let teambDictionary = dictionary["teamb"] as? [String:Any] {
            if let imageUrl1 = teambDictionary["teamb_image"] as? String,
               !imageUrl1.isEmpty, let imgURl1 =  URL(string:imageUrl1) {
                self.teamBImageView.sd_setImage(with: imgURl1,placeholderImage:self.defaultImage, completed: nil)
            }
        }
        if let captainDictionary = dictionary["captain"] as? [String:Any] {
            print("CaptainDictionary \(String(describing: captainDictionary))")
            cell.captainName.text = captainDictionary["name"] as? String
            
        }
       
        if  let viceCaptainDictionary = dictionary["vice_captain"] as? [String:Any]{
            print("ViceCaptainDictionary \(String(describing: viceCaptainDictionary))")
            
            cell.viceCaptainName.text = viceCaptainDictionary["name"] as? String
            
        }
        if let teamName = dictionary["name"] as? String {
            cell.labelTeamNumber.text = teamName
        }
        
        
        if self.matchStatus == "LIVE" || self.matchStatus == "COMPLETED" {
            cell.duplicateButton.isHidden = true
            cell.editButton.isHidden = true
        } else {
            cell.duplicateButton.isHidden = false
            cell.editButton.isHidden = false
        }
        
        cell.borderView.layer.cornerRadius = 8
        cell.borderView.layer.borderWidth = 1
        cell.borderView.layer.borderColor = UIColor.clear.cgColor
        
        if let firstCountryFlag = cell.viewWithTag(60) as? UIImageView {
            if let imageUrl1 = self.contestDictionary["teama_image"] as? String,
               !imageUrl1.isEmpty, let imgURl1 =  URL(string:imageUrl1) {
                firstCountryFlag.sd_setImage(with: imgURl1,placeholderImage: self.defaultImage, completed: nil)
            }
        }
        /*if let gameStatus = cell.viewWithTag(80) as? UILabel {
         gameStatus.text = dictionary["status"] as? String
         }
         if let gameType = cell.viewWithTag(90) as? UILabel {
         gameType.text = dictionary["type"] as? String
         }
         */
        
        if let secondCountryFlag = cell.viewWithTag(80) as? UIImageView {
            
            if let imageUrl1 = self.contestDictionary["teamb_image"] as? String,
               !imageUrl1.isEmpty, let imgURl1 =  URL(string:imageUrl1) {
                secondCountryFlag.sd_setImage(with: imgURl1,placeholderImage: self.defaultImage, completed: nil)
            }
        }
       
        /*  if let preview = cell.viewWithTag(140)  {
         
         let tap = UITapGestureRecognizer(target: self, action: #selector(DPTeamSelectionVC.handleTap(_:)))
         
         preview.addGestureRecognizer(tap)
         let indexPath = self.tableView.indexPathForView(preview)
         print("IndexPathssssss \(String(describing: indexPath))")
         }
         */
        
        cell.previewButton.tag = indexPath.row
        cell.previewButton.addTarget(self, action: #selector(previewButtonTapped(_:)), for: .touchUpInside)
        cell.editButton.tag = indexPath.row
        cell.editButton.addTarget(self, action: #selector(editButtonTapped(_:)), for: .touchUpInside)
        cell.duplicateButton.tag = indexPath.row
        cell.duplicateButton.addTarget(self, action: #selector(duplicateButtonTapped(_:)), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
class DPCreateTeamCell: UITableViewCell {
    static let ID = "DPCreateTeamCell"
    @IBOutlet weak var captainName: UILabel!
    @IBOutlet weak var labelTeamNumber: UILabel!
    @IBOutlet weak var viceCaptainName:UILabel!
    @IBOutlet weak var teamACount:UILabel!
    @IBOutlet weak var teamBCount:UILabel!
    @IBOutlet weak var wicketKeeperCount: UILabel!
    @IBOutlet weak var batsmanCount:UILabel!
    @IBOutlet weak var bowlerCount:UILabel!
    @IBOutlet weak var alrounderBCount:UILabel!
    @IBOutlet weak var previewButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var duplicateButton: UIButton!
    @IBOutlet weak var teamAImageView: UIImageView!
    @IBOutlet weak var teamBImageView: UIImageView!
    @IBOutlet weak var borderView:UIView!
    
    
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
    

    


