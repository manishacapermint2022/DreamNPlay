//
//  DPAdharCardOTPVC.swift
//  DreamPlay
//
//  Created by MAC on 23/07/21.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire
import SVProgressHUD

class DPAdharCardOTPVC: UIViewController {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var sixthTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var fifthTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var fourthTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var thirdTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var secondTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var firstTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var otpTextFieldView: OTPFieldView!
    @IBOutlet weak var descriptionText: UILabel!
    var mobileNumber:String?
    var token:String?
    var message:String?
    var responseDictionary:[String:Any] = [:]
    var clientIds:String?
    var dataDictionary:[String:Any] = [:]
    var adhaarDictionary:[String:Any] = [:]
    var clientDictionary:[String:Any] = [:]
    var otpNumber:Int?
    var timer = Timer()
    var paramDict:[String:Any] = [:]
    var status:Int?
    var flags:Int?
    var fullNames:String?
    var aadharNo:String?
    @IBOutlet weak var resendButton: UIButton!
    var count = 60
    override func viewDidLoad() {
        super.viewDidLoad()
        startTimer()
        self.flags = 2
        
        self.resendButton.isHidden = true
        self.descriptionText.text = "Please enter 6 digit code sent to your mobile number."
        token = UserDefaults.standard.string(forKey:"AccessToken")!
        
        print("FullAdharName\(String(describing:fullNames))")
        print("ClientIdsss\(String(describing: clientIds))")
        let logo = UIImage(named:"layer3")
        let imageView = UIImageView(image:logo)
        imageView.frame = CGRect(x: 150, y: 20, width: 100.0, height: 30.0)
        self.navigationItem.titleView = imageView
        
        
        self.setupOtpView()
        
        // Do any additional setup after loading the view.
    }
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        if(count >= 0){
            let minutes = String(count / 60)
            let seconds = String(count % 60)
            self.timerLabel.text = minutes + ":" + seconds
            count = count-1
        }
        else {
          //  resendButton.isHidden = false
            endTimer()
        }
    }
    
    func endTimer() {
        timer.invalidate()
    }
    
    
    func setupOtpView(){
        self.otpTextFieldView.fieldTextColor = .white
        self.otpTextFieldView.fieldsCount = 6
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
   
    
}
    
extension DPAdharCardOTPVC: OTPFieldViewDelegate {
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
    
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        return String(format: "0:%02d", seconds)
    }
    
    
    @IBAction func resendButtonTapped(_ sender: Any) {
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            //let mobile = self.mobileTextField.text!
            //self.mobileNum = Int(mobile)
            SVProgressHUD.show()
            let headers: HTTPHeaders = ["Content-type": "multipart/form-data","X-Requested-With":"XMLHttpRequest"]
            AF.upload(
                multipartFormData: { multipartFormData in
                    multipartFormData.append((self.mobileNumber)!.data(using: String.Encoding.utf8)!, withName:"phone")
                },
                to: Constants.BaseUrl + "send_otp", method: .post, headers: headers)
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
                        print("ResponseDictionary \(self.responseDictionary)")
                        
                        self.message = self.responseDictionary["message"] as? String
                        self.status = self.responseDictionary["status"] as? Int
                        
                        if self.status == 0 {
                            
                            
                            let alert = UIAlertController(title: "Alert", message:self.message, preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                        else{
                            
                            let alert = UIAlertController(title: "Alert", message:self.message, preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            
                            
                            
                            
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
    
    
    @IBAction func verifyOTPTapped(_ sender: Any) {
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            /* let first = self.firstTextField.text!
             let second = self.secondTextField.text!
             let third = self.thirdTextField.text!
             let fourth = self.fourthTextField.text!
             let fifth = self.fifthTextField.text!
             let sixth = self.sixthTextField.text!
             
             let sum = first + second
             let sum1 = sum + third
             let sum2 = sum1 + fourth
             let sum3 = sum2 + fifth
             let final = sum3 + sixth
             print("OTP \(final)")
             */
            
            self.paramDict["otp"] = self.otpNumber
            self.paramDict["client_id"] = self.clientIds
            self.paramDict["aadhar_no"] = self.aadharNo
            
            let headers: HTTPHeaders = ["Content-type": "multipart/form-data","Authorization":"Bearer" + " " + token!,"X-Requested-With":"XMLHttpRequest"]
            
            
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
                to: Constants.BaseUrl + "aadhar/submit-otp", method: .post , headers: headers)
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
                                
                                /* let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                 let menuVC  = storyboard.instantiateViewController(withIdentifier: "DPBankDetailVC") as? DPBankDetailVC
                                 //  menuVC?.clientIds = self.clientId
                                 
                                 self.navigationController?.pushViewController(menuVC!, animated: true)
                                 */
                            }
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true, completion:nil)
                        }
                        else if status == 1{
                            
                            if let dict = self.responseDictionary["data"] as? [String:Any] {
                                self.dataDictionary = dict
                                print("DataDictionary \(self.dataDictionary)")
                            }
                            if let adhaar = self.dataDictionary["aadhar_response"] as? [String:Any] {
                                self.adhaarDictionary = adhaar
                                print("AdhaarDictionarysss \(self.adhaarDictionary)")
                            }
                            if let data = self.adhaarDictionary["data"] as? [String:Any] {
                                self.clientDictionary = data
                                print("ClientDictionarysss \(self.clientDictionary)")
                            }
                            self.fullNames = self.clientDictionary["full_name"] as? String
                            print("FullNames \(String(describing: self.fullNames))")
                            
                            let alertController = UIAlertController(title: "Alert", message: self.message, preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let menuVC  = storyboard.instantiateViewController(withIdentifier: "DPBankDetailVC") as? DPBankDetailVC
                                menuVC?.flag = self.flags
                                menuVC?.name = self.fullNames
                                
                                self.navigationController?.pushViewController(menuVC!, animated: true)
                                
                                print("you have pressed the Ok button");
                            }
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true, completion:nil)
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
    }
}

