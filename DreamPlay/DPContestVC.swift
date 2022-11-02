//
//  DPContestVC.swift
//  DreamPlay
//
//  Created by MAC on 18/06/21.
//

import UIKit
import Alamofire
import SVProgressHUD
import SideMenu
import SDWebImage
import KSToastView
 
public extension UITableView {
  
    func indexPathForViews(_ view: UIView) -> IndexPath? {
        let center = view.center
        let viewCenter = self.convert(center, from: view.superview)
        let indexPath = self.indexPathForRow(at: viewCenter)
        return indexPath
    }
}


class DPContestVC: UIViewController,passData,createPassData {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var contestLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var dataNotAvailableLabel: UILabel!
    @IBOutlet weak var myContestLabel: UILabel!
    @IBOutlet weak var myTeamLabel: UILabel!
    @IBOutlet weak var contestButton: UIButton!
    @IBOutlet weak var scorecardLabel: UILabel!
    @IBOutlet weak var createTeamButton: UIButton!
    @IBOutlet weak var myContestButton: UIButton!
    @IBOutlet weak var scoreboardButton: UIButton!
    @IBOutlet weak var myTeamButton: UIButton!
    @IBOutlet weak var teamAImageView: UIImageView!
    @IBOutlet weak var teamAName: UILabel!
    @IBOutlet weak var teamBImageView: UIImageView!
    @IBOutlet weak var lblWallet: UILabel!
    @IBOutlet weak var viewHeader: UIView!
    var tagController = ""
    var sideMenu:SideMenuNavigationController?
    var defaultImage:UIImage?
    var flag:Int?

    let accessToken: Any? = UserDefaults.standard.object(forKey:"AccessToken") as Any?
    //let fixtureIdss: Any? = UserDefaults.standard.object(forKey:"FixtureId") as Any?
    var responseDictionary:[String:Any] = [:]
    var dataDictionary:[String:Any] = [:]
    var contestArray:[[String:Any]] = []
    var contestDictionary:[String:Any] = [:]
    var transferDictionary:[String:Any] = [:]
    var fixtureId:Int?
    var fixtureid:String?
    var userTeam:[[String:Any]] = []
    @IBOutlet weak var teamBName: UILabel!
    var isOpen = false
    var screenCheck = false
    var token:String?
    var fixtureDictionary:[String:Any] = [:]
    var paymentArray:[[String:Any]] = []
    var userDictionary:[String:Any] = [:]
    var walletView : UIView!
    //var walletlabel : UILabel!
    var matchStatus:String?
    var walletAmounts:NSNumber = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataNotAvailableLabel.isHidden = true
        //contestDictionary = UserDefaults.standard.object(forKey:"ContestDictionary") as? [String:Any] ?? [:]
        print("ContestDictionary", contestDictionary)
        self.matchStatus = contestDictionary["status"] as? String
//        if tagController == "homeDetail"{
//            viewHeader.isHidden = false
//        }else{
//            viewHeader.isHidden = true
//        }
        if self.matchStatus == "LIVE" || self.matchStatus == "COMPLETED" || self.matchStatus == "IN REVIEW" {
            self.createTeamButton.isHidden = true
        }
        //        let prefs:UserDefaults = UserDefaults.standard
        //        prefs.set("", forKey: "UserTeamName")
        self.setupMenu()
        self.setupWalletView()
        self.dataNotAvailableLabel.isHidden = true
        self.tableView.rowHeight = 148.0
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
        
        self.flag = 1
        
