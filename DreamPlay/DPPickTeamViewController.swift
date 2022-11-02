//
//  DPPickTeamViewController.swift
//  DreamPlay
//
//  Created by MAC on 21/06/21.
//

import UIKit
import Alamofire
import SVProgressHUD

class DPPickTeamViewController: UIViewController {
    
    let fixtureId: Any? = UserDefaults.standard.object(forKey:"FixtureId") as Any?
    @IBOutlet weak var topView: UIView!
    var isOpen = false
    var screenCheck = false
    var pickTeamDictionary:[String:Any] = [:]
    @IBOutlet weak var creditAmount: UILabel!
    @IBOutlet weak var playerName3: UILabel!
    @IBOutlet weak var playerCredit5: UILabel!
    @IBOutlet weak var playerCredit3: UILabel!
    @IBOutlet weak var playerName4: UILabel!
    @IBOutlet weak var playerName6: UILabel!
    @IBOutlet weak var playerName8: UILabel!
    @IBOutlet weak var playerCredit10: UILabel!
    @IBOutlet weak var playerCredit11: UILabel!
    @IBOutlet weak var playerName11: UILabel!
    @IBOutlet weak var playerName10: UILabel!
    @IBOutlet weak var playerName9: UILabel!
    @IBOutlet weak var playerCredit9: UILabel!
    @IBOutlet weak var playerName7: UILabel!
    @IBOutlet weak var playerCredit6: UILabel!
    @IBOutlet weak var playerCredit8: UILabel!
    @IBOutlet weak var playerCredit7: UILabel!
    
    @IBOutlet weak var teamBCount: UILabel!
    @IBOutlet weak var teamACount: UILabel!
    @IBOutlet weak var team2Name: UILabel!
    @IBOutlet weak var team1Name: UILabel!
    @IBOutlet weak var team2ImageView: UIImageView!
    @IBOutlet weak var team1ImageView: UIImageView!
    @IBOutlet weak var playerName5: UILabel!
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var playerCredit4: UILabel!
    @IBOutlet weak var playerCredit2: UILabel!
    @IBOutlet weak var playerName2: UILabel!
    var responseDictionary:[String:Any] = [:]
    var dataDictionary:[String:Any] = [:]
    var fixtureDictionary:[String:Any] = [:]
    var playerArray:[[String:Any]] = []
    var previewDictionary:[String:Any] = [:]
    var captainDictionary:[String:Any] = [:]
    var viceCaptainDictionary:[String:Any] = [:]
    @IBOutlet weak var playerCredit1: UILabel!
    @IBOutlet weak var playName1: UILabel!
    @IBOutlet var buttonPlayers: [UIButton]!
    @IBOutlet var imagePlayers: [UIImageView]!
    
    @IBOutlet var labelUserName: UILabel!
    
    @IBOutlet weak var lblWallet: UILabel!
    
    var playerList:[[String:Any]] = []
    var token:String?
    var topViewDictionary:[String:Any] = [:]
    var finalArray:[[String:Any]] = []
   
    var walletView : UIView!
    var walletlabel : UILabel!
    var userDictionary:[String:Any] = [:]
    var flag:Int?
    var captainName:String?
    var captainCredit:String?
    var viceCaptainName:String?
    var viceCaptainCredit:String?
    var captainId:Int?
    var viceCaptainId:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.playerList.removeAll()
        self.setupWalletView()
        let logo = UIImage(named:"layer3")
        let imageView = UIImageView(image:logo)
        imageView.frame = CGRect(x: 150, y: 20, width: 100.0, height: 30.0)
        self.navigationItem.titleView = imageView
        
        topView.layer.cornerRadius = 8
        topView.layer.borderWidth = 1
        topView.layer.borderColor = UIColor.clear.cgColor
        self.tabBarController?.tabBar.isHidden = true
        print("TopViewDictionary\(String(describing:topViewDictionary))")
        token = UserDefaults.standard.string(forKey:"AccessToken")!
        print("PickTeamDictionary\(String(describing:pickTeamDictionary))")
        print("Token :", token as Any)
      //  labelUserName.text = kUserDefaults.getUserTeamName()
        if let dict = pickTeamDictionary["captain"] as? [String:Any] {
            
            self.captainDictionary = dict
            print("CaptainDictionary\(String(describing:self.captainDictionary))")
        }
        self.captainName = self.captainDictionary["name"] as? String
        self.captainCredit = self.captainDictionary["credit"] as? String
        self.captainId = self.captainDictionary["player_id"] as? Int
        
