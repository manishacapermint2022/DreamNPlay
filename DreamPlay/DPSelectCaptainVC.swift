//
//  DPSelectCaptainVC.swift
//  DreamPlay
//
//  Created by MAC on 15/06/21.
//

import UIKit
import Alamofire
import SVProgressHUD
import SideMenu
import SDWebImage

class DPSelectCaptainVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sellerView: UIView!
    
    @IBOutlet weak var createGameButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var firstCountryImageView: UIImageView!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var teamAName: UILabel!
    @IBOutlet weak var teamBName: UILabel!
    @IBOutlet weak var secondCountryImageView: UIImageView!
    @IBOutlet weak var captainView: UIView!
    @IBOutlet weak var viceCaptainView: UIView!
    var dataDictionary:[String:Any] = [:]
    var squadDictionary:[String:Any] = [:]
    var message:String?
    var fixtrureIds:Int?
    let accessToken: Any? = UserDefaults.standard.object(forKey:"AccessToken") as Any?
    let fixtureId: Any? = UserDefaults.standard.object(forKey:"FixtureId") as Any?
    var token:String?
    var playerArray:[[String:Any]] = []
    var captainDictionary:[String:Any] = [:]
    var playerIDArray:[Int] = []
    var responseDictionary:[String:Any] = [:]
    var captainArray:[Int] = []
    var captainId:String?
    var viceCaptainId:String?
    var walletView : UIView!
    var walletlabel : UILabel!
    var userDictionary:[String:Any] = [:]
    var selectedCaptainDictionary:[String:Any] = [:]
    var selectedViceCaptainDictionary:[String:Any] = [:]
    var status:Int?
    //    var captainID:Int?
    //    var viceCaptainID:Int?
    var playerIds:Int?
    var sideMenu:SideMenuNavigationController?
    var defaultImage:UIImage?
    var playersArray:[Int] = []
    var teamUpdateId : Int?
    var isEdit = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupMenu()
        self.setupWalletView()
        self.playerIDArray.removeAll()
        
        print("PlayerArray\(self.playerArray)")
        
        if let c = self.selectedCaptainDictionary["player_id"] as? Int{
            let id = String(c)
            self.captainId = id
        }
        if let vc = self.selectedViceCaptainDictionary["player_id"] as? Int{
            let id = String(vc)
            self.viceCaptainId = id
        }
        
        
        print("CaptainID",self.captainId)
        print("ViceCaptainID",self.viceCaptainId)
        
        self.tableView.rowHeight = 80.0
        self.tableView.allowsMultipleSelection = true
        
        token = UserDefaults.standard.string(forKey:"AccessToken")!
        print("Token :", token as Any)
        print("CaptainDictionary",captainDictionary)
        
        self.walletAmount()
        
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            if let id = self.fixtureId as? String {
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
                            print("responseObject \(responseObject)")
                            SVProgressHUD.dismiss()
                            self.responseDictionary = responseObject as! [String:Any]
                            if let dict = self.responseDictionary["data"]
                                as? [String:Any] {
                                self.dataDictionary = dict
                                print("DataDictionary \(self.dataDictionary)")
                                if let dict = self.dataDictionary["fixture"] as? [String:Any] {
                                    self.squadDictionary = dict
                                    print("SquardDictionary \(self.squadDictionary)")
                                }
                                
                                self.teamAName.text = self.squadDictionary["teama"] as? String
                                self.teamBName.text = self.squadDictionary["teamb"] as? String
                                self.teamAName.text = self.squadDictionary["teama_short_name"] as? String
                                self.teamBName.text = self.squadDictionary["teamb_short_name"] as? String
                                
                                
                            }
                            
                            
                            if let imageUrl = self.squadDictionary["teama_image"] as? String,
                               !imageUrl.isEmpty, let imgURl =  URL(string:imageUrl) {
                                self.firstCountryImageView.sd_setImage(with: imgURl,placeholderImage: self.defaultImage, completed: nil)
                            }
                            
                            if let imageUrl = self.squadDictionary["teamb_image"] as? String,
                               !imageUrl.isEmpty, let imgURl =  URL(string:imageUrl) {
                                self.secondCountryImageView.sd_setImage(with: imgURl,placeholderImage: self.defaultImage, completed: nil)
                            }
                            
                            
                            
                            self.tableView.reloadData()
                        }
                        
                        
                    }
                    
                }
            }
            
            
            
            for player in self.playerArray {
                
                if let playerid = player["player_id"] as? Int {
                    self.playerIDArray.append(playerid)
                }
            }
            
            
            self.teamAName.text = self.captainDictionary["teama"] as? String
            self.teamBName.text = self.captainDictionary["teamb"] as? String
            
            
            topView.layer.cornerRadius = 8
            topView.layer.borderWidth = 1
            topView.layer.borderColor = UIColor.clear.cgColor
            sellerView.layer.cornerRadius = 8
            sellerView.layer.borderWidth = 1
            sellerView.layer.borderColor = UIColor.clear.cgColor
            
            backButton.layer.cornerRadius = 8
            backButton.layer.borderWidth = 1
            backButton.layer.borderColor = UIColor.clear.cgColor
            createGameButton.layer.cornerRadius = 8
            createGameButton.layer.borderWidth = 1
            createGameButton.layer.borderColor = UIColor.clear.cgColor
            let logo = UIImage(named:"layer3")
            let imageView = UIImageView(image:logo)
            imageView.frame = CGRect(x: 150, y: 20, width: 100.0, height: 30.0)
            self.navigationItem.titleView = imageView
            
            
            self.tableView.backgroundView = UIImageView(image: UIImage(named: "Background"))
            
            self.tableView.reloadData()
        }
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
                
                self?.defaultImage = UIImage(data: data)
                print("DefaultImage\(String(describing: self?.defaultImage))")
            }
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func captionSelect(_ sender:UIButton){
        let row = sender.tag
        
        let dictionary = self.playerArray[row]
        print("SelectCaptain\(dictionary)")
        if let playerId = dictionary["player_id"] as? Int{
            captainId = "\(playerId)"
        }
        self.tableView.reloadData()
        
    }
    @objc func viceCaptionSelect(_ sender:UIButton){
        let row = sender.tag
        
        let dictionary = self.playerArray[row]
        print("SelectCaptain\(dictionary)")
        if let playerId = dictionary["player_id"] as? Int{
            viceCaptainId = "\(playerId)"
        }
        self.tableView.reloadData()
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
        let btn = UIBarButtonItem.init(customView: walletView)
        self.navigationItem.rightBarButtonItem = btn
        
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
    
    
    @IBAction func toggleButtonTapped(_ sender: Any) {
        present(sideMenu!, animated: true, completion: nil)
        
        
    }
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if captainId == nil {
            let alert = UIAlertController(title: "Alert", message: "Please select captain", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        else if viceCaptainId == nil{
            let alert = UIAlertController(title: "Alert", message: "Please select vice captain", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        else  if self.playerArray.count < 11 {
            
            let alert = UIAlertController(title: "Alert", message: "Please add 11 players to create a team", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        else {
            
            
            
            
            if isInternetAvailable() == false{
                let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else{
                var url = ""
                var apiType = ""
                if isEdit {
                    url = Constants.BaseUrl + "user_teams/\(teamUpdateId ?? 0)"
                    apiType = "PUT"
                } else {
                    url = Constants.BaseUrl + "user_teams"
                    apiType = "POST"
                }
                print("API URL: \(url)")
                if let apiString = URL(string:url) {
                    var request = URLRequest(url:apiString)
                    request.httpMethod = apiType
                    request.setValue("application/json",
                                     forHTTPHeaderField: "Content-Type")
                    request.setValue("Bearer" + " " + token!, forHTTPHeaderField: "Authorization")
                    
                    let values = ["fixture_id":self.fixtureId as Any,
                                  "players":self.playerIDArray,
                                  "captain_id":self.captainId as Any,
                                  "vice_captain_id":self.viceCaptainId as Any] as [String : Any]
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
                                self.status = self.responseDictionary["status"] as? Int
                                self.message = self.responseDictionary["message"] as? String
                                if self.status == 0 {
                                    
                                    let alertController = UIAlertController(title: "Alert", message: self.message, preferredStyle: .alert)
                                    let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                                        print("you have pressed the Ok button");
                                    }
                                    alertController.addAction(okAction)
                                    self.present(alertController, animated: true, completion:nil)
                                    
                                }
                                else if self.status == 1{
                                    let alertController = UIAlertController(title: "Alert", message:self.message, preferredStyle: .alert)
                                    let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
//                                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                                        let menuVC  = storyboard.instantiateViewController(withIdentifier: "DPHomePageVC") as? DPHomePageVC
//                                        self.navigationController?.pushViewController(menuVC!, animated: true)
                                       
//                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                                    let menuVC  = storyboard.instantiateViewController(withIdentifier: "DPContestVC") as? DPContestVC
//                                    self.navigationController?.pushViewController(menuVC!, animated: true)
                                        self.backTwo()
                                     //   self.navigationController?.popToRootViewController(animated: true)
                                    }
                                    alertController.addAction(okAction)
                                    self.present(alertController, animated: true, completion:nil)
                                    
                                }
                                
                                
                                
                            }
                        }
                }
            }
            
            
        }
    }
    func backTwo() {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
    }
}

extension DPSelectCaptainVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "DPSelectCaptainCell", for: indexPath) as! DPSelectCaptainCell
        
        let dict = self.playerArray[indexPath.row]
        print("PlayerDictionary\(dict)")
       if let borderView = cell.viewWithTag(10) {
            
      
        borderView.layer.cornerRadius = 8
        borderView.layer.borderWidth = 1
        borderView.layer.borderColor = UIColor.clear.cgColor
        }
        
        
        
        
       if let playerName = cell.viewWithTag(10) as? UILabel {
        playerName.text  = dict["name"] as? String
        }
        
        if let team = cell.viewWithTag(20) as? UILabel {
            team.text  = dict["team"] as? String
         }
        
        var isCaption = false
        var isViceCaptain = false
        if let playerId = dict["player_id"] as? Int, let ID = captainId, Int(ID) == playerId{
            isCaption = true
            //isViceCaptain = false
        }
        if let playerId = dict["player_id"] as? Int, let ID = viceCaptainId, Int(ID) == playerId{
            isViceCaptain = true
            //isCaption = false
        }
        
//        if let captain = cell.viewWithTag(30) as? UIButton {
        cell.captain.tag = indexPath.row
            cell.captain.layer.borderWidth = isCaption ? 1.0 : 0.0
            cell.captain.layer.borderColor = UIColor.gray.cgColor
            cell.captain.layer.cornerRadius = cell.captain.frame.size.width / 2
            cell.captain.clipsToBounds = true
        cell.captain.backgroundColor = isCaption ? UIColor.init(red: 68.0/255.0, green: 163.0/255.0, blue: 0.0/255.0, alpha: 1.0) : UIColor.white
            cell.captain.addTarget(self, action: #selector(captionSelect(_:)), for: .touchUpInside)
//        }
        
//        if let vicecaptain = cell.viewWithTag(40) as? UIButton {
            cell.viceCaptain.tag = indexPath.row
            cell.viceCaptain.layer.borderWidth = isViceCaptain ? 1.0 : 0.0
            cell.viceCaptain.layer.borderColor = UIColor.gray.cgColor
            cell.viceCaptain.layer.cornerRadius = cell.viceCaptain.frame.size.width / 2
            cell.viceCaptain.clipsToBounds = true
            cell.viceCaptain.backgroundColor = isViceCaptain ? UIColor.init(red: 68.0/255.0, green: 163.0/255.0, blue: 0.0/255.0, alpha: 1.0) : UIColor.white
            cell.viceCaptain.addTarget(self, action: #selector(viceCaptionSelect(_:)), for: .touchUpInside)
//        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
    }

   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }


}
class DPSelectCaptainCell: UITableViewCell {
    static let ID = "DPSelectCaptainCell"
    @IBOutlet weak var captain: UIButton!
    @IBOutlet weak var viceCaptain: UIButton!
    

    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
