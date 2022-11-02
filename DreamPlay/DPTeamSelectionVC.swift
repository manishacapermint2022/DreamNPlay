//
//  DPTeamSelectionVC.swift
//  DreamPlay
//
//  Created by MAC on 17/06/21.
//

import UIKit
import Alamofire
import SVProgressHUD
import SDWebImage

class DPTeamSelectionVC: UIViewController {
    var isOpen = false
    var screenCheck = false
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var creditView: UIView!
    @IBOutlet weak var teamBName: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var teamAName: UILabel!
    @IBOutlet weak var teamBImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var alrounderCountLabel: UILabel!
    @IBOutlet weak var creditScoreLabel: UILabel!
    @IBOutlet weak var levelIndicatorView: UIView!
    
    @IBOutlet weak var teamAImageView: UIImageView!
    var responseDictionary:[String:Any] = [:]
    @IBOutlet weak var bowlerCountLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    var dataDictionary:[String:Any] = [:]
    var squadDictionary:[String:Any] = [:]
    @IBOutlet weak var alrounderView: UIView!
    var teamArray:[[String:Any]] = []
    var squadArray:[[String:Any]] = []
    var token:String?
    var paymentArray:[[String:Any]] = []
    var selectedPayerArray:[[String:Any]] = []
    var selectWikerKeeper:[Int] = []
    var selectBatsman:[Int] = []
    var wicketKepperArray:[[String:Any]] = []
    var alrounderArray:[Int] = []
    var selectedBowlerArray:[Int] = []
    var batsmanArray:[[String:Any]] = []
    var selectedIndicies:[Int] = []
    var wicketkeeperCredit:[String] = []
    var credit:Double?
    var totalAmount:Double?
    var teamsArray:[[String:Any]] = []
    var teams:[String] = []
    var teamA:String?
    var teamANameVariable:String = ""
    var teamBNameVariable:String = ""
    var defaultImage:UIImage?
    
    var creditLeft = 100.0 {
        didSet {
            print("newValue \(creditLeft) \(oldValue)")
            guard creditLeft >= 0.0 else {
                creditLeft = oldValue
                return
            }
            creditScoreLabel.text = String(creditLeft)
        }
    }
    @IBOutlet weak var label11: UILabel!
    @IBOutlet weak var label10: UILabel!
    @IBOutlet weak var label9: UILabel!
    @IBOutlet weak var label8: UILabel!
    @IBOutlet weak var label7: UILabel!
    @IBOutlet weak var label6: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var wicketKeeperView: UIView!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var batsmanView: UIView!
    
    @IBOutlet weak var batsmanCountLabel: UILabel!
    
    @IBOutlet weak var alrounderLabel: UILabel!
    @IBOutlet weak var wicketKeeper: UILabel!
    
    @IBOutlet weak var bowlerLabel: UILabel!
    @IBOutlet weak var batsmanLabel: UILabel!
    @IBOutlet weak var bowlerView: UIView!
    @IBOutlet weak var arounderView: UIView!
    @IBOutlet weak var wicketKeeperLabel: UILabel!
    @IBOutlet weak var totalPlayerCount: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var previewButton: UIButton!
    var playerArray:[[String:Any]] = []
    var teamDictionary:[String:Any] = [:]
    var fixtrureIds:Int?
    var fixtureId:String?
    var wicketKeeperArray:[[String:Any]] = []
    var isSelected:Bool?
    var selectedplayerss:[Int] = []
    var creditArray:[Int] = []
    var totalPlayer:Int?
    var total:Int?
    
    @IBOutlet weak var teamBCount: UILabel!
    @IBOutlet weak var teamACount: UILabel!
    @IBOutlet weak var teamBLabel: UILabel!
    @IBOutlet weak var teamALabel: UILabel!
    var editDictionary:[String:Any] = [:]
    var userDictionary:[String:Any] = [:]
    var walletView : UIView!
    var walletlabel : UILabel!
    var flag:Int?
    var editArray:[[String:Any]] = []
    var wicketKeeperCount:Int?
    var batsmanCount:Int?
    var bowlerCount:Int?
    var alrounderCount:Int?
    var playerArrays:[[String:Any]] = []
    var captainDictionary:[String:Any] = [:]
    var viceCaptainDictionary:[String:Any] = [:]
    
    let fixtureIdss: Any? = UserDefaults.standard.object(forKey:"FixtureId") as Any?
    let dictionary: Any? = UserDefaults.standard.object(forKey:"ContestDictionary") as Any?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.flag = 2
        
        self.creditArray.removeAll()
        creditScoreLabel.text = String(100.0)
        self.setupWalletView()
        if let dict = dictionary as? [String:Any] {
            self.teamDictionary = dict
        }
        
