//
//  DPOTPVC.swift
//  DreamPlay
//
//  Created by MAC on 22/07/21.
//

import UIKit
import Alamofire
import SVProgressHUD
import SkyFloatingLabelTextField

class DPOTPVC: UIViewController {

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var fourthTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var thirdTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var secondTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var firstTextField: SkyFloatingLabelTextField!
    var dataDictionary:[String:Any] = [:]
    var responseDictionary:[String:Any] = [:]
    var authenticationToken:String?
    var mobile:String?
    var balance:Int?
    var timer = Timer()
    @IBOutlet weak var otpTextFieldView: OTPFieldView!
    var count = 60
    var mobileNumber:Int?
    var otpNumber:Int?
    var flags:Int?
    var status:Int?
    var token:String?
    @IBOutlet weak var MobileInstructionLabel: UILabel!
    @IBOutlet weak var resendButton: UIButton!
    var message:String?
    var paramDict:[String:Any] = [:]
    var userDictionary:[String:Any] = [:]
    var referralCode:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.resendButton.isHidden = true
        startTimer()
        print("Mobile \(String(describing: mobile))")
        // Do any additional setup after loading the view.
        let logo = UIImage(named:"layer3")
        let imageView = UIImageView(image:logo)
        imageView.frame = CGRect(x: 150, y: 20, width: 100.0, height: 30.0)
        self.navigationItem.titleView = imageView

        self.MobileInstructionLabel.text = "Please enter 4 digit code sent to \(String(describing: mobile!)) or click on the link provided."
        self.setupOtpView()
        
        print("Flagss \(flags)")
        
        
       
