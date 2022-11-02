//
//  DPMyMatchesVC.swift
//  DreamPlay
//
//  Created by MAC on 16/06/21.
//

import UIKit
import Alamofire
import SVProgressHUD
import SideMenu
import SDWebImage

class DPMyMatchesVC: UIViewController {
    
    var isOpen = false
    var screenCheck = false
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dataNotAvailableLabel: UILabel!
    @IBOutlet weak var completedLabel: UILabel!
    @IBOutlet weak var upcomingLabel: UILabel!
    @IBOutlet weak var completedButton: UIButton!
    @IBOutlet weak var liveLabel: UILabel!
    @IBOutlet weak var upcomingButton: UIButton!
    @IBOutlet weak var liveButton: UIButton!
    @IBOutlet weak var lblWallet: UILabel!
    
    var sideMenu:SideMenuNavigationController?
    var userDictionary:[String:Any] = [:]
    var responseDictionary:[String:Any] = [:]
    var dataDictionary:[String:Any] = [:]
    var gameArray:[[String:Any]] = []
    var token:String?
    var flag:Int?
    
    enum Tab:Comparable {
        case live
        case upcoming
        case complete
    }
    
    var selectedTab:Tab = .live
    var walletView : UIView!
   // var walletlabel : UILabel!
    var defaultImage:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenu()
        self.setupWalletView()
        self.flag = 1
        self.tableView.rowHeight = 100.0
        self.dataNotAvailableLabel.isHidden = true
        self.liveLabel.isHidden = false
        self.upcomingLabel.isHidden = true
        self.completedLabel.isHidden = true
        self.upcomingButton.titleLabel?.textColor = UIColor(red: 224.0/255.0, green: 204.0/255.0, blue: 108.0/255.0, alpha: 1.0)
        self.completedButton.titleLabel?.textColor = UIColor(red: 224.0/255.0, green: 204.0/255.0, blue: 108.0/255.0, alpha: 1.0)
        
