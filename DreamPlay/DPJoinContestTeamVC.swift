//
//  DPJoinContestTeamVC.swift
//  DreamPlay
//
//  Created by MAC on 15/07/21.
//

import UIKit
import Alamofire
import SVProgressHUD
import SideMenu
import SDWebImage

class DPJoinContestTeamVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var responseDictionary:[String:Any] = [:]
    var dataDictionary:[String:Any] = [:]
    var userTeam:[[String:Any]] = []
    var fixtureId: Any? = UserDefaults.standard.object(forKey:"FixtureId") as Any?
    var fixtureid:String?
    var vicecaptainID: Int?
    var captainID:Int?
    var getContestArray:[[String:Any]] = []
    var fixtureIdssss:Int?
    var fixture:String?
    var contestId:Int?
    var teamId:Int?
    var teamIds:[Int] = []
    var message:String?
    var token:String?
    var isOpen = false
    var screenCheck = false
    var userDictionary:[String:Any] = [:]
    var walletView : UIView!
    var walletlabel : UILabel!
    var sideMenu:SideMenuNavigationController?
    var joinContestDictionary:[String:Any] = [:]
    var contestid:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupMenu()
        self.setupWalletView()
        
        token = UserDefaults.standard.string(forKey:"AccessToken")!
        print("Token :", token as Any)
        print("FixtureIdTeam", fixtureId as Any)
        print("JoinContestDictionary",joinContestDictionary)
        let fixture = self.joinContestDictionary["fixture_id"] as? Int
        print("Fixturesss",fixture)
       
        if let id = fixture as? Int {
            self.fixtureId = String(id)
        }
        self.getContest()
        
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "Background"))
        
        self.tableView.rowHeight = 120.0
        let logo = UIImage(named: "layer3")
        let imageView = UIImageView(image:logo)
        imageView.frame = CGRect(x: 150, y: 20, width: 100.0, height: 30.0)
        self.navigationItem.titleView = imageView
        
       
        
        
        
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        else{
        
        if let id = self.fixtureId as? String {
            print("Idssss \(id)")

        SVProgressHUD.show()
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
                                        
//                                        let dict = self.userTeam.first
//                                        self.teamId = dict?["id"] as? Int
//                                        print("TeamID\(String(describing: self.teamId))")
                                        
                                        
                                        
                                        self.tableView.reloadData()
                                    }
                                }
                            }
                        }
                       }
        }
                       
    }
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.walletAmount()
//       navigationController?.setNavigationBarHidden(true, animated: true)
        
       
//        userImg.image = UIImage(data:Data(contentsOf: URL(string: Helper.getUserDetails()?.i ?? "First name" )))
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
    
    func getContest(){
        
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        else{
        
        if let id = self.fixtureId as? String {
            print("contestIdsss \(id)")
        SVProgressHUD.show()
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data","Authorization":"Bearer" + " " + token!,"X-Requested-With":"XMLHttpRequest"]
        let url = Constants.BaseUrl + "contests?fixture_id=" + id
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
//                                        self.contestId = dict?["id"] as? Int
//                                        print("ContestID\(String(describing: self.contestId))")
//                                        if let id = self.contestId as? Int {
//                                            self.contestid = String(id)
//                                        }

                                        
                                        
                                        
                                        self.tableView.reloadData()
                                    }
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
    
    
    
    @IBAction func joinContestTapped(_ sender: Any) {
        
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        else{
            
            if let apiString = URL(string:Constants.BaseUrl + "user_contests") {
                var request = URLRequest(url:apiString)
                request.httpMethod = "POST"
                request.setValue("application/json",
                                 forHTTPHeaderField: "Content-Type")
                request.setValue("X-Requested-With",
                                 forHTTPHeaderField:"XMLHttpRequest")
                request.setValue("Bearer" + " " + token!, forHTTPHeaderField: "Authorization")
                
                let values = [
                    "user_team_id": teamIds,//[self.teamId!],
                    "contest_id":self.contestId!] as [String : Any]
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
                                print("response \(responseString)")
                            }
                        case .success(let responseObject):
                            DispatchQueue.main.async {
                                
                                print("This is run on the main queue, after the previous code in outer block")
                            }
                            print("response \(responseObject)")
                            
                            self.responseDictionary = responseObject as! [String:Any]
                            let success:Int = self.responseDictionary["status"] as? Int ?? 0
                            
                            if success == 1{
                                print("Success")
                            }
                            else{
                                print("Error")
                            }
                            
                            self.message = self.responseDictionary["message"] as? String
                            let alertController = UIAlertController(title: "Alert", message:self.message, preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                                self.navigationController?.popViewController(animated: true)
                                //                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                //                            let menuVC  = storyboard.instantiateViewController(withIdentifier: "DPHomePageVC") as? DPHomePageVC
                                //
                                //
                                //                            self.navigationController?.pushViewController(menuVC!, animated: true)
                                print("you have pressed the Ok button");
                            }
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true, completion:nil)
                        }
                        
                    }
                
                
            }
        }
        
        
    }
    }

