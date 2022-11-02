//
//  DPPrizeBreakupController.swift
//  DreamPlay
//
//  Created by MAC on 21/06/21.
//

import UIKit
import Alamofire
import SVProgressHUD
import SideMenu
import KSToastView

class DPPrizeBreakupController: UIViewController {
    @IBOutlet weak var topTableView: UITableView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomTableView: UITableView!
    var topData : [String] = []
    var downData = [String]()
    var isOpen = false
    @IBOutlet weak var teamAName: UILabel!
    @IBOutlet weak var teamBName: UILabel!
    var screenCheck = false
    var prizeDictionary:[String:Any] = [:]
    var fixtureId:Int?
    var token:String?
    var prizeCellDictionary:[String:Any] = [:]
    var prizeArray:[[String:Any]] = []
    var walletView : UIView!
       // var walletlabel : UILabel!
    var responseDictionary:[String:Any] = [:]
    var dataDictionary:[String:Any] = [:]
    var userDictionary:[String:Any] = [:]
    var sideMenu:SideMenuNavigationController?
    var contestDictionary:[String:Any] = [:]
    var defaultImage:UIImage?
    var matchStatus:String?
    var fixtureid:String?
    var contestCategoryid :String?
    var contestArrayData: [String: Any] = [:]
    var userTeam:[[String:Any]] = []
    var contestArray:[[String:Any]] = []
    var flags:Int?
    var walletAmounts:NSNumber = 0
    var headerController = ""
    @IBOutlet weak var teamAImageView: UIImageView!
    @IBOutlet weak var teamBImageView: UIImageView!
    @IBOutlet weak var lblWallet: UILabel!
    
    @IBOutlet weak var viewHeader: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupWalletView()
        self.setupMenu()
        contestDictionary = UserDefaults.standard.object(forKey:"ContestDictionary") as? [String:Any] ?? [:]
        self.fixtureId = self.contestDictionary["id"] as? Int
        self.matchStatus = contestDictionary["status"] as? String
        
      //  prizeCellDictionary = UserDefaults.standard.object(forKey:"PrizeBreakUPDictionary") as? [String:Any] ?? [:]
        
        self.topTableView.rowHeight = 148.0
        self.bottomTableView.rowHeight = 60.0
        topView.layer.cornerRadius = 8
        topView.layer.borderWidth = 1
        topView.layer.borderColor = UIColor.clear.cgColor
        let logo = UIImage(named:"layer3")
        let imageView = UIImageView(image:logo)
        imageView.frame = CGRect(x: 150, y: 20, width: 100.0, height: 30.0)
        self.navigationItem.titleView = imageView
        
        self.topTableView.backgroundView = UIImageView(image: UIImage(named: "Background"))
        self.teamAName.text = self.prizeDictionary["teama"] as? String
        self.teamBName.text = self.prizeDictionary["teamb"] as? String
        //  self.fixtureId = self.prizeDictionary["id"] as? Int
        token = UserDefaults.standard.string(forKey:"AccessToken")!
        print("Token :", token as Any)
        navigationController?.isNavigationBarHidden = true

//        if headerController == "Navigation"{
//            viewHeader.isHidden = true
//        }else{
//            viewHeader.isHidden = false
//        }
        if let id = self.fixtureId   {
            self.fixtureid = String(id)
            print("Fixtureid :",fixtureid)
        }
        // print("PrizeDictionary :", prizeDictionary)
        print("PrizeCellDictionary :", prizeCellDictionary)
        
        self.getContest()
        // self.getContests()
        
        self.walletAmount()
        self.downloadImage(from: URL(string:"https://cricket.entitysport.com/assets/uploads/2021/05/team-120x120.png")!)
        
       
        
        self.bottomTableView.reloadData()
        
        if let teamA = self.contestDictionary["teama"] as? String {
            teamAName.text = teamA
        }
        if let teamB = self.contestDictionary["teamb"] as? String {
            teamBName.text = teamB
        }
        