        let logo = UIImage(named:"layer3")
        let imageView = UIImageView(image:logo)
        imageView.frame = CGRect(x: 150, y: 20, width: 100.0, height: 30.0)
        self.navigationItem.titleView = imageView
        tableView.register(UINib(nibName: "DPHomePageCell3", bundle: nil), forCellReuseIdentifier: "DPHomePageCell3")
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "Background"))
        token = UserDefaults.standard.string(forKey:"AccessToken")!
        print("Token :", token as Any)
        self.walletAmount()
        self.downloadImage(from: URL(string:"https://cricket.entitysport.com/assets/uploads/2021/05/team-120x120.png")!)
        
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
                to: Constants.BaseUrl + "fixtures/my?type=LIVE", method: .get , headers: headers)
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
                            if let myArray = self.dataDictionary["fixtures"] as? [[String:Any]] {
                                self.gameArray = myArray
                                print("GameArray \(self.gameArray)")
                            }
                            if self.gameArray.count == 0 {
                                self.dataNotAvailableLabel.isHidden = false
                            }
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func walletAmount(){
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
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
                        self.lblWallet.text = "₹" + (stramount.isEmpty ? "0" : stramount)
                        
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
    @IBAction func toggleButtonTapped(_ sender: Any) {
        present(sideMenu!, animated: true, completion: nil)
        /*
         if(!isOpen)
         
         {
         screenCheck = true
         isOpen = true
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
         let menuVC  = storyboard.instantiateViewController(withIdentifier: "LeftViewController") as? LeftViewController
         self.view.addSubview(menuVC!.view)
         self.addChild(menuVC!)
         menuVC!.view.layoutIfNeeded()
         
         menuVC!.view.frame=CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 100, width: UIScreen.main.bounds.size.width-100, height: UIScreen.main.bounds.size.height - 100);
         
         UIView.animate(withDuration: 0.3, animations: { () -> Void in
         menuVC!.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width-100, height: UIScreen.main.bounds.size.height - 100);
         }, completion:nil)
         
         }else if(isOpen)
         {
         screenCheck = false
         isOpen = false
         let viewMenuBack : UIView = view.subviews.last!
         
         UIView.animate(withDuration: 0.3, animations: { () -> Void in
         var frameMenu : CGRect = viewMenuBack.frame
         frameMenu.origin.x = -1 * UIScreen.main.bounds.size.width
         viewMenuBack.frame = frameMenu
         viewMenuBack.layoutIfNeeded()
         viewMenuBack.backgroundColor = UIColor.clear
         }, completion: { (finished) -> Void in
         viewMenuBack.removeFromSuperview()
         
         })
         }
         */
    }
    @IBAction func liveGameButtonTapped(_ sender: Any) {
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            selectedTab = .live
            self.dataNotAvailableLabel.isHidden = true
            self.liveLabel.isHidden = false
            self.upcomingLabel.isHidden = true
            self.completedLabel.isHidden = true
            SVProgressHUD.show()
            let headers: HTTPHeaders = ["Content-type": "multipart/form-data","Authorization":"Bearer" + " " + token!,"X-Requested-With":"XMLHttpRequest"]
            
            
            AF.upload(
                multipartFormData: { multipartFormData in
                    
                    
                },
                to: Constants.BaseUrl + "fixtures/my?type=LIVE", method: .get , headers: headers)
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
                            if let myArray = self.dataDictionary["fixtures"] as? [[String:Any]] {
                                self.gameArray = myArray
                                print("GameArray \(self.gameArray)")
                            }
                            self.dataNotAvailableLabel.isHidden = true
                            if self.gameArray.count == 0 {
                                
                                self.dataNotAvailableLabel.isHidden = false
                                
                                /*  let alertController = UIAlertController(title: "Alert", message: "No data available", preferredStyle: .alert)
                                 let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                                 print("you have pressed the Ok button");
                                 }
                                 alertController.addAction(okAction)
                                 self.present(alertController, animated: true, completion:nil)
                                 */
                                
                            }
                            self.tableView.reloadData()
                        }
                        
                    }
                }
            }
        }
    }
    @IBAction func upcomingGameTapped(_ sender: Any) {
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            selectedTab = .upcoming
            self.dataNotAvailableLabel.isHidden = true
            self.liveLabel.isHidden = true
            self.upcomingLabel.isHidden = false
            self.completedLabel.isHidden = true
            SVProgressHUD.show()
            let headers: HTTPHeaders = ["Content-type": "multipart/form-data","Authorization":"Bearer" + " " + token!,"X-Requested-With":"XMLHttpRequest"]
            
            
            AF.upload(
                multipartFormData: { multipartFormData in
                    
                    
                },
                to: Constants.BaseUrl + "fixtures/my?type=NOT%20STARTED", method: .get , headers: headers)
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
                            if let myArray = self.dataDictionary["fixtures"] as? [[String:Any]] {
                                self.gameArray = myArray
                                print("GameArray \(self.gameArray)")
                            }
                            if self.gameArray.count == 0 {
                                self.dataNotAvailableLabel.isHidden = false
                                /* let alertController = UIAlertController(title: "Alert", message: "No data available", preferredStyle: .alert)
                                 let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                                 print("you have pressed the Ok button");
                                 }
                                 alertController.addAction(okAction)
                                 self.present(alertController, animated: true, completion:nil)
                                 */
                            }
                            self.tableView.reloadData()
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
//        walletView.addSubview(walletlabel)
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(DPMyMatchesVC.handleTap(_:)))
        
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
    
    @IBAction func completedGameTapped(_ sender: Any)  {
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            selectedTab = .complete
            self.dataNotAvailableLabel.isHidden = true
            self.liveLabel.isHidden = true
            self.upcomingLabel.isHidden = true
            self.completedLabel.isHidden = false
            SVProgressHUD.show()
            let headers: HTTPHeaders = ["Content-type": "multipart/form-data","Authorization":"Bearer" + " " + token!,"X-Requested-With":"XMLHttpRequest"]
            
            
            AF.upload(
                multipartFormData: { multipartFormData in
                    
                    
                },
                to: Constants.BaseUrl + "fixtures/my?type=COMPLETED", method: .get , headers: headers)
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
                            if let myArray = self.dataDictionary["fixtures"] as? [[String:Any]] {
                                self.gameArray = myArray
                                print("GameArray \(self.gameArray)")
                            }
                            self.dataNotAvailableLabel.isHidden = true
                            if self.gameArray.count == 0 {
                                self.dataNotAvailableLabel.isHidden = false
                            }
                            self.tableView.reloadData()
                        }
                        
                    }
                }
            }
        }
    }
}


extension DPMyMatchesVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.gameArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch selectedTab {
        case .complete:
            return 130
        default:
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dictionary = self.gameArray[indexPath.row]
        