        self.playerArray.removeAll()
        self.selectedPayerArray.removeAll()
        self.wicketKepperArray.removeAll()
        self.batsmanArray.removeAll()
        
        
        self.tableView.allowsMultipleSelection = true
//        tableView.rowHeight = UITableView.automaticDimension
//        tableView.estimatedRowHeight = 300
//        var frame = tableView.frame
//        frame.size.height = tableView.contentSize.height
//        tableView.frame = frame
        
        self.wicketKeeperLabel.isHidden = false
        self.batsmanLabel.isHidden = true
        self.alrounderLabel.isHidden = true
        self.bowlerLabel.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(DPTeamSelectionVC.handleTap(_:)))
        
        wicketKeeperView.addGestureRecognizer(tap)
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(DPTeamSelectionVC.handleTap1(_:)))
        
        batsmanView.addGestureRecognizer(tap1)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(DPTeamSelectionVC.handleTap2(_:)))
        
        arounderView.addGestureRecognizer(tap2)
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(DPTeamSelectionVC.handleTap3(_:)))
        
        bowlerView.addGestureRecognizer(tap3)
        let logo = UIImage(named:"layer3")
        let imageView = UIImageView(image:logo)
        imageView.frame = CGRect(x: 150, y: 20, width: 100.0, height: 30.0)
        self.navigationItem.titleView = imageView
        
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "Background"))
        let accessToken: Any? = UserDefaults.standard.object(forKey: "AccessToken") as Any?
        topView.layer.cornerRadius = 8
        topView.layer.borderWidth = 1
        topView.layer.borderColor = UIColor.clear.cgColor
        resetButton.layer.cornerRadius = 8
        resetButton.layer.borderWidth = 1
        resetButton.layer.borderColor = UIColor.clear.cgColor
        creditView.layer.cornerRadius = 8
        creditView.layer.borderWidth = 1
        creditView.layer.borderColor = UIColor.clear.cgColor
        previewButton.layer.cornerRadius = 8
        previewButton.layer.borderWidth = 1
        previewButton.layer.borderColor = UIColor.clear.cgColor
        continueButton.layer.cornerRadius = 8
        continueButton.layer.borderWidth = 1
        continueButton.layer.borderColor = UIColor.clear.cgColor
        
        token = UserDefaults.standard.string(forKey:"AccessToken")!
        print("Token :", token as Any)
        print("FixtureIdss :", fixtureIdss as Any)
        print("EditDictionary :",editDictionary)
        if let dict = editDictionary["captain"] as? [String:Any] {
            self.captainDictionary = dict
        }
        if let dict = editDictionary["vice_captain"] as? [String:Any] {
            self.viceCaptainDictionary = dict
        }
        if let myArray = editDictionary["players"] as? [[String:Any]] {
            self.playerArrays = myArray
            print("EditArray :",self.playerArrays)
            for player in self.playerArrays {
                self.selectedPlayer(player)
            }
        }
        
        /* if let myArray = editDictionary["players"] as? [[String:Any]] {
         
         self.playerArrays = myArray
         print("EditArray :",self.playerArrays)
         }
         
         
         print("TeamDictionary :", teamDictionary)
         
         if let wicketKeeper = self.editDictionary["wicket_keeper"] as? Int {
         self.wicketKeeperCount = wicketKeeper
         print("WicketKeeper :", wicketKeeper)
         self.wicketKeeper.text = "(" + String(wicketKeeper) + ")"
         }
         
         if let bowlerCount = self.editDictionary["bowlers"] as? Int {
         self.bowlerCount = bowlerCount
         //cell.wicketKeeperCount.text = String(wicketKeeper)
         // print("WicketKeeper :", wicketKeeper)
         self.bowlerCountLabel.text = "(" + String(bowlerCount) + ")"
         }
         
         if let alrounderCount = self.editDictionary["all_rounders"] as? Int {
         
         self.alrounderCount = alrounderCount
         //cell.wicketKeeperCount.text = String(wicketKeeper)
         // print("WicketKeeper :", wicketKeeper)
         self.alrounderCountLabel.text = "(" + String(alrounderCount) + ")"
         }
         
         if let batsmanCount = self.editDictionary["batsmen"] as? Int {
         
         self.batsmanCount = batsmanCount
         //cell.wicketKeeperCount.text = String(wicketKeeper)
         // print("WicketKeeper :", wicketKeeper)
         self.batsmanCountLabel.text = "(" + String(batsmanCount) + ")"
         }
         
         if let teamaDictionary = self.editDictionary["teama"] as? [String:Any] {
         if let count = teamaDictionary["count"] as? Int {
         teamACount.text = String(count)
         }
         }
         
         if let teambDictionary = self.editDictionary["teamb"] as? [String:Any] {
         if let count = teambDictionary["count"] as? Int {
         teamBCount.text = String(count)
         }
         }
         
         if let bowlerCount = self.editDictionary["bowlers"] as? Int, let batsmanCount = self.editDictionary["batsmen"] as? Int, let wicketKeeper = self.editDictionary["wicket_keeper"] as? Int, let alrounderCount = self.editDictionary["all_rounders"] as? Int {
         
         let total  = bowlerCount + batsmanCount + wicketKeeper + alrounderCount
         print("Total11 :", total)
         self.total = total
         self.totalPlayerCount.text = String(total) + "/11"
         
         }
         */
        
        
        /* for level in levelIndicatorView.subviews {
         if level.tag <  self.total!{
         level.backgroundColor = UIColor.green
         }
         }
         */
        
        
        
        
        // self.editArray = self.editDictionary
        
        self.walletAmount()
        
        self.downloadImage(from: URL(string:"https://cricket.entitysport.com/assets/uploads/2021/05/team-120x120.png")!)
        
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "Background"))
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            SVProgressHUD.show()
            if let id = self.fixtureIdss as? String {
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
                                self.teamANameVariable = self.squadDictionary["teama"] as? String ?? ""
                                self.teamAName.text = self.teamANameVariable
                                self.teamBNameVariable = self.squadDictionary["teamb"] as? String ?? ""
                                self.teamBName.text = self.teamBNameVariable
                                self.teamALabel.text = self.squadDictionary["teama_short_name"] as? String
                                self.teamBLabel.text = self.squadDictionary["teamb_short_name"] as? String
                                if let imageUrl = self.squadDictionary["teama_image"] as? String,
                                   !imageUrl.isEmpty, let imgURl =  URL(string:imageUrl) {
                                    self.teamAImageView.sd_setImage(with: imgURl,placeholderImage: self.defaultImage, completed: nil)
                                }
                                if let imageUrl = self.squadDictionary["teamb_image"] as? String,
                                   !imageUrl.isEmpty, let imgURl =  URL(string:imageUrl) {
                                    self.teamBImageView.sd_setImage(with: imgURl,placeholderImage: self.defaultImage, completed: nil)
                                }
                                if let myArray = self.squadDictionary["squads"] as? [[String:Any]] {
                                    self.squadArray = myArray
                                    print("SquardArray \(self.squadArray)")
                                }
                                for wk in self.squadArray {
                                    if wk["position"] as! String == "WK"{
                                        
                                        print("WiketKeeperList \(wk)")
                                        self.playerArray.append(wk)
                                        
                                    }
                                    
                                }
                                self.tableView.reloadData()
                              
                                
                            }
                            
                        }
                    }
                    
                }
            }
        }
        
        
        
        // Do any additional setup after loading the view.
        
        
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
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(DPTeamSelectionVC.wallets(_:)))
        
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
    
    
    @objc func wallets(_ sender: UITapGestureRecognizer) {
        let menuVC  = storyboard?.instantiateViewController(withIdentifier: "DPWalletVC") as? DPWalletVC
        
        
        self.navigationController?.pushViewController(menuVC!, animated:true)
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            if let id = self.fixtureIdss as? String {
                self.playerArray.removeAll()
                self.wicketKeeperLabel.isHidden = false
                self.batsmanLabel.isHidden = true
                self.alrounderLabel.isHidden = true
                self.bowlerLabel.isHidden = true
                SVProgressHUD.show()
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
                            SVProgressHUD.dismiss()
                            print("responseObject \(responseObject)")
                            
                            self.responseDictionary = responseObject as! [String:Any]
                            if let dict = self.responseDictionary["data"]
                                as? [String:Any] {
                                self.dataDictionary = dict
                                print("DataDictionary \(self.dataDictionary)")
                                if let dict = self.dataDictionary["fixture"] as? [String:Any] {
                                    self.squadDictionary = dict
                                    print("SquardDictionary \(self.squadDictionary)")
                                }
                                if let myArray = self.squadDictionary["squads"] as? [[String:Any]] {
                                    self.squadArray = myArray
                                    print("SquardArray \(self.squadArray)")
                                    
                                    
                                }
                                for wk in self.squadArray {
                                    
                                    if wk["position"] as! String == "WK"{
                                        
                                        print("WiketKeeperList \(wk)")
                                      
                                        self.playerArray.append(wk)
                                        
                                    }
                                }
                                self.tableView.reloadData()
                              
                                
                            }
                            
                        }
                    }
                }
            }
        }
    }
    @objc func handleTap1(_ sender: UITapGestureRecognizer) {
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            if let id = self.fixtureIdss as? String {
                self.playerArray.removeAll()
                self.wicketKeeperLabel.isHidden = true
                self.batsmanLabel.isHidden = false
                self.alrounderLabel.isHidden = true
                self.bowlerLabel.isHidden = true
                SVProgressHUD.show()
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
                                if let myArray = self.squadDictionary["squads"] as? [[String:Any]] {
                                    self.squadArray = myArray
                                    
                                    print("SquardArray \(self.squadArray)")
                                    
                                    
                                }
                                for wk in self.squadArray {
                                    
                                    if wk["position"] as! String == "BAT"{
                                        
                                        print("BatsmanList \(wk)")
                                        self.playerArray.append(wk)
                                        
                                    }
                                    
                                }
                                self.tableView.reloadData()
                               
                                
                            }
                            
                        }
                    }
                }
            }
        }
    }
    @objc func handleTap2(_ sender: UITapGestureRecognizer) {
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            if let id = self.fixtureIdss as? String {
                self.playerArray.removeAll()
                self.wicketKeeperLabel.isHidden = true
                self.batsmanLabel.isHidden = true
                self.alrounderLabel.isHidden = false
                self.bowlerLabel.isHidden = true
                SVProgressHUD.show()
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
                                if let myArray = self.squadDictionary["squads"] as? [[String:Any]] {
                                    self.squadArray = myArray
                                    print("SquardArray \(self.squadArray)")
                                    
                                    
                                }
                                for wk in self.squadArray {
                                    
                                    if wk["position"] as! String == "AR"{
                                        
                                        print("BatsmanList \(wk)")
                                        self.playerArray.append(wk)
                                        
                                    }
                                    
                                }
                                self.tableView.reloadData()
                               
                                
                            }
                            
                        }
                    }
                }
            }
        }
    }
    @objc func handleTap3(_ sender: UITapGestureRecognizer) {
        
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            
            if let id = self.fixtureIdss as? String {
                self.playerArray.removeAll()
                self.wicketKeeperLabel.isHidden = true
                self.batsmanLabel.isHidden = true
                self.alrounderLabel.isHidden = true
                self.bowlerLabel.isHidden = false
                SVProgressHUD.show()
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
                                if let myArray = self.squadDictionary["squads"] as? [[String:Any]] {
                                    self.squadArray = myArray
                                    print("SquardArray \(self.squadArray)")
                                    
                                    
                                }
                                for wk in self.squadArray {
                                    
                                    if wk["position"] as! String == "BOWL"{
                                        
                                        print("BatsmanList \(wk)")
                                        self.playerArray.append(wk)
                                        
                                    }
                                    
                                }
                                self.tableView.reloadData()
                               
                                
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func resetButtonTapped(_ sender: Any) {
        print ("Reset")
        self.selectedBowlerArray.removeAll()
        self.selectWikerKeeper.removeAll()
        self.selectBatsman.removeAll()
        self.alrounderArray.removeAll()
        self.selectedPayerArray.removeAll()
        self.tableView.reloadData()
       
        
        self.wicketKeeper.text = "(0)"
        self.batsmanCountLabel.text = "(0)"
        self.bowlerCountLabel.text = "(0)"
        self.alrounderCountLabel.text = "(0)"
        self.creditArray.removeAll()
        self.teamACount.text = "0"
        self.teamBCount.text = "0"
        self.totalPlayerCount.text = "0/11"
        self.creditLeft = 100.0
        for level in levelIndicatorView.subviews {
            level.backgroundColor = UIColor.white
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
                        //                                    if let amount = self.userDictionary["balance"] as? Int {
                        //    //                                    self.amountLabel.text = "₹" + String(amount)
                        //                                        self.walletlabel.text = "₹" + String(amount)
                        //                                    }
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
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        if totalPlayer ?? 0 < 11  {
            let alertController = UIAlertController(title: "Alert", message: "Please select 11 players to make a team", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                print("you have pressed the Ok button");
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion:nil)
        }
        else if selectBatsman.count < 3 {
            let alertController = UIAlertController(title: "Alert", message: "Please select more batsman", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                print("you have pressed the Ok button");
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion:nil)
        }
        else if selectedBowlerArray.count < 3 {
            let alertController = UIAlertController(title: "Alert", message: "Please select more bowler", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                print("you have pressed the Ok button");
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion:nil)
        }
        else if selectedBowlerArray.count < 1 {
            let alertController = UIAlertController(title: "Alert", message: "Please select more wicketkeeper", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                print("you have pressed the Ok button");
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion:nil)
        }
        else if alrounderArray.count < 1 {
            let alertController = UIAlertController(title: "Alert", message: "Please select more alrounder", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                print("you have pressed the Ok button");
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion:nil)
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menuVC  = storyboard.instantiateViewController(withIdentifier: "DPSelectCaptainVC") as? DPSelectCaptainVC
        menuVC?.playerArray = self.selectedPayerArray
        // menuVC?.playerArray = self.playerArrays
        menuVC?.captainDictionary = teamDictionary
        menuVC?.selectedCaptainDictionary = self.captainDictionary
        menuVC?.selectedViceCaptainDictionary = self.viceCaptainDictionary
        if editDictionary["id"] as? Int != nil {
            menuVC?.teamUpdateId = editDictionary["id"] as? Int
            menuVC?.isEdit = true
        }
        print("MenuVC.PlayerArray \(String(describing: menuVC?.playerArray))")
        // print("MenuVC.CaptainDictionary \(String(describing: menuVC?.captainDictionary))")
        // print("MenuVC.SelectedCaptainDictionary \(String(describing: menuVC?.selectedCaptainDictionary))")
        // print("MenuVC.SelectedViceCaptainDictionary \(String(describing: menuVC?.selectedViceCaptainDictionary))")
        self.navigationController?.pushViewController(menuVC!, animated: true)
    }
    @IBAction func previewButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menuVC  = storyboard.instantiateViewController(withIdentifier: "DPPreviewViewController") as? DPPreviewViewController
        menuVC?.previewArray = self.selectedPayerArray
        self.navigationController?.pushViewController(menuVC!, animated: true)
    }
    @IBAction func toggleButtonTapped(_ sender: Any) {
        
    }
    
}

    
extension DPTeamSelectionVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.playerArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? TeamSelectionCell
        let dictionary = self.playerArray[indexPath.row]
        let playerType = dictionary["position"] as? String
        //print("Dictionarysss \(dictionary)")
        
        let name = dictionary["name"] as? String
        cell?.playerName.text = name
        cell?.teamName.text = dictionary["team"] as? String
        cell?.creditLabel.text = dictionary["credit"] as? String
        if let imageUrl = dictionary["image_path"] as? String,
           !imageUrl.isEmpty, let imgURl =  URL(string:imageUrl) {
            cell?.playerImage.sd_setImage(with: imgURl, placeholderImage: UIImage(named: "man"), completed: nil)
        }
        cell?.playerAddButton.tag = indexPath.row
        var image = UIImage(named: "plus-1")
        let index = indexPath.row
        let player_id = dictionary["player_id"] as? Int ?? 0
        var isSelected = false
        if playerType == "WK" {
            isSelected = self.selectWikerKeeper.contains(player_id)
        }
        else if playerType == "BAT" {
            isSelected = self.selectBatsman.contains(player_id)
        }
        else if playerType == "AR" {
            isSelected = self.alrounderArray.contains(player_id)
        }
        else if playerType == "BOWL" {
            isSelected = self.selectedBowlerArray.contains(player_id)
        }
        if isSelected {
            image =  UIImage(named: "minus")
        }
        cell?.playerAddButton.setImage(image, for: .normal)
        cell?.cellDelegate = self
        cell?.index = indexPath
        return cell!
    }
}
extension DPTeamSelectionVC:TableViewNew{
    