        if let imageUrl = self.contestDictionary["teama_image"] as? String,
           !imageUrl.isEmpty, let imgURl =  URL(string:imageUrl) {
            self.teamAImageView.sd_setImage(with: imgURl,placeholderImage: self.defaultImage, completed: nil)
            
        }
        if let imageUrl1 = self.contestDictionary["teamb_image"] as? String,
           !imageUrl1.isEmpty, let imgURl1 =  URL(string:imageUrl1) {
            self.teamBImageView.sd_setImage(with: imgURl1,placeholderImage: self.defaultImage, completed: nil)
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let myArray = self.contestArrayData["prize_breakup"] as? [[String:Any]] {
            self.prizeArray = myArray
        }
    }
    
    @IBAction func btnWalletClick(_ sender: UIButton){
        let menuVC  = storyboard?.instantiateViewController(withIdentifier: "DPWalletVC") as? DPWalletVC
        self.navigationController?.pushViewController(menuVC!, animated:true)
    }
    @IBAction func btnMenu(_ sender: UIButton){
       // viewHeader.isHidden = true
        present(sideMenu!, animated: true, completion: nil)
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
       // walletlabel = UILabel.init(frame: CGRect.init(x: 0, y: imageView.frame.maxY + 3, width: walletView.frame.width, height: 10))
//        walletlabel.textColor = .white
//        walletlabel.font = UIFont.systemFont(ofSize: 11)
//        walletlabel.text = " "
//        walletlabel.textAlignment = .center
//        walletView.addSubview(walletlabel)
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(DPPrizeBreakupController.handleTap(_:)))
      
      walletView.addGestureRecognizer(tap1)