        if selectedTab == .complete{
            
            
            let cellA = tableView.dequeueReusableCell(withIdentifier: "DPHomePageCell3",for: indexPath as IndexPath) as! DPHomePageCell3
            print("Dictionaryssssss \(String(describing: dictionary))")
            
            //            if let borderView = cellA.viewWithTag(10) {
            
            
            cellA.borderView.layer.cornerRadius = 8
            cellA.borderView.layer.borderWidth = 1
            cellA.borderView.layer.borderColor = UIColor.clear.cgColor
            cellA.borderView.layer.masksToBounds = true
            cellA.borderView.clipsToBounds = true
            //             }
            cellA.lblTeamAScore.text = dictionary["teama_score"] as? String ?? ""
            cellA.lblTeamBScore.text = dictionary["teamb_score"] as? String ?? ""
            if let teamAIcon = cellA.viewWithTag(40) as? UIImageView {
                if let imageUrl1 = dictionary["teama_image"] as? String,
                   !imageUrl1.isEmpty, let imgURl1 =  URL(string:imageUrl1) {
                    teamAIcon.sd_setImage(with: imgURl1,placeholderImage: self.defaultImage, completed: nil)
                }
            }
            
            
            if let teamBIcon = cellA.viewWithTag(50) as? UIImageView {
                if let imageUrl = dictionary["teamb_image"] as? String,
                   !imageUrl.isEmpty, let imgURl =  URL(string:imageUrl) {
                    teamBIcon.sd_setImage(with: imgURl,placeholderImage: self.defaultImage, completed: nil)
                }
            }
            
            if let teamA = cellA.viewWithTag(60) as? UILabel {
                teamA.text = dictionary["teama_short_name"] as? String
            }
            
            if let teamB = cellA.viewWithTag(70) as? UILabel {
                teamB.text = dictionary["teamb_short_name"] as? String
            }
            if let gameStatus = cellA.viewWithTag(80) as? UILabel {
                gameStatus.backgroundColor = .red
                gameStatus.textColor = .white
                gameStatus.text = dictionary["status"] as? String
            }
            if let gameType = cellA.viewWithTag(90) as? UILabel {
                gameType.text = dictionary["type"] as? String
            }
            return cellA
        }
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if let borderView = cell.viewWithTag(10) {
            
            
            borderView.layer.cornerRadius = 8
            borderView.layer.borderWidth = 1
            borderView.layer.borderColor = UIColor.clear.cgColor
        }
        if let teamAIcon = cell.viewWithTag(40) as? UIImageView {
            
            if let imageUrl = dictionary["teama_image"] as? String,
               !imageUrl.isEmpty, let imgURl =  URL(string:imageUrl) {
                teamAIcon.sd_setImage(with: imgURl,placeholderImage: self.defaultImage, completed: nil)
            }
        }
        if let teamBIcon = cell.viewWithTag(50) as? UIImageView {
            if let imageUrl = dictionary["teamb_image"] as? String,
               !imageUrl.isEmpty, let imgURl =  URL(string:imageUrl) {
                teamBIcon.sd_setImage(with: imgURl,placeholderImage: self.defaultImage, completed: nil)
            }
        }
        if let teamA = cell.viewWithTag(60) as? UILabel {
            teamA.text = dictionary["teama_short_name"] as? String
        }
        
        if let teamB = cell.viewWithTag(70) as? UILabel {
            teamB.text = dictionary["teamb_short_name"] as? String
        }
        if let gameStatus = cell.viewWithTag(80) as? UILabel {
            
            let stats = dictionary["status"] as? String
            if stats == "LIVE" {
                gameStatus.text = "Time's up!"
            }
            else{
                gameStatus.text = dictionary["status"] as? String
            }
        }
        if let gameType = cell.viewWithTag(90) as? UILabel {
            gameType.text = dictionary["type"] as? String
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dictionary = gameArray[indexPath.row]
        print("DictionarySelect \(String(describing: dictionary))")
        let pref:UserDefaults = UserDefaults.standard
        pref.set(dictionary, forKey:"ContestDictionary")
        // pref.set(self.flag, forKey: "Flag")
        pref.synchronize()
        let menuVC  = storyboard?.instantiateViewController(withIdentifier: "DPContestVC") as? DPContestVC
        menuVC?.contestDictionary = dictionary
        // menuVC?.flags = flag
        self.modalPresentationStyle = .fullScreen
        self.navigationController?.present(menuVC!, animated: true)
       // self.navigationController?.pushViewController(menuVC!, animated:true)
    }
    
       
    
}
    