    func isAddAllowed(credit: Double) -> Bool {
        let newValue = creditLeft - credit
        guard newValue >= 0.0 else {
            return false
        }
        creditLeft = newValue
        return true
    }
    
    
    
    
    func isPlayerFromTeamA(_ playerID:Int)->Bool{
        //        let totalSelectedPlayers = selectedBowlerArray + selectWikerKeeper + alrounderArray + selectBatsman
        let teamAMaxPlayersArray = squadArray.filter { (dic) -> Bool in
            let a = dic["team"] as? String ?? ""
            if !a.isEmpty,  a == self.teamANameVariable{
                return true
            }
            return false
        }
        let teamAMaxPlayersIdsArray = teamAMaxPlayersArray.map { (dic) -> Int in
            return dic["player_id"] as? Int ?? 0
        }
        return teamAMaxPlayersIdsArray.contains(playerID)
    }
    
    func isPlayerFromTeamB(_ playerID:Int)->Bool{
        let teamBMaxPlayersArray = squadArray.filter { (dic) -> Bool in
            let b = dic["team"] as? String ?? ""
            if !b.isEmpty,  b == self.teamBNameVariable{
                return true
            }
            return false
        }
        let teamBMaxPlayersIdsArray = teamBMaxPlayersArray.map { (dic) -> Int in
            return dic["player_id"] as? Int ?? 0
        }
        return teamBMaxPlayersIdsArray.contains(playerID)
    }
    