extension DPJoinContestTeamVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userTeam.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? JoinContestCell
        let dictionary = self.userTeam[indexPath.row]
        print("Dictionarysss \(dictionary)")
        if let wicketKeeper = dictionary["wicket_keeper"] as? Int {
            cell?.wicketKeeperCount.text = String(wicketKeeper)
        }
        if let batsman = dictionary["batsmen"] as? Int {
            cell?.batsmanCount.text = String(batsman)
        }
        if let alrounder = dictionary["all_rounders"] as? Int {
            cell?.alrounderCount.text = String(alrounder)
        }
        if let bowler = dictionary["bowlers"] as? Int {
            cell?.bowlerCount.text = String(bowler)
        }
        if let teamaDictionary = dictionary["teama"] as? [String:Any] {
            if let teamName = teamaDictionary["name"] as? String {
                cell?.teamAName.text = String(teamName)
            }
        }
        if let teambDictionary = dictionary["teamb"] as? [String:Any] {
            if let teamName = teambDictionary["name"] as? String {
                cell?.teamBName.text = String(teamName)
            }
        }
        if let teamaDictionary = dictionary["teama"] as? [String:Any] {
            if let count = teamaDictionary["count"] as? Int {
                cell?.teamACount.text = String(count)
            }
        }
        if let teambDictionary = dictionary["teamb"] as? [String:Any] {
            if let count = teambDictionary["count"] as? Int {
                cell?.teamBCount.text = String(count)
            }
        }
        if let captainDictionary = dictionary["captain"] as? [String:Any] {
            print("CaptainDictionary \(String(describing: captainDictionary))")
            cell?.captainName.text = captainDictionary["name"] as? String
        }
        if  let viceCaptainDictionary = dictionary["vice_captain"] as? [String:Any]{
            print("ViceCaptainDictionary \(String(describing: viceCaptainDictionary))")
            cell?.viceCaptainName.text = viceCaptainDictionary["name"] as? String
        }
        cell?.borderView.layer.cornerRadius = 8
        cell?.borderView.layer.borderWidth = 1
        cell?.borderView.layer.borderColor = UIColor.clear.cgColor
        cell?.cellDelegate = self
        cell?.index = indexPath
        return cell!
    }
}
    
    extension DPJoinContestTeamVC:TableViewContest{
        
        
        func onCickCell(index: Int) {
            
            if let jointContestDictionary = self.userTeam[index] as? [String : Any]{
                print("JointContestDictionary \(String(describing:jointContestDictionary))")
                if let team_id = jointContestDictionary ["id"] as? Int{
                    if teamIds.contains(team_id){
                        teamIds.removeAll(where: {$0 == team_id})
                    }
                    else{
                        teamIds.append(team_id)
                    }
                }
            }
//            if let id = jointContestDictionary["fixture_id"] as? Int{
//                self.fixture = String(id)
//            }
            
//            let viceCaptain = jointContestDictionary["vice_captain"] as? [String:Any]
//            self.vicecaptainID = viceCaptain?["team_id"] as? Int
//            let captain = jointContestDictionary["captain"] as? [String:Any]
//            self.captainID = captain?["team_id"] as? Int
//            self.getContest()

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