        let btn = UIBarButtonItem.init(customView: walletView)
        self.navigationItem.rightBarButtonItem = btn
        
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let menuVC  = storyboard?.instantiateViewController(withIdentifier: "DPWalletVC") as? DPWalletVC
        
        
        self.navigationController?.pushViewController(menuVC!, animated:true)

    }
    func getContests(){
        
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
        SVProgressHUD.show()
            if let id = self.fixtureid {
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data","Authorization":"Bearer" + " " + token!,"X-Requested-With":"XMLHttpRequest"]


           AF.upload(
                       multipartFormData: { multipartFormData in
                       
                        
                   },
                    to: Constants.BaseUrl + "contests?fixture_id=" + id, method: .get , headers: headers)
                       .responseJSON { response in
                           self.printApiUrlAndParametre(urls: URL(string: Constants.BaseUrl + "contests?fixture_id=\(id)"), params: nil)
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
            if let id = self.fixtureid {
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
                        //                                 self.walletAmounts = amount
                        //                                    self.walletlabel.text = "₹" + String(amount)
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

    @IBAction func toggleButtonTapped(_ sender: Any) {
        present(sideMenu!, animated: true, completion: nil)
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
    @IBAction func leaderboradButtonTapped(_ sender: Any) {
        
        let menuVC  = storyboard?.instantiateViewController(withIdentifier: "DPLeaderBoardVC") as? DPLeaderBoardVC
        
       // menuVC?.leaderDictionary = prizeCellDictionary
        menuVC?.contestArrayData = contestArrayData
        menuVC?.prizeCellDictionary = prizeCellDictionary
        menuVC?.headerStatus = "NavigationShow"
        self.navigationController?.pushViewController(menuVC!, animated: false)

    }
}


extension DPPrizeBreakupController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRow = 1
        switch tableView {
        case topTableView:
            numberOfRow = 1 //self.contestArray.count
        case bottomTableView:
            numberOfRow = self.prizeArray.count//downData.count
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
            let dictionary =  contestArrayData //self.contestArray[indexPath.row] //
            
            print("dictionaryNew \(dictionary)")
            
            
            
            if let button = cell.viewWithTag(200) as? UIButton {
                if self.matchStatus == "LIVE" || self.matchStatus == "COMPLETED" || self.matchStatus == "IN REVIEW"{
                    button.backgroundColor = UIColor.lightGray
                }
                button.tag = indexPath.row
                button.makeCornerRadius(5)
                button.addTarget(self, action: #selector(DPPrizeBreakupController.buttonClicked), for: UIControl.Event.touchUpInside)
                if let fee = dictionary["entry_fee"] as? Int {
                    let entry = "₹" + String(fee)
                    button.setTitle(entry, for: UIControl.State.normal)
                }
            }
            
            if let teamAIcon = cell.viewWithTag(40) as? UIImageView {
                
                if let imageUrl = self.contestDictionary["teama_image"] as? String, let  url = URL(string:imageUrl){
                    print("UserURLImage \(url)")
                    if let data = try? Data(contentsOf: url)  {
                        teamAIcon.image = UIImage(data: data)
                        //teamAIcon.contentMode = .scaleAspectFill
                    }
                }
            }
            
            if let teamBIcon = cell.viewWithTag(50) as? UIImageView {
                
                if let imageUrl = self.contestDictionary["teamb_image"] as? String, let  url = URL(string:imageUrl){
                    print("UserURLImage \(url)")
                    if let data = try? Data(contentsOf: url)  {
                        teamBIcon.image = UIImage(data: data)
                        //teamBIcon.contentMode = .scaleAspectFill
                    }
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
                    
                    if let maxTeam = dictionary["joined"] as? Int{
                        print("Joined \(String(describing:maxTeam))")
                        let max = String(maxTeam)
                        let value =  max + "/" + totalTeams //totalTeams//
                        
                        totalTeam.text =  value
                    }
                    
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
            
            
            
            /*if let totalTeam = cell.viewWithTag(60) as? UILabel {
             if let total = dictionary["total_teams"] as? Int {
             if let maxTeam = dictionary["joined"] as? Int{
             print("Joined \(String(describing:maxTeam))")
             let sum = total - maxTeam
             
             totalTeam.text =  String(sum) + " " + "Seats" + " " + "Left"
             }
             
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
            //
            //                    entryFee.text = "₹" + String(fee)
            //                }
            //
            //             }
            if let gameType = cell.viewWithTag(90) as? UILabel {
                gameType.text = dictionary["type"] as? String
            }
            
            
            //  cell.leftSeat.text = String(total) + " " + "Total" + " " + "Seats"
            //  cell.leftSeats.text = String(sum) + " " + "Seats" + " " + "Left"
            // cell.winnerLabel.text = value
            
            
            // cell?.leftSeat.text =
            // cell.leftSeats.text = String(sum) + " " + "Seats" + " " + "Left"
            // cell.winnerLabel.text = value
            
            // cell.textLabel?.text = "A"//topData[indexPath.row]
            // cell.backgroundColor = UIColor.green
            
        case bottomTableView:
            cell = tableView.dequeueReusableCell(withIdentifier: "bottomCell", for: indexPath)
            let dictionary = self.prizeArray[indexPath.row]
            if let fromLabel = cell.viewWithTag(10) as? UILabel {
                if let from = dictionary["from"] as? String {
                    fromLabel.text = String(from)
                }
            }
            /* if let toLabel = cell.viewWithTag(30) as? UILabel {
             if let to = dictionary["to"] as? String {
             toLabel.text = to
             }
             }
             */
            
            if let prizeLabel = cell.viewWithTag(20) as? UILabel {
                prizeLabel.text = "₹" + " " + (dictionary["prize"]as? String)! + " " + "Cash"
            }
            
            print("dictionaryssss \(dictionary)")
            //   cell.textLabel?.text = "B"//downData[indexPath.row]
            // cell.backgroundColor = UIColor.yellow
        default:
            print("Some things Wrong!!")
        }
    
    return cell
}

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc func buttonClicked(sender : UIButton!) {
        if self.matchStatus == "LIVE" || self.matchStatus == "COMPLETED" || self.matchStatus == "IN REVIEW" {
           print("Ankit")
            return;
        }
        let index = sender.tag
        let dictionary = contestArrayData //self.contestArray[index]
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
    
    @objc func buttonClicked2(sender : UIButton!) {
        
        print("WalletAmountss \(self.walletAmounts)")
        
        if self.matchStatus == "LIVE" || self.matchStatus == "COMPLETED" {
            
           print("Ankit")
            
        }
        else if self.walletAmounts.intValue < 100  {
            KSToastView.ks_showToast("Insufficient Balance", duration: 4.0) {
                      // KSToastView.ks_showToast("Game Over!", delay: 0.5)
            }
        }
        else if self.walletAmounts.intValue >= 100 {
            self.checkAvailableTeam(0)
        print("Added!")
        }


    }

}