        self.contestLabel.isHidden = false
        self.myContestLabel.isHidden = true
        self.myTeamLabel.isHidden = true
        self.scorecardLabel.isHidden = true
        
        
        self.teamAName.text = self.contestDictionary["teama"] as? String
        self.teamBName.text = self.contestDictionary["teamb"] as? String
        self.fixtureId = self.contestDictionary["id"] as? Int
        token = UserDefaults.standard.string(forKey:"AccessToken")!
        print("Token :", token as Any)
        print("FixtureIdssssss :", fixtureId as Any)
        if let id = self.fixtureId  {
            self.fixtureid = String(id)
        }
        self.walletAmount()
        if let imageUrl = contestDictionary["teama_image"] as? String,
           !imageUrl.isEmpty, let imgURl =  URL(string:imageUrl) {
            teamAImageView.sd_setImage(with: imgURl,placeholderImage: self.defaultImage, completed: nil)
        }
        if let imageUrl1 = contestDictionary["teamb_image"] as? String,
           !imageUrl1.isEmpty, let imgURl1 =  URL(string:imageUrl1) {
            teamBImageView.sd_setImage(with: imgURl1,placeholderImage: self.defaultImage, completed: nil)
        }
        let pref:UserDefaults = UserDefaults.standard
        pref.set(self.fixtureid, forKey:"FixtureId")
        pref.set(self.flag, forKey: "Flag")
        pref.synchronize()
        self.downloadImage(from: URL(string:"https://cricket.entitysport.com/assets/uploads/2021/05/team-120x120.png")!)
    }

    
    func passingData(name: String) {
        self.fixtureid = name
           print("FixtureIDMyContestDelegate \(String(describing:self.fixtureid))")
           
       }
    
    func passingCreateData(name: String) {
        self.fixtureid = name
        print("FixtureIDCreateDelegate \(String(describing:self.fixtureid))")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        else{
        if let id = self.fixtureid  {
            self.getContest()

        
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
                                    
                                    
                                    
                                   /* self.teamAName.text = self.fixtureDictionary["teama"] as? String
                                    self.teamBName.text = self.fixtureDictionary["teamb"] as? String
                                    
                                    if let imageUrl1 = self.fixtureDictionary["teama_image"] as? String,
                                       !imageUrl1.isEmpty, let imgURl1 =  URL(string:imageUrl1) {
                                        self.teamAImageView.sd_setImage(with: imgURl1,placeholderImage: self.defaultImage, completed: nil)
                                        if let imageUrl1 = self.fixtureDictionary["teamb_image"] as? String,
                                           !imageUrl1.isEmpty, let imgURl1 =  URL(string:imageUrl1) {
                                            self.teamBImageView.sd_setImage(with: imgURl1,placeholderImage: self.defaultImage, completed: nil)
                                            //teamBIcon.contentMode = .scaleAspectFill
                                        }
                                    }
 */
                                    self.tableView.reloadData()
                                }
                            
                            }
                        }
                        DispatchQueue.main.async {
                           // self.dataNotAvailableLabel.isHidden = (self.fixtureDictionary.count > 0)
                        }
                       }
        }
        }
      
    }

    @IBAction func btnWalletClick(_ sender: UIButton){
        let menuVC  = storyboard?.instantiateViewController(withIdentifier: "DPWalletVC") as? DPWalletVC
        self.navigationController?.pushViewController(menuVC!, animated:true)
    }
    @IBAction func btnMenu(_ sender: UIButton){
       // viewHeader.isHidden = true
        self.dismiss(animated: false)
        //present(sideMenu!, animated: true, completion: nil)
    }
    func getContest(){
        
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            if let id = self.fixtureid {
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
                                    
                                    self.dataNotAvailableLabel.isHidden = false
                                    
                                    /* let alertController = UIAlertController(title: "Alert", message: "No data available", preferredStyle: .alert)
                                     let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                                     print("you have pressed the Ok button");
                                     }
                                     alertController.addAction(okAction)
                                     */
                                    
                                }
                                self.tableView.reloadData()
                            }
                            
                        }
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
//        walletlabel = UILabel.init(frame: CGRect.init(x: 0, y: imageView.frame.maxY + 3, width: walletView.frame.width, height: 10))
//        walletlabel.textColor = .white
//        walletlabel.font = UIFont.systemFont(ofSize: 11)
//        walletlabel.text = " "
//        walletlabel.textAlignment = .center
       // walletView.addSubview(walletlabel)
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(DPHomePageVC.handleTap(_:)))
      
      walletView.addGestureRecognizer(tap1)
        let btn = UIBarButtonItem.init(customView: walletView)
        self.navigationItem.rightBarButtonItem = btn
        
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
//                                    self.walletAmounts = amount
//                                    self.walletlabel.text =  "₹" + String(amount)
//                                }
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
    
    func checkAvailableTeam(_ contest_id:Int){
        
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
        
        if let id = self.fixtureid {
        
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data","Authorization":"Bearer" + " " + token!,"X-Requested-With":"XMLHttpRequest"]
        let url = Constants.BaseUrl + "user_teams?fixture_id=" + id
        print("API URL: \(url)")

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
                                    if let myArray = self.dataDictionary["user_teams"] as? [[String:Any]] {
                                        self.userTeam = myArray
                                        print("UserTeam\(self.userTeam)")
                                        if self.matchStatus == "LIVE" || self.matchStatus == "COMPLETED"{
                                            
                                        }
                                        if self.userTeam.count == 0 {
                                            let Name = UserDefaults.standard.string(forKey: "Name")
                                             if Name == "" {
                                           // if kUserDefaults.getUserTeamName() == "" {
                                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                                let menuVC  = storyboard.instantiateViewController(withIdentifier: "CreateUsernameVC") as! CreateUsernameVC
                                                self.present(menuVC, animated: true)
                                            } else {
                                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                                let menuVC  = storyboard.instantiateViewController(withIdentifier: "DPTeamSelectionVC") as? DPTeamSelectionVC
                                                self.navigationController?.pushViewController(menuVC!, animated: true)
                                            }
                                            
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
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let menuVC  = storyboard?.instantiateViewController(withIdentifier: "DPWalletVC") as? DPWalletVC
        
        
        self.navigationController?.pushViewController(menuVC!, animated:true)

    }
    
    
    @IBAction func scorecardButtonTapped(_ sender:UIButton) {
        self.contestLabel.isHidden = true
        self.myContestLabel.isHidden = true
        self.myTeamLabel.isHidden = true
        self.scorecardLabel.isHidden = false
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menuVC  = storyboard.instantiateViewController(withIdentifier: "DPScorecardViewController") as? DPScorecardViewController
       // menuVC?.fixtureIds = self.fixtureId
        menuVC?.contestDictionary = self.contestDictionary
        
        self.navigationController?.pushViewController(menuVC!, animated: false)
       
        
    }
    @IBAction func myTeamButtonTapped(_ sender:UIButton) {
        self.contestLabel.isHidden = true
        self.myContestLabel.isHidden = true
        self.myTeamLabel.isHidden = false
        self.scorecardLabel.isHidden = true
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menuVC  = storyboard.instantiateViewController(withIdentifier: "DPCreateTeamVC") as? DPCreateTeamVC
        menuVC?.contestDictionary = self.contestDictionary
       // menuVC?.delegate = self
        self.navigationController?.pushViewController(menuVC!, animated:false)
       
        
        
    }
    @IBAction func myContestButtonTapped(_ sender:UIButton) {
        self.contestLabel.isHidden = true
        self.myContestLabel.isHidden = false
        self.myTeamLabel.isHidden = true
        self.scorecardLabel.isHidden = true
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menuVC  = storyboard.instantiateViewController(withIdentifier: "DPMyContestVC") as? DPMyContestVC
        menuVC?.delegate = self
        menuVC?.contestDictionary = self.contestDictionary
        self.navigationController?.pushViewController(menuVC!, animated:false)
        
    }
    @IBAction func contestButtonTapped(_ sender:UIButton) {
        self.contestLabel.isHidden = false
        self.myContestLabel.isHidden = true
        self.myTeamLabel.isHidden = true
        self.scorecardLabel.isHidden = true
       
    }
    @IBAction func createButtonTapped(_ sender: Any) {
     //   print(kUserDefaults.getUserTeamName())
       let Name = UserDefaults.standard.string(forKey: "Name")
        if Name == "" {
            guard let menuVC  = storyboard?.instantiateViewController(withIdentifier: "CreateUsernameVC") as? CreateUsernameVC else { return  }
            self.present(menuVC, animated: true)
        } else {
            let menuVC  = storyboard?.instantiateViewController(withIdentifier: "DPTeamSelectionVC") as? DPTeamSelectionVC
            menuVC?.teamDictionary = contestDictionary
            menuVC?.fixtrureIds = fixtureId
            self.navigationController?.pushViewController(menuVC!, animated: true)
        }
    }
    
    
    
    
    
}

    extension DPContestVC:UITableViewDataSource,UITableViewDelegate{
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if self.matchStatus == "LIVE" || self.matchStatus == "COMPLETED" || self.matchStatus == "CANCELLED"{
                self.tableView.isHidden = true
                self.dataNotAvailableLabel.isHidden = false
                self.dataNotAvailableLabel.text = "No Available/Activity contest to join"
                return 0
            } else {
                return self.contestArray.count
            }
            
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ContestCell
            let dictionary = self.contestArray[indexPath.row]
            print("Dictionary \(dictionary)")
            
            if self.matchStatus == "LIVE" || self.matchStatus == "COMPLETED" || self.matchStatus == "IN REVIEW"{
                cell?.joinContestButton.isUserInteractionEnabled = false
                cell?.joinContestButton.backgroundColor = UIColor.lightGray
            }
            
            cell?.joinContestButton.tag = indexPath.row
            //cell?.joinContestButton.titleLabel?.text =  "tap me"
            
            //            let index = indexPath.row
            
            if let prizes = dictionary["prize"] as? Int{
                cell?.prizeLabel.text = "₹" + String(prizes)
            }
            let dict = dictionary["entry_fee"] as? Int
            print("Dict \(String(describing: dict))")
            
            let maxTeamCount = dictionary["max_team"] as? Int
            cell?.labelTeamCount.text = "\(maxTeamCount ?? 1)T"
            
            
            let entry = "₹" + String(dict!)
            
            cell?.joinContestButton.setTitle(entry, for: .normal)
            let maxTeam = dictionary["joined"] as? Int
            print("Joined \(String(describing:maxTeam))")
            
            let max = String(maxTeam!)
            
            let totalTeam = dictionary["total_teams"] as? Int
            print("TotalTeam \(String(describing:totalTeam))")
            let total = String(totalTeam!)
            
            let value = max + "/" + total
            
            let sum = totalTeam! - maxTeam!
            
            let progress = (Float((Int(max) ?? 0))/Float((Int(total) ?? 0)))
            cell?.progressView.progress = progress
            
            cell?.leftSeat.text =  total + " " + "Total" + "Seats"
            cell?.leftSeats.text = String(sum) + " " + "Seats" + " " + "Left"
            cell?.winnerLabel.text = value
            
            
            
            
            
            if let borderView = cell?.viewWithTag(10) {
                
                
                borderView.layer.cornerRadius = 8
                borderView.layer.borderWidth = 1
                borderView.layer.borderColor = UIColor.clear.cgColor
            }
            
            /* if let matchName = cell?.viewWithTag(20) as? UILabel {
             matchName.text = dictionary["competition"] as? String
             }
             
             
             
             
             if let teamBIcon = cell?.viewWithTag(50) as? UIImageView {
             
             if let imageUrl = dictionary["teamb_image"] as? String, let  url = URL(string:imageUrl){
             print("UserURLImage \(url)")
             if let data = try? Data(contentsOf: url)  {
             teamBIcon.image = UIImage(data: data)
             //teamBIcon.contentMode = .scaleAspectFill
             }
             }
             }
             
             if let prize = cell?.viewWithTag(40) as? UIButton {
             if let prizes = dictionary["prize"] as? Int{
             prize.titleLabel?.text = String(prizes)
             prize.addTarget(self, action:#selector(DPContestVC.goodTapped), for:.touchUpInside)
             
             
             }
             }
             
             if let totalTeam = cell?.viewWithTag(50) as? UILabel {
             if let total = dictionary["total_teams"] as? Int {
             totalTeam.text = String(total)
             }
             }
             
             
             
             if let entryFee = cell?.viewWithTag(150) as? UIButton {
             if let fee = dictionary["entry_fee"] as? String{
             
             entryFee.titleLabel?.text = fee
             }
             
             }
             if let gameType = cell?.viewWithTag(90) as? UILabel {
             gameType.text = dictionary["type"] as? String
             }
             */
            
            cell?.cellDelegate = self
            cell?.index = indexPath
            return cell!
            
            
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let dictionary = self.contestArray[indexPath.row]
            print("Dictionary \(dictionary)")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let menuVC  = storyboard.instantiateViewController(withIdentifier: "DPPrizeBreakupController") as? DPPrizeBreakupController
            menuVC?.flags = self.flag
            menuVC?.headerController = "Navigation"
            menuVC?.prizeCellDictionary = dictionary
            menuVC?.contestArrayData = dictionary
//            let pref:UserDefaults = UserDefaults.standard
//            pref.set(dictionary, forKey:"PrizeBreakUPDictionary")
//            // pref.set(self.flag, forKey: "Flag")
//            pref.synchronize()

            self.navigationController?.pushViewController(menuVC!, animated: true)
        }
        
        
    @objc func goodTapped(sender:UIButton){
            print("Ankit")
        
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


extension DPContestVC:TableViewNews{
    func onCickCell(index: Int) {
        let dictionary = self.contestArray[index]
        if let entry_fee = dictionary["entry_fee"] as? Int{
            var wallet = self.walletAmounts.intValue
            wallet = (wallet == 0) ? -1 : wallet
            print("Wallet \(String(describing: wallet))")
            if wallet < entry_fee{//self.walletAmounts! < 100  {
                KSToastView.ks_showToast("Insufficient Balance", duration: 4.0)
                return
            }
            if let id = dictionary["id"] as? Int{
                self.checkAvailableTeam(id)
            }
        }
    }
    
    func onCickCell2(index: Int) {
        let wallet = self.walletAmounts
        print("Wallet \(String(describing: wallet))")
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
                  /*  let alert = UIAlertController(title: "Alert", message: "Insuffient Balance", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
 /*
                    
                }
                else if self.walletAmounts! >= 100  {
            
            self.checkAvaiilableTeam()
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
        
      
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


}

 }*/*/
