//
//  DPTeamHistoryVC.swift
//  DreamPlay
//
//  Created by MAC on 19/07/21.
//

import UIKit
import Alamofire
import SVProgressHUD
import SideMenu

class DPTeamHistoryVC: UIViewController {
    var isOpen = false
    var screenCheck = false
    var userTeam:[[String:Any]] = []
    var token:String?
    var sideMenu:SideMenuNavigationController?
    var walletView : UIView!
    var walletlabel : UILabel!
    var userDictionary:[String:Any] = [:]
    var winningAmount:Int?
    var defaultImage:UIImage?
    
    @IBOutlet weak var dataNotAvailableLabel: UILabel!
    @IBOutlet weak var labelTeamNumber: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblWallet: UILabel!
    
    var responseDictionary:[String:Any] = [:]
    var dataDictionary:[String:Any] = [:]
    let fixtureId: Any? = UserDefaults.standard.object(forKey:"FixtureId") as Any?
    let flag: Any? = UserDefaults.standard.object(forKey:"Flag") as Any?
    var fixtureid:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataNotAvailableLabel.isHidden = true
        setupMenu()
        
        self.setupWalletView()
        self.tableView.rowHeight = 254.0
        
        let logo = UIImage(named:"layer3")
        let imageView = UIImageView(image:logo)
        imageView.frame = CGRect(x: 150, y: 20, width: 100.0, height: 30.0)
        self.navigationItem.titleView = imageView
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "Background"))
        token = UserDefaults.standard.string(forKey:"AccessToken")!
        print("Token :", token as Any)
        
        token = UserDefaults.standard.string(forKey:"AccessToken")!
        
    }
    
    @IBAction func btnMenu(_ sender: UIButton){
       // viewHeader.isHidden = true
        present(sideMenu!, animated: true, completion: nil)
    }
    
    @IBAction func btnWalletClick(_ sender: UIButton){
        let menuVC  = storyboard?.instantiateViewController(withIdentifier: "DPWalletVC") as? DPWalletVC
        self.navigationController?.pushViewController(menuVC!, animated:true)
    }
    
    func getTeamsHistory() {
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            SVProgressHUD.show()
            let headers: HTTPHeaders = ["Content-type": "multipart/form-data","Authorization":"Bearer" + " " + token!,"X-Requested-With":"XMLHttpRequest"]
            AF.upload(
                multipartFormData: { multipartFormData in
                },
                to: Constants.BaseUrl + "get_user_teams", method: .get , headers: headers)
            .responseJSON { response in
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
                        SVProgressHUD.dismiss()
                    }
                    print("responseObject \(responseObject)")
                    self.responseDictionary = responseObject as! [String:Any]
                    if let dict = self.responseDictionary["data"]
                        as? [String:Any] {
                        self.dataDictionary = dict
                        print("DataDictionary \(self.dataDictionary)")
                        if let myArray = self.dataDictionary["user_teams"] as? [[String:Any]] {
                            self.userTeam = myArray
                            print("UserTeam\(self.userTeam)")
                        }
                        self.dataNotAvailableLabel.isHidden = true
                        if self.userTeam.count == 0 {
                            self.dataNotAvailableLabel.isHidden = false
                        }
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.walletAmount()
        getTeamsHistory()
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
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(DPTeamHistoryVC.handleTap(_:)))
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
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let menuVC  = storyboard?.instantiateViewController(withIdentifier: "DPWalletVC") as? DPWalletVC
        self.navigationController?.pushViewController(menuVC!, animated:true)
    }
    
    func setupMenu(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menuVC  = storyboard.instantiateViewController(withIdentifier: "LeftViewController") as! LeftViewController
        self.sideMenu = SideMenuNavigationController(rootViewController: menuVC)
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
                multipartFormData: { multipartFormData in },
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
                        SVProgressHUD.dismiss()
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
                        //                                                        if let amount = self.userDictionary["balance"] as? Int {
                        //                        //                                    self.amountLabel.text = "₹" + String(amount)
                        //                                                            self.walletlabel.text = "₹" + String(amount)
                        //                                                        }
                        let stramount = self.getAmount(self.userDictionary["balance"] as Any )
                        self.walletlabel.text = "₹" + (stramount.isEmpty ? "0" : stramount)
                        
                    }
                }
            }
        }
    }
    
    func getAmount(_ value:Any)->String {
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
}

        
extension DPTeamHistoryVC:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userTeam.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let dictionary = self.userTeam[indexPath.row]
        print("CreatedGameDictionary \(dictionary)")
        if let wicketKeeperLabel = cell.viewWithTag(100) as? UILabel {
            if let wicketKeeper = dictionary["wicket_keeper"] as? Int {
                wicketKeeperLabel.text = String(wicketKeeper)
            }
        }
        if let batsmanLabel = cell.viewWithTag(110) as? UILabel {
            if let batsman = dictionary["batsmen"] as? Int {
                batsmanLabel.text = String(batsman)
            }
        }
        
        if let alrounderLabel = cell.viewWithTag(120) as? UILabel {
            if let alrounder = dictionary["all_rounders"] as? Int {
                alrounderLabel.text = String(alrounder)
            }
        }
        if let bowlerLabel = cell.viewWithTag(130) as? UILabel {
            if let bowler = dictionary["bowlers"] as? Int {
                bowlerLabel.text = String(bowler)
            }
        }
        
        if let teamACount = cell.viewWithTag(70) as? UILabel {
            if let teamaDictionary = dictionary["teama"] as? [String:Any] {
                if let count = teamaDictionary["count"] as? Int {
                    teamACount.text = String(count)
                }
            }
        }
        
        if let teamBCount = cell.viewWithTag(90) as? UILabel {
            if let teambDictionary = dictionary["teamb"] as? [String:Any] {
                if let count = teambDictionary["count"] as? Int {
                    teamBCount.text = String(count)
                }
            }
        }
        
        if let teamAIcon = cell.viewWithTag(60) as? UIImageView {
            if let teamaDictionary = dictionary["teama"] as? [String:Any] {
                if let winnerImgUrl = teamaDictionary["image"] as? String,
                   !winnerImgUrl.isEmpty, let imgURl =  URL(string:winnerImgUrl) {
                    teamAIcon.sd_setImage(with: imgURl,placeholderImage: self.defaultImage, completed: nil)
                }
            }
        }
        if let teamBIcon = cell.viewWithTag(80) as? UIImageView {
            
            if let teambDictionary = dictionary["teamb"] as? [String:Any] {
                
                if let winnerImgUrl = teambDictionary["image"] as? String,
                   !winnerImgUrl.isEmpty, let imgURl =  URL(string:winnerImgUrl) {
                    teamBIcon.sd_setImage(with: imgURl,placeholderImage: self.defaultImage, completed: nil)
                    
                }
            }
            
            
        }
        
        if let captainDictionary = dictionary["captain"] as? [String:Any] {
            print("CaptainDictionary \(String(describing: captainDictionary))")
            if let teamA = cell.viewWithTag(30) as? UILabel {
                teamA.text = captainDictionary["name"] as? String
            }
        }
        
        if let teamName = dictionary["name"] as? String {
            if let teamA = cell.viewWithTag(11) as? UILabel {
                teamA.text = teamName
            }
        }
        
        if  let viceCaptainDictionary = dictionary["vice_captain"] as? [String:Any]{
            print("ViceCaptainDictionary \(String(describing: viceCaptainDictionary))")
            if let teamB = cell.viewWithTag(50) as? UILabel {
                teamB.text = viceCaptainDictionary["name"] as? String
            }
        }
        
        
        
        
        if let borderView = cell.viewWithTag(10) {
            
            
            borderView.layer.cornerRadius = 8
            borderView.layer.borderWidth = 1
            borderView.layer.borderColor = UIColor.clear.cgColor
        }
        /* if let firstCountryFlag = cell.viewWithTag(20) as? UIImageView {
         
         if let imageUrl = dictionary["teama_image"] as? String, let  url = URL(string:imageUrl){
         print("UserURLImage \(url)")
         if let data = try? Data(contentsOf: url)  {
         firstCountryFlag.image = UIImage(data: data)
         //teamAIcon.contentMode = .scaleAspectFill
         }
         }
         
         }
         */
        
        return cell
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dictionary = self.userTeam[indexPath.row]
        print("PickDictionary \(String(describing:dictionary))")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menuVC  = storyboard.instantiateViewController(withIdentifier: "DPPickTeamViewController") as? DPPickTeamViewController
        menuVC?.pickTeamDictionary = dictionary
        menuVC?.modalPresentationStyle = .fullScreen
        self.navigationController?.present(menuVC!, animated: true)
        //self.navigationController?.pushViewController(menuVC!, animated: true)
    }
}