    func isPlayerAlreadyAdded(_ playerID:Int)->Bool{
        let totalSelectedPlayers = selectedBowlerArray + selectWikerKeeper + alrounderArray + selectBatsman
        return totalSelectedPlayers.contains(playerID)
    }
    
    func getTotalTeamACount()->Int{
        let totalSelectedPlayers = selectedBowlerArray + selectWikerKeeper + alrounderArray + selectBatsman
        let teamAMaxPlayersArray = squadArray.filter { (dic) -> Bool in
            let a = dic["team"] as? String ?? ""
            if !a.isEmpty,  a == self.teamANameVariable{
                return true
            }
            return false
        }
        let teamAMaxPlayersIdsArray = teamAMaxPlayersArray.map { (dic) -> Int in
            return dic["player_id"] as? Int ?? 0
        }
        var teamACount = 0
        for id in totalSelectedPlayers{
            if teamAMaxPlayersIdsArray.contains(id){
                teamACount += 1
            }
        }
        return teamACount
    }
    
    func getTotalTeamBCount()->Int{
        let totalSelectedPlayers = selectedBowlerArray + selectWikerKeeper + alrounderArray + selectBatsman
        let teamBMaxPlayersArray = squadArray.filter { (dic) -> Bool in
            let b = dic["team"] as? String ?? ""
            if !b.isEmpty,  b == self.teamBNameVariable{
                return true
            }
            return false
        }
        let teamBMaxPlayersIdsArray = teamBMaxPlayersArray.map { (dic) -> Int in
            return dic["player_id"] as? Int ?? 0
        }
        var teamBCount = 0
        for id in totalSelectedPlayers{
            if teamBMaxPlayersIdsArray.contains(id){
                teamBCount += 1
            }
        }
        return teamBCount
    }
    