        if let dict = pickTeamDictionary["vice_captain"] as? [String:Any] {
            self.viceCaptainDictionary = dict
            print("ViceCaptainDictionary\(String(describing:self.viceCaptainDictionary))")
        }
        
        self.viceCaptainName = self.viceCaptainDictionary["name"] as? String
        self.viceCaptainCredit = self.viceCaptainDictionary["credit"] as? String
        self.viceCaptainId = self.viceCaptainDictionary["player_id"] as? Int
        
        if self.flag == 2 {
            
        }
        else{
            let teamADict = self.pickTeamDictionary["teama"] as? [String:Any]
            if let count = teamADict?["count"] as? Int {
                self.teamACount.text = String(count)
                print("TeamADict \(String(describing: teamADict))")
            }
            
            let teamBDict = self.pickTeamDictionary["teamb"] as? [String:Any]
            print("TeamBDict \(String(describing: teamBDict))")
            if let count = teamBDict?["count"] as? Int {
                self.teamBCount.text = String(count)
            }
            
            if let imageUrl = teamADict?["image"] as? String, let  url = URL(string:imageUrl){
                print("UserURLImage \(url)")
                if let data = try? Data(contentsOf: url)  {
                    team1ImageView.image = UIImage(data: data)
                    //teamAIcon.contentMode = .scaleAspectFill
                }
            }
            
            self.team1Name.text = teamADict?["name"] as? String
            self.team2Name.text = teamBDict?["name"] as? String
            
            if let imageUrl1 = teamBDict?["image"] as? String, let  url1 = URL(string:imageUrl1){
                print("UserURLImage \(url1)")
                if let data = try? Data(contentsOf: url1)  {
                    team2ImageView.image = UIImage(data: data)
                    //teamBIcon.contentMode = .scaleAspectFill
                }
                
            }
            if let myArray = pickTeamDictionary["players"] as? [[String:Any]] {
                self.playerArray = myArray
                print("PlayerArray \(String(describing:self.playerArray))")
            }
            for player in self.playerArray {
                if (player["player_id"] as? Int != self.captainId) && (player["player_id"] as? Int != self.viceCaptainId){
                    self.playerList.append(player)
                }
                print("PlayerLists \(String(describing:self.playerList))")
                let count = self.playerList.count
                print("Count \(String(describing:count))")
            }
            let dict1 = self.playerList.first
            self.playName1.text = self.captainName
            self.playerCredit1.text = self.captainCredit
            
            let dict2 = self.playerList[1]
            self.playerName2.text = self.viceCaptainName
            self.playerCredit2.text = self.viceCaptainCredit
            
            let dict3 = self.playerList.first
            self.playerName3.text = dict3?["name"] as? String
            self.playerCredit3.text = dict3?["credit"] as? String
            
            let dict4 = self.playerList[1]
            self.playerName4.text = dict4["name"] as? String
            self.playerCredit4.text = dict4["credit"] as? String
            
            let dict5 = self.playerList[2]
            self.playerName5.text = dict5["name"] as? String
            self.playerCredit5.text = dict5["credit"] as? String
            
            let dict6 = self.playerList[3]
            self.playerName6.text = dict6["name"] as? String
            self.playerCredit6.text = dict6["credit"] as? String
            
            let dict7 = self.playerList[4]
            self.playerName7.text = dict7["name"] as? String
            self.playerCredit7.text = dict7["credit"] as? String
            
            let dict8 = self.playerList[5]
            self.playerName8.text = dict8["name"] as? String
            self.playerCredit8.text = dict8["credit"] as? String
            
            let dict9 = self.playerList[6]
            self.playerName9.text = dict9["name"] as? String
            self.playerCredit9.text = dict9["credit"] as? String
            
            let dict10 = self.playerList[7]
            self.playerName10.text = dict10["name"] as? String
            self.playerCredit10.text = dict10["credit"] as? String
            
            let dict11 = self.playerList[8]
            self.playerName11.text = dict11["name"] as? String
            self.playerCredit11.text = dict11["credit"] as? String

//            let teams1 = teamADict?["name"] as? String
//           // let teams2 = teamBDict?["name"] as? String
//            if teams1 == getFirstCharFromStr(str: dict1?["team"] as? String ?? "") {
//                self.playName1.backgroundColor = .black
//            } else {
//                self.playName1.backgroundColor = .white
//                self.playName1.textColor = .black
//            }
//
//            if teams1 == getFirstCharFromStr(str: dict2["team"] as? String ?? "") {
//                self.playerName2.backgroundColor = .black
//            } else {
//                self.playerName2.backgroundColor = .white
//                self.playerName2.textColor = .black
//            }
//
//            if teams1 == getFirstCharFromStr(str: dict3?["team"] as? String ?? "") {
//                self.playerName3.backgroundColor = .black
//            } else {
//                self.playerName3.backgroundColor = .white
//                self.playerName3.textColor = .black
//            }
//
//            if teams1 == getFirstCharFromStr(str: dict4["team"] as? String ?? "") {
//                self.playerName4.backgroundColor = .black
//            } else {
//                self.playerName4.backgroundColor = .white
//                self.playerName4.textColor = .black
//            }
//
//            if teams1 == getFirstCharFromStr(str: dict5["team"] as? String ?? "") {
//                self.playerName5.backgroundColor = .black
//            } else {
//                self.playerName5.backgroundColor = .white
//                self.playerName5.textColor = .black
//            }
//
//            if teams1 == getFirstCharFromStr(str: dict6["team"] as? String ?? "") {
//                self.playerName6.backgroundColor = .black
//            } else {
//                self.playerName6.backgroundColor = .white
//                self.playerName6.textColor = .black
//            }
//
//            if teams1 == getFirstCharFromStr(str: dict7["team"] as? String ?? "") {
//                self.playerName7.backgroundColor = .black
//            } else {
//                self.playerName7.backgroundColor = .white
//                self.playerName2.textColor = .black
//            }
//            if teams1 == getFirstCharFromStr(str: dict8["team"] as? String ?? "") {
//                self.playerName8.backgroundColor = .black
//            } else {
//                self.playerName8.backgroundColor = .white
//                self.playerName8.textColor = .black
//            }
//            if teams1 == getFirstCharFromStr(str: dict9["team"] as? String ?? "") {
//                self.playerName9.backgroundColor = .black
//            } else {
//                self.playerName9.backgroundColor = .white
//                self.playerName9.textColor = .black
//            }
//            if teams1 == getFirstCharFromStr(str: dict10["team"] as? String ?? "") {
//                self.playerName10.backgroundColor = .black
//            } else {
//                self.playerName10.backgroundColor = .white
//                self.playerName10.textColor = .black
//            }
//            if teams1 == getFirstCharFromStr(str: dict11["team"] as? String ?? "") {
//                self.playerName11.backgroundColor = .black
//            } else {
//                self.playerName11.backgroundColor = .white
//                self.playerName11.textColor = .black
//            }
       }

        
        setUpPlayerImage()
        // Do any additional setup after loading the view.
    }
    
    func getFirstCharFromStr(str: String) -> String {
        return str.components(separatedBy: " ").map { String($0.prefix(1))}.joined()
    }

    
    func setUpPlayerImage() {
//        for (index, buttons) in buttonPlayers.enumerated() {
//            buttons.tag = index
//            buttons.makeCornerRadius(buttons.frame.size.height / 2)
//        }
        for (index, images) in imagePlayers.enumerated() {
            images.tag = index
            images.makeCornerRadius(images.frame.size.height / 2)
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
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(DPTeamHistoryVC.handleTap(_:)))
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
    @IBAction func btnBack(_ sender: UIButton){
       // viewHeader.isHidden = true
        self.dismiss(animated: true)
       // present(sideMenu!, animated: true, completion: nil)
        //self.navigationController?.popViewController(animated: true)
    }
//    @IBAction func btnWalletClick(_ sender: UIButton){
//        let menuVC  = storyboard?.instantiateViewController(withIdentifier: "DPWalletVC") as? DPWalletVC
//        self.navigationController?.pushViewController(menuVC!, animated:true)
//    }
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
            to: Constants.BaseUrl + "me", method: .get , headers: headers).responseJSON { response in
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
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.walletAmount()
    //       navigationController?.setNavigationBarHidden(true, animated: true)
        
       
    //        userImg.image = UIImage(data:Data(contentsOf: URL(string: Helper.getUserDetails()?.i ?? "First name" )))
    }
    
    @IBAction func toggleButtonTapped(_ sender: Any) {
      
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


}
