//
//  DPChangePasswordVC.swift
//  DreamPlay
//
//  Created by MAC on 10/06/21.
//

import UIKit
import Alamofire
import SVProgressHUD
import SkyFloatingLabelTextField
import SideMenu

class DPChangePasswordVC: UITableViewController,UITextFieldDelegate {
    @IBOutlet weak var changePassword: UIButton!
    @IBOutlet weak var currentPasswordField: SkyFloatingLabelTextField!
    @IBOutlet weak var newPasswordField: SkyFloatingLabelTextField!
    @IBOutlet weak var confirmPasswordField: SkyFloatingLabelTextField!
    var responseDictionary:[String:Any] = [:]
    var message:String?
    var isOpen = false
    var screenCheck = false
    var token:String?
    var status:Int?
    var walletView : UIView!
    var walletlabel : UILabel!
    var sideMenu:SideMenuNavigationController?
    var dataDictionary:[String:Any] = [:]
    var userDictionary:[String:Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupWalletView()
        self.setupMenu()
        self.tableView.rowHeight = 80.0
//        let logo = UIImage(named:"layer3")
//        let imageView = UIImageView(image:logo)
//        imageView.frame = CGRect(x: 150, y: 20, width: 100.0, height: 30.0)
//        self.navigationItem.titleView = imageView
        
        tableView.backgroundView = UIImageView(image: UIImage(named: "Background"))
        token = UserDefaults.standard.string(forKey:"AccessToken")!
        print("Token :", token as Any)
        changePassword.layer.cornerRadius = 8
        changePassword.layer.borderWidth = 1
        changePassword.layer.borderColor = UIColor.clear.cgColor
        //self.tabBarController?.tabBar.isHidden = true

        let toggleButton = UIBarButtonItem(image: UIImage(named: "group12"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(DPChangePasswordVC.pause))
        self.navigationItem.leftBarButtonItem = toggleButton
        

        
    }
    @IBAction func btnMenu(_ sender: UIButton){
        present(sideMenu!, animated: true, completion: nil)
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
        
        //  SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        SideMenuManager.default.leftMenuNavigationController = self.sideMenu
        
    }
    
    @objc func pause(){
        present(sideMenu!, animated: true, completion: nil)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.walletAmount()
       // self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.layer.zPosition = -1
        removeTabbarItemsText()
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
    
    func removeTabbarItemsText() {
        if let items = tabBarController?.tabBar.items {
            for item in items {
                item.title = ""
                item.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0);
            }
        }
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
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
    
    
    @IBAction func changePasswordTapped(_ sender: Any) {
        if isValidation() {
            changePasswordAPI()
        }
    }
    
    func isValidation() -> Bool {
        guard let currentPassword = currentPasswordField.text, !currentPassword.isEmpty else  {
            showAlert("Please enter current password.")
            return false
        }
        guard let newPassword = newPasswordField.text, !newPassword.isEmpty else  {
            showAlert("Please enter new password.")
            return false
        }
         if self.newPasswordField.text?.isValidPassword() == false{
            let alertController = UIAlertController(title: "Alert", message:"Password must have atleast 1 capital character, 1 number, 1 symbol and minimum 8 characters", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion:nil)
        }
        guard let confirmPassword = confirmPasswordField.text, !confirmPassword.isEmpty else  {
            showAlert("Please enter confirm password.")
            return false
        }
        
        if newPassword != confirmPassword {
            showAlert("New password and confirm password should be same.")
            return false
        }
        return true
    }
    
    
    func changePasswordAPI() {
        self.view.endEditing(true)
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            
            let headers: HTTPHeaders = ["Content-type": "multipart/form-data","Authorization":"Bearer" + " " + token!,"X-Requested-With":"XMLHttpRequest"]
            SVProgressHUD.show()
            
            AF.upload(
                multipartFormData: { multipartFormData in
                    multipartFormData.append((self.currentPasswordField.text!).data(using: String.Encoding.utf8)!, withName:"current_password")
                    
                    multipartFormData.append((self.newPasswordField.text!).data(using: String.Encoding.utf8)!, withName:"password")
                    
                    multipartFormData.append((self.confirmPasswordField.text!).data(using: String.Encoding.utf8)!, withName:"password_confirmation")
                    
                    
                },
                to: Constants.BaseUrl + "update/password", method: .post , headers: headers)
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
                        self.message = self.responseDictionary["message"] as? String
                        let status = self.responseDictionary["status"] as? Int
                        if status == 0 {
                            let alertController = UIAlertController(title: "Alert", message: self.message, preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                                print("you have pressed the Ok button");
                                //self.navigationController?.popViewController(animated: true)
                            }
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true, completion:nil)
                        }
                        else if status == 1{
                            self.currentPasswordField.text = ""
                            self.newPasswordField.text = ""
                            self.confirmPasswordField.text = ""
                            let alertController = UIAlertController(title: "Alert", message: self.message, preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                                print("you have pressed the Ok button")
                                self.navigationController?.popViewController(animated: true)
                            }
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true, completion:nil)
                        }
                        SVProgressHUD.dismiss()
                    }
                }
                
                /*
                 override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                 let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
                 
                 // Configure the cell...
                 
                 return cell
                 }
                 */
                
                /*
                 // Override to support conditional editing of the table view.
                 override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
                 // Return false if you do not want the specified item to be editable.
                 return true
                 }
                 */
                
                /*
                 // Override to support editing the table view.
                 override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
                 if editingStyle == .delete {
                 // Delete the row from the data source
                 tableView.deleteRows(at: [indexPath], with: .fade)
                 } else if editingStyle == .insert {
                 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
                 }
                 }
                 */
                
                /*
                 // Override to support rearranging the table view.
                 override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
                 
                 }
                 */
                
                /*
                 // Override to support conditional rearranging of the table view.
                 override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
                 // Return false if you do not want the item to be re-orderable.
                 return true
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
        }
    }
}