    func selectedPlayer(_ player:[String:Any]) {
        print("SelectedPlayer \(player)")
        let credit = Double(player["credit"] as? String ?? "0") ?? 0.0
        let team = player["team"] as? String
        let player_id = player["player_id"] as? Int ?? 0
        
        print("Teamsssss \(String(describing: team))")
        
        let teamACountTotal = getTotalTeamACount()
        let teamBCountTotal = getTotalTeamBCount()
        
        if !isPlayerAlreadyAdded(player_id),isPlayerFromTeamA(player_id), teamACountTotal >= 7 {
            let alertController = UIAlertController(title: "Alert", message: "Team(\(self.teamANameVariable)) Limit exceeded", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                print("you have pressed the Ok button");
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion:nil)
            return
        }
        if !isPlayerAlreadyAdded(player_id),isPlayerFromTeamB(player_id), teamBCountTotal >= 7 {
            let alertController = UIAlertController(title: "Alert", message: "Team(\(self.teamBNameVariable)) Limit exceeded", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                print("you have pressed the Ok button");
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion:nil)
            return
        }
        
        if !isPlayerAlreadyAdded(player_id),teamACountTotal + teamBCountTotal >= 11 {
            let alertController = UIAlertController(title: "Alert", message: "Players can't be more than 11", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                print("you have pressed the Ok button");
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion:nil)
            return
        }
        
        
        
        
        guard let position = player["position"] as? String else {
            return
        }
        
        if position == "WK" {
            //            if !self.selectWikerKeeper.contains(where: { $0 == index}) {
            if !self.selectWikerKeeper.contains(player_id) {
                if selectWikerKeeper.count < 4 {
                    if isAddAllowed(credit: credit) {
                        self.selectWikerKeeper.append(player_id)
                        self.selectedPayerArray.append(player)
                    }
                    else{
                        return
                    }
                } else {
                    let alertController = UIAlertController(title: "Alert", message: "Wicket Keeper limit exceeded", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                        print("you have pressed the Ok button");
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion:nil)
                    print("Check Wicketkeeper limit")
                    return
                }
                
            } else {
                self.selectWikerKeeper.removeAll(where: {$0 == player_id})
                self.selectedPayerArray.removeAll(where: {($0["player_id"] as? Int ?? 0) == player_id})
                //  self.selectWikerKeeper = self.selectWikerKeeper.removed { $0 == player_id }
                creditLeft += credit
            }
            print("SelectWicketKeeper \(player)")
            self.wicketKeeper.text = "(" + String(self.selectWikerKeeper.count) + ")"
            
        }
        else if position == "BAT" {
            //            if !self.selectBatsman.contains(where: { $0 == index}) {
            if !self.selectBatsman.contains(player_id) {
                if  selectBatsman.count < 6 {
                    if isAddAllowed(credit: credit) {
                        self.selectBatsman.append(player_id)
                        self.selectedPayerArray.append(player)
                    }else{
                        return
                    }
                }else {
                    let alertController = UIAlertController(title: "Alert", message: "Batsman limit exceeded", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                        print("you have pressed the Ok button");
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion:nil)
                    print("Check batsman limit")
                    return
                }
            } else {
                self.selectBatsman.removeAll(where: {$0 == player_id})
                self.selectedPayerArray.removeAll(where: {($0["player_id"] as? Int ?? 0) == player_id})
                // self.selectBatsman = self.selectBatsman.removed { $0 == player_id}
                creditLeft += credit
            }
            print("SelectBatsman \(player)")
            self.batsmanCountLabel.text = "(" + String(selectBatsman.count) + ")"
        }
        else if position == "AR" {
            //            if !self.alrounderArray.contains(where: { $0 == index}) {
            if !self.alrounderArray.contains(player_id) {
                if alrounderArray.count < 4 {
                    if isAddAllowed(credit: credit) {
                        self.alrounderArray.append(player_id)
                        self.selectedPayerArray.append(player)
                    }else{
                        return
                    }
                }else {
                    let alertController = UIAlertController(title: "Alert", message: "Alrounder Keeper limit exceeded", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                        print("you have pressed the Ok button");
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion:nil)
                    return
                }
            } else {
                self.alrounderArray.removeAll(where: {$0 == player_id})
                self.selectedPayerArray.removeAll(where: {($0["player_id"] as? Int ?? 0) == player_id})
                // self.alrounderArray = self.alrounderArray.removed { $0 == player_id}
                creditLeft += credit
            }
            
            print("SelectAlrounder \(player)")
            self.alrounderCountLabel.text = "(" + String(alrounderArray.count) + ")"
        }
        else if position == "BOWL" {
            //            if !self.selectedBowlerArray.contains(where: { $0 == index}) {
            if !self.selectedBowlerArray.contains(player_id) {
                if selectedBowlerArray.count < 6 {
                    if isAddAllowed(credit: credit) {
                        self.selectedBowlerArray.append(player_id)
                        self.selectedPayerArray.append(player)
                    }else{
                        return
                    }
                }else {
                    let alertController = UIAlertController(title: "Alert", message: "Bowler limit exceeded", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                        print("you have pressed the Ok button");
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion:nil)
                    return
                }
            } else {
                self.selectedBowlerArray.removeAll(where: {$0 == player_id})
                self.selectedPayerArray.removeAll(where: {($0["player_id"] as? Int ?? 0) == player_id})
                //                self.selectedBowlerArray = self.selectedBowlerArray.removeAll(where: <#T##(Int) throws -> Bool#>) { $0 == player_id}
                creditLeft += credit
            }
            print("SelectBowler \(player)")
            self.bowlerCountLabel.text = "(" + String(selectedBowlerArray.count) + ")"
        }
        let selectedPlayers = selectedBowlerArray + selectWikerKeeper + alrounderArray + selectBatsman
        print("SelectPlayersss \(selectedPlayers)")
        let selectedCount = selectedPlayers.count
        
        self.totalPlayer = selectedCount
        
        self.totalPlayerCount.text = String(selectedCount) + "/11"
        for level in levelIndicatorView.subviews {
            if level.tag < selectedCount {
                level.backgroundColor = UIColor.green
            } else {
                level.backgroundColor = UIColor.white
            }
        }
        self.teamACount.text = "\(getTotalTeamACount())"
        self.teamBCount.text = "\(getTotalTeamBCount())"
    }
    