        //self.firstTextField.len
    }
    
    func setupOtpView(){
        self.otpTextFieldView.fieldTextColor = .white
        self.otpTextFieldView.fieldsCount = 4
        self.otpTextFieldView.fieldBorderWidth = 2
        self.otpTextFieldView.defaultBorderColor = UIColor.white
        self.otpTextFieldView.filledBorderColor = UIColor(red:224.0/255.0, green: 204.0/255.0, blue: 108.0/255.0, alpha: 1.0)
        self.otpTextFieldView.cursorColor = UIColor.white
        self.otpTextFieldView.displayType = .underlinedBottom
        self.otpTextFieldView.fieldSize = 40
        self.otpTextFieldView.separatorSpace = 8
        self.otpTextFieldView.shouldAllowIntermediateEditing = false
        self.otpTextFieldView.delegate = self
        self.otpTextFieldView.initializeUI()
    }
    
   /* func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         guard let text = textField.text else { return true }
         let newLength = text.count + string.count - range.length
         return newLength == 1
    }
 */
    
    override func viewWillAppear(_ animated: Bool) {
       // self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func resendButtonTapped(_ sender: Any) {
        startTimer()
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            
            //let mobile = self.mobileTextField.text!
            //self.mobileNum = Int(mobile)
          // count = 60
            self.startTimer()
       // SVProgressHUD.show()
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data","X-Requested-With":"XMLHttpRequest"]


                   AF.upload(
                       multipartFormData: { multipartFormData in
                        multipartFormData.append((self.mobile)!.data(using: String.Encoding.utf8)!, withName:"phone")
                       
                        
                   },
                    to: Constants.BaseUrl + "send_otp", method: .post, headers: headers)
                       .responseJSON { response in
                        
                        
                        switch response.result {
                        case .failure(let error):
                            //SVProgressHUD.dismiss()
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
                                print("ResponseDictionary \(self.responseDictionary)")
                                
                                self.message = self.responseDictionary["message"] as? String
                                self.status = self.responseDictionary["status"] as? Int
                                
                                if self.status == 0 {
                                    
                                    
                                    let alert = UIAlertController(title: "Alert", message:self.message, preferredStyle: UIAlertController.Style.alert)
                                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                
                                }
                                else{
                                    
                                    //self.updateTime()
                                    self.showAlert(withTitle: "Alert", withMessage: self.message ?? "")
                                    
                                  //  self.count = 60
                                   /* let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
                                    let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                    let nC = mainStoryBoard.instantiateViewController(withIdentifier:"UITabBarController") as? TabBarController//UITabBarController
                                   // self.delegate?.passingData(message: self.text!)
                                    UserDefaults.standard.set(true, forKey:"isUserLoggedIn")
                                    UserDefaults.standard.synchronize()
                                    appDel.window!.rootViewController = nC
                                    appDel.window!.makeKeyAndVisible()
                                    self.dismiss(animated: true, completion: nil)
 */
                                   
                                  
                                   
                                }
                                
                                /*if let dict = self.responseDictionary["data"]
                                    as? [String:Any] {
                                    self.dataDictionary = dict
                                    print("DataDictionary \(self.dataDictionary)")
                                    if let myArray = self.dataDictionary["contests"] as? [[String:Any]] {
                                        self.contestArray = myArray
                                        print("ContestArray \(self.contestArray)")
                                    }
                                    
                                    if self.contestArray.count == 0 {
                                        
                                        let alertController = UIAlertController(title: "Alert", message: "No data available", preferredStyle: .alert)
                                        let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                                            print("you have pressed the Ok button");
                                        }
                                        alertController.addAction(okAction)
                                        
                                    }
                                    self.tableView.reloadData()
 */
                                }
                            
                            }
                        }
                       }
            
                   
    }
    func showAlert(withTitle title: String, withMessage message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
            //self.present(alert, animated: true, completion: nil)
            self.count = 60
        })
        alert.addAction(ok)
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
    }
   
}
    extension DPOTPVC: OTPFieldViewDelegate {
        func hasEnteredAllOTP(hasEnteredAll hasEntered: Bool) -> Bool {
            print("Has entered all OTP? \(hasEntered)")
            return false
        }
        
        func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
            return true
        }
        
        func enteredOTP(otp otpString: String) {
            print("OTPString: \(otpString)")
            
            self.otpNumber = Int(otpString)
        
    }
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        if(count >= 0){
            let minutes = String(count / 60)
            let seconds = String(count % 60)
            timerLabel.text = minutes + ":" + seconds
            count = count-1
        }
        else {
           resendButton.isHidden = false
           endTimer()
        }
    }

    func endTimer() {
        timer.invalidate()
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        return String(format: "0:%02d", seconds)
    }

    
    func saveLogin(){
        UserDefaults.standard.set(true, forKey:"isUserLoggedIn")
        UserDefaults.standard.synchronize()
                                                        
    }
   @objc func updateCounter() {

        if(count >= 0){
            
            let minutes = String(count / 60)
            let seconds = String(count % 60)
            timerLabel.text = minutes + ":" + seconds
            count = count-1
        }
    }
    func verifyOTP(){
        
        
        if self.flags == 1 {
            
            
            if isInternetAvailable() == false{
                let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else{
              
                self.paramDict["otp"] = self.otpNumber
                self.paramDict["phone"] = self.mobile
                
              
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data","X-Requested-With":"XMLHttpRequest"]


                   AF.upload(
                       multipartFormData: { multipartFormData in
                        //multipartFormData.append((self.mobile?.data(using: String.Encoding.utf8)!)!, withName:"phone")
                       // multipartFormData.append((id).data(using: String.Encoding.utf8)!, withName:"otp")
                        
                             for (key, value) in self.paramDict {
                                if value is String {
                                 multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                                } else if value is Int {
                                 multipartFormData.append(("\(value)" as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                                }
                            }
                             
                        
                        
                        
                        
                   },
                    to: Constants.BaseUrl + "verify_otp", method: .post , headers: headers)
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
                                let status = self.responseDictionary["status"] as? Int ?? 0
                                if status == 0 {
                                    let alertController = UIAlertController(title: "Alert", message: self.message, preferredStyle: .alert)
                                    let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                                        print("you have pressed the Ok button");
                                    }
                                    alertController.addAction(okAction)
                                    self.present(alertController, animated: true, completion:nil)
                                }
                                else if status == 1{
                                    //self.firstTextField.text = ""
                                   // self.secondTextField.text = ""
                                   // self.thirdTextField.text = ""
                                    //self.fourthTextField.text = ""
                                    self.saveLogin()
                                    self.responseDictionary = responseObject as! [String:Any]
                                    self.message = self.responseDictionary["message"] as? String
                                    if let dict = self.responseDictionary["data"] as? [String:Any] {
                                        self.dataDictionary = dict
                                        print("DataDictionary \(self.dataDictionary)")
                                    }
                                    
                                    if let dict = self.dataDictionary["user"] as? [String:Any] {
                                        self.userDictionary = dict
                                        //let prefs:UserDefaults = UserDefaults.standard
                                        //prefs.set(dict, forKey: "user_detail")
                                    }
                                    
                                    self.authenticationToken = self.dataDictionary["token"] as? String
                                    self.balance = self.userDictionary["balance"] as? Int
                                    self.referralCode = self.userDictionary["referral_code"] as? String
                                    let prefs:UserDefaults = UserDefaults.standard
                                    prefs.set(self.authenticationToken!, forKey: "AccessToken")
                                    prefs.set(self.balance,forKey:"Balance")
                                    prefs.set(self.referralCode,forKey:"ReferralCode")
                                    prefs.synchronize()
                                    
                                    
                                   
                                        let alertController = UIAlertController(title: "Alert", message: self.message, preferredStyle: .alert)
                                        let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                            let menuVC  = storyboard.instantiateViewController(withIdentifier: "UITabBarController") as?  TabBarController
                                            AppDelegate.getAppDelegate().setRoot(menuVC as AnyObject)
                                            //menuVC?.createDictionary = self.contestDictionary
                                            
                                            ///self.navigationController?.pushViewController(menuVC!, animated: true)
                                        }
                                        alertController.addAction(okAction)
                                        self.present(alertController, animated: true, completion:nil)
                                        
                                    }
                                   
                                }
                            
                        }
                       
                       }
            }
     
            
        }
                else if self.flags == 2{
        
       
        
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            //self.startTimer()
          //  let first = self.firstTextField.text
          //  let second = self.secondTextField.text
          //  let third = self.thirdTextField.text
           // let fourth = self.fourthTextField.text!
            
            
            //let sum = first! + second!
           //let sum1 = sum + third!
           //let final = sum1 + fourth
          // print("OTP \(final)")
          // self.otpNumber = Int(final)
            self.paramDict["otp"] = self.otpNumber
            self.paramDict["phone"] = self.mobile
            
            
             
    let headers: HTTPHeaders = ["Content-type": "multipart/form-data","X-Requested-With":"XMLHttpRequest"]


               AF.upload(
                   multipartFormData: { multipartFormData in
                    //multipartFormData.append((self.mobile?.data(using: String.Encoding.utf8)!)!, withName:"phone")
                   // multipartFormData.append((id).data(using: String.Encoding.utf8)!, withName:"otp")
                    
                         for (key, value) in self.paramDict {
                            if value is String {
                             multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                            } else if value is Int {
                             multipartFormData.append(("\(value)" as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                            }
                        }
                         
                    
                    
                    
                    
               },
                to: Constants.BaseUrl + "verify_signup_otp", method: .post , headers: headers)
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
                            let status = self.responseDictionary["status"] as? Int ?? 0
                           
                            if status == 0  {
                                let alertController = UIAlertController(title: "Alert", message: self.message, preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                                    print("you have pressed the Ok button");
                                }
                                alertController.addAction(okAction)
                                self.present(alertController, animated: true, completion:nil)
                            }
                            else if status == 1{
                                self.saveLogin()
                                if let dict = self.responseDictionary["data"] as? [String:Any] {
                                    self.dataDictionary = dict
                                    print("DataDictionary \(self.dataDictionary)")
                                }
                                
                                if let dict = self.dataDictionary["user"] as? [String:Any] {
                                    self.userDictionary = dict
                                  //  let prefs:UserDefaults = UserDefaults.standard
                                  //  prefs.set(dict, forKey: "user_detail")
                                }
                                
                                self.authenticationToken = self.dataDictionary["token"] as? String
                                self.balance = self.userDictionary["balance"] as? Int
                                self.referralCode = self.userDictionary["referral_code"] as? String
                                let prefs:UserDefaults = UserDefaults.standard
                                prefs.set(self.authenticationToken!, forKey: "AccessToken")
                                prefs.set(self.balance,forKey:"Balance")
                                prefs.set(self.referralCode,forKey:"ReferralCode")
                                prefs.synchronize()
                                let alertController = UIAlertController(title: "Alert", message: self.message, preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    let menuVC  = storyboard.instantiateViewController(withIdentifier: "UITabBarController") as?  TabBarController
                                    AppDelegate.getAppDelegate().setRoot(menuVC as AnyObject)
                                    //menuVC?.createDictionary = self.contestDictionary
                                    
                                    ///self.navigationController?.pushViewController(menuVC!, animated: true)
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
        
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
              let rangeOfTextToReplace = Range(range, in: textField.text!) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count == 1
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        
        self.verifyOTP()
      /*  if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            
            let first = self.firstTextField.text
            let second = self.secondTextField.text
            let third = self.thirdTextField.text
            let fourth = self.fourthTextField.text!
            
            
            let sum = first! + second!
           let sum1 = sum + third!
           let final = sum1 + fourth
           print("OTP \(final)")
           self.otpNumber = Int(final)
            self.paramDict["otp"] = self.otpNumber!
            self.paramDict["phone"] = self.mobileNumber!
            
            if let id = final as? String {
    let headers: HTTPHeaders = ["Content-type": "multipart/form-data","X-Requested-With":"XMLHttpRequest"]


               AF.upload(
                   multipartFormData: { multipartFormData in
                    //multipartFormData.append((self.mobile?.data(using: String.Encoding.utf8)!)!, withName:"phone")
                   // multipartFormData.append((id).data(using: String.Encoding.utf8)!, withName:"otp")
                    
                         for (key, value) in self.paramDict {
                            if value is String {
                             multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                            } else if value is Int {
                             multipartFormData.append(("\(value)" as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                            }
                        }
                         
                    
                    
                    
                    
               },
                to: Constants.BaseUrl + "verify_signup_otp", method: .post , headers: headers)
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
                                }
                                alertController.addAction(okAction)
                                self.present(alertController, animated: true, completion:nil)
                            }
                            else if status == 1{
                                self.firstTextField.text = ""
                                self.secondTextField.text = ""
                                self.thirdTextField.text = ""
                                self.fourthTextField.text = ""
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let menuVC  = storyboard.instantiateViewController(withIdentifier: "DPHomePageVC") as? DPHomePageVC
                                //menuVC?.createDictionary = self.contestDictionary
                                
                                self.navigationController?.pushViewController(menuVC!, animated: true)
                            }
                        }
               }
                   }
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
 */
    }
 
}
            