    func onCickCell(index: Int) {
        if (index > (self.playerArray.count - 1)){return;}
        let player = self.playerArray[index]
        selectedPlayer(player)
        /*
         print("SelectedPlayer \(player)")
         let credit = Double(player["credit"] as? String ?? "0") ?? 0.0
         let team = player["team"] as? String
         let player_id = player["player_id"] as? Int ?? 0
         
         print("Teamsssss \(String(describing: team))")
         
         let teamACountTotal = getTotalTeamACount()
         let teamBCountTotal = getTotalTeamBCount()
         
         
         
         
         if !isPlayerAlreadyAdded(player_id),isPlayerFromTeamA(player_id), teamACountTotal >= 7 {
         let alertController = UIAlertController(title: "Alert", message: "Team(\(self.teamANameVariable)) Limit exceeded", preferredStyle: .alert)
         let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
         print("you have pressed the Ok button");
         }
         alertController.addAction(okAction)
         self.present(alertController, animated: true, completion:nil)
         return
         }
         if !isPlayerAlreadyAdded(player_id),isPlayerFromTeamB(player_id), teamBCountTotal >= 7 {
         let alertController = UIAlertController(title: "Alert", message: "Team(\(self.teamBNameVariable)) Limit exceeded", preferredStyle: .alert)
         let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
         print("you have pressed the Ok button");
         }
         alertController.addAction(okAction)
         self.present(alertController, animated: true, completion:nil)
         return
         }
         
         if !isPlayerAlreadyAdded(player_id),teamACountTotal + teamBCountTotal >= 11 {
         let alertController = UIAlertController(title: "Alert", message: "Players can't be more than 11", preferredStyle: .alert)
         let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
         print("you have pressed the Ok button");
         }
         alertController.addAction(okAction)
         self.present(alertController, animated: true, completion:nil)
         return
         }
         //        let teamAMaxReached = totalSelectedPlayers.filter({["teama"] == self.teamANameVariable})
         
         /*
          self.teamsArray.append(player)
          for team in self.teamsArray {
          
          let teamAs = team["team"] as? String
          
          if let teamA = teamAs {
          
          if teamAs == "Singhbhum Strickers" {
          let count = teamAs?.count
          self.teamACount.text = String(count!)
          }
          }
          }
          
          for team in self.teamsArray {
          
          let teamB = team["team"] as? String
          
          if teamB == "Ranchi Raiders" {
          
          
          let count = teamB?.count
          self.teamBCount.text = String(count!)
          }
          }
          
          */
         
         
         
         self.selectedPayerArray.append(player)
         guard let position = player["position"] as? String else {
         return
         }
         
         if position == "WK" {
         //            if !self.selectWikerKeeper.contains(where: { $0 == index}) {
         if !self.selectWikerKeeper.contains(player_id) {
         if selectWikerKeeper.count < 4 {
         if isAddAllowed(credit: credit) {
         self.selectWikerKeeper.append(player_id)
         }
         else{
         return
         }
         } else {
         let alertController = UIAlertController(title: "Alert", message: "Wicket Keeper limit exceeded", preferredStyle: .alert)
         let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
         print("you have pressed the Ok button");
         }
         alertController.addAction(okAction)
         self.present(alertController, animated: true, completion:nil)
         print("Check Wicketkeeper limit")
         return
         }
         
         } else {
         self.selectWikerKeeper = self.selectWikerKeeper.removed { $0 == player_id }
         creditLeft += credit
         }
         print("SelectWicketKeeper \(player)")
         self.wicketKeeper.text = "(" + String(self.selectWikerKeeper.count) + ")"
         
         }
         else if position == "BAT" {
         //            if !self.selectBatsman.contains(where: { $0 == index}) {
         if !self.selectBatsman.contains(player_id) {
         if  selectBatsman.count < 6 {
         if isAddAllowed(credit: credit) {
         self.selectBatsman.append(player_id)
         }else{
         return
         }
         }else {
         let alertController = UIAlertController(title: "Alert", message: "Batsman limit exceeded", preferredStyle: .alert)
         let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
         print("you have pressed the Ok button");
         }
         alertController.addAction(okAction)
         self.present(alertController, animated: true, completion:nil)
         print("Check batsman limit")
         return
         }
         } else {
         self.selectBatsman = self.selectBatsman.removed { $0 == player_id}
         creditLeft += credit
         }
         print("SelectBatsman \(player)")
         self.batsmanCountLabel.text = "(" + String(selectBatsman.count) + ")"
         }
         else if position == "AR" {
         //            if !self.alrounderArray.contains(where: { $0 == index}) {
         if !self.alrounderArray.contains(player_id) {
         if alrounderArray.count < 4 {
         if isAddAllowed(credit: credit) {
         self.alrounderArray.append(player_id)
         }else{
         return
         }
         }else {
         let alertController = UIAlertController(title: "Alert", message: "Alrounder Keeper limit exceeded", preferredStyle: .alert)
         let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
         print("you have pressed the Ok button");
         }
         alertController.addAction(okAction)
         self.present(alertController, animated: true, completion:nil)
         return
         }
         } else {
         self.alrounderArray = self.alrounderArray.removed { $0 == player_id}
         creditLeft += credit
         }
         
         print("SelectAlrounder \(player)")
         self.alrounderCountLabel.text = "(" + String(alrounderArray.count) + ")"
         }
         else if position == "BOWL" {
         //            if !self.selectedBowlerArray.contains(where: { $0 == index}) {
         if !self.selectedBowlerArray.contains(player_id) {
         if selectedBowlerArray.count < 4 {
         if isAddAllowed(credit: credit) {
         self.selectedBowlerArray.append(player_id)
         }else{
         return
         }
         }else {
         let alertController = UIAlertController(title: "Alert", message: "Bowler limit exceeded", preferredStyle: .alert)
         let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
         print("you have pressed the Ok button");
         }
         alertController.addAction(okAction)
         self.present(alertController, animated: true, completion:nil)
         return
         }
         } else {
         self.selectedBowlerArray = self.selectedBowlerArray.removed { $0 == player_id}
         creditLeft += credit
         }
         print("SelectBowler \(player)")
         self.bowlerCountLabel.text = "(" + String(selectedBowlerArray.count) + ")"
         }
         let selectedPlayers = selectedBowlerArray + selectWikerKeeper + alrounderArray + selectBatsman
         print("SelectPlayersss \(selectedPlayers)")
         let selectedCount = selectedPlayers.count
         
         self.totalPlayer = selectedCount
         
         self.totalPlayerCount.text = String(selectedCount) + "/11"
         for level in levelIndicatorView.subviews {
         if level.tag < selectedCount {
         level.backgroundColor = UIColor.green
         } else {
         level.backgroundColor = UIColor.white
         }
         }
         self.teamACount.text = "\(getTotalTeamACount())"
         self.teamBCount.text = "\(getTotalTeamBCount())"
         */
        self.tableView.reloadData()
        
        
    }
}

public extension Array {
    func removed(where predicate: (Element) throws -> Bool) rethrows -> [Element] {
        var copy = self
        if let index = try copy.index(where: predicate) {
            copy.remove(at: index)
        }
        return copy
    }
}

