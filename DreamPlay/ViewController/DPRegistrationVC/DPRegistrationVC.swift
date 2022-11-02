//
//  DPRegistrationVC.swift
//  DreamPlay
//
//  Created by MAC on 10/06/21.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire
import SVProgressHUD
import KSToastView


class DPRegistrationVC: UITableViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    @IBOutlet weak var fullNameField: SkyFloatingLabelTextField!
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var phoneTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var orSignInWith: UILabel!
    @IBOutlet weak var labelTermsAndCondition: UILabel!
    @IBOutlet weak var referralCodeField: SkyFloatingLabelTextField!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var confirmPasswordField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var addressTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var stateTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var cityTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var createButton: UIButton!
    var flag:Int?
    var message:String?
    let pickerView = UIPickerView()
    var responseDictiomary:[String:Any] = [:]
    var resultDictionary:[String:Any] = [:]
    var stateDictionary:[String:Any] = [:]
    var str:String?
    var stateArray:[[String:Any]] = []
    var status:Int?
    var stateId:Int?
    var viewModel = SignUpViewModel()
    @IBOutlet weak var googleButton: UIButton!
    var textFieldNavigator: TextFieldNavigation?
    @IBOutlet weak var facebookButton: UIButton!
    var currentTextField: UITextField?
    var mobileNumber:Int?
    let text = "I agree to Terms and Conditions"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTermsConditionLabel()
        self.orSignInWith.isHidden = true
        
        self.flag = 2
        viewModel.delegate = self
        
        self.facebookButton.isHidden = true
        self.googleButton.isHidden = true
        
        
        currentTextField?.delegate = self
        fullNameField.delegate = self
        emailTextField.delegate = self
        phoneTextField.delegate = self
        addressTextField.delegate = self
        stateTextField.delegate = self
        cityTextField.delegate = self
        self.passwordTextField.delegate = self
        if #available(iOS 12.0, *) {
            self.passwordTextField.textContentType = .oneTimeCode
        } else {
            // Fallback on earlier versions
            self.passwordTextField.textContentType = .password
        }
        self.confirmPasswordField.delegate = self
        if #available(iOS 12.0, *) {
            self.confirmPasswordField.textContentType = .oneTimeCode
        } else {
            // Fallback on earlier versions
            self.confirmPasswordField.textContentType = .password
        }
        textFieldNavigator = TextFieldNavigation()
        textFieldNavigator?.textFields = [fullNameField,emailTextField,phoneTextField,cityTextField,stateTextField,addressTextField,passwordTextField,confirmPasswordField]
        
        phoneTextField.keyboardType = .phonePad
        
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
       // self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tableView.rowHeight = 80.0
        tableView.backgroundView = UIImageView(image: UIImage(named: "Background"))
        createButton.layer.cornerRadius = 8
        createButton.layer.borderWidth = 1
        createButton.layer.borderColor = UIColor.clear.cgColor
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        // let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        /*  let items = [flexSpace, done]
         doneToolbar.items = items
         doneToolbar.sizeToFit()
         */
        
        self.stateTextField.inputAccessoryView = doneToolbar
        self.stateTextField.inputView = self.pickerView
        let todosEndpoint: String = Constants.BaseUrl + "states"
        let request = AF.request(todosEndpoint)
        request.responseJSON { response in
            switch response.result {
            case .failure(let error):
                DispatchQueue.main.async {
                    //SVProgressHUD.dismiss()
                }
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
                    print("responseState \(responseString)")
                }
            case .success(let responseObject):
                DispatchQueue.main.async {
                    // SVProgressHUD.dismiss()
                    print("This is run on the main queue, after the previous code in outer block")
                }
                print("responseState \(responseObject)")
                self.resultDictionary = responseObject as! [String:Any]
                
                if let dict =  self.resultDictionary["data"] as? [String:Any] {
                    self.stateDictionary = dict
                }
                if let myArray = self.stateDictionary["states"] as? [[String:Any]] {
                    self.stateArray = myArray
                }
                self.pickerView.reloadAllComponents()
            }
        }
    }
    
    func setupTermsConditionLabel() {
        labelTermsAndCondition.text = text
        self.labelTermsAndCondition.textColor =  UIColor.white
        let underlineAttriString = NSMutableAttributedString(string: text)
        let range1 = (text as NSString).range(of: "Terms and Conditions")
             underlineAttriString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: UIFont.systemFontSize), range: range1)
             underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: range1)
        labelTermsAndCondition.attributedText = underlineAttriString
        labelTermsAndCondition.isUserInteractionEnabled = true
        labelTermsAndCondition.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(gestureTermsCondition(gesture:))))
    }
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // self.view.backgroundColor = .red
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

extension DPRegistrationVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.currentTextField = textField
    }
    
    internal func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        self.currentTextField = nil
    }
   // func textField(textField: UITextField!, shouldChangeCharactersInRange range: NSRange, replacementString string: String!) -> Bool {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let whitespaceSet = NSCharacterSet.whitespaces
        if textField == passwordTextField{
            if let _ = string.rangeOfCharacter(from: whitespaceSet){
                  return false
            }
        }else if textField == confirmPasswordField{
            if let _ = string.rangeOfCharacter(from: whitespaceSet){
                  return false
            }
        }else if textField == phoneTextField{
            let currentCharacterCount = textField.text?.count ?? 0
                   if (range.length + range.location > currentCharacterCount){
                       return false
                   }
                   let newLength = currentCharacterCount + string.count - range.length
                   return newLength <= 10
        }
        return true
     }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    
}
    
  /*  @objc func doneButtonAction(){
      
       // self.stateTextField.text  = self.stateArray.r["name"] as? String
        self.stateTextField.resignFirstResponder()
        
        
        
    }
    */
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 9
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return self.stateArray.count
    }
    
     func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        
        if pickerView == self.pickerView {
            self.str =  self.stateArray[row]["name"] as? String
            let pref:UserDefaults = UserDefaults.standard
            pref.set(str, forKey:"State")
            pref.synchronize()
            
        }
        
       // self.genderTextField.text  = pickerArray[0]["Gender"] as? String
       
       
        return self.str
 
        
    }
 
 
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       
           
        if pickerView == self.pickerView {
            self.stateTextField.text = self.stateArray[row]["name"] as? String
          
            self.stateId = self.stateArray[row]["id"] as? Int
           // self.view.endEditing(false)
        }
      
        
    
    
}
 
   
    @IBAction func createButtonTapped(_ sender: Any) {
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if self.fullNameField.text == "" {
            let alertController = UIAlertController(title: "Alert", message:"Please enter full name", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion:nil)
        }
        else if self.emailTextField.text == "" {
            let alertController = UIAlertController(title: "Alert", message:"Please enter email", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion:nil)
        }else if self.emailTextField.text?.isValidEmail() == false{
            let alertController = UIAlertController(title: "Alert", message:"Please enter valid email", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion:nil)
        }else if self.phoneTextField.text == "" {
            let alertController = UIAlertController(title: "Alert", message:"Please enter phone number", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion:nil)
        } else if self.phoneTextField.text!.count != 10{
            let alertController = UIAlertController(title: "Alert", message:"Phone number should be length of 10 digit!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion:nil)
        } else if self.cityTextField.text == "" {
            let alertController = UIAlertController(title: "Alert", message:"Please enter city name", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion:nil)
        } else if self.stateTextField.text == "" {
            let alertController = UIAlertController(title: "Alert", message:"Please enter state name", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion:nil)
        }
        else if self.addressTextField.text == ""  {
            let alertController = UIAlertController(title: "Alert", message:"Please enter address", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion:nil)
        }else if self.passwordTextField.text == ""{
            let alertController = UIAlertController(title: "Alert", message:"Please enter password", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion:nil)
        }else if self.passwordTextField.text?.isValidPassword() == false{
            let alertController = UIAlertController(title: "Alert", message:"Password must have atleast 1 capital character, 1 number, 1 symbol and minimum 8 characters", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion:nil)
        }
        else if self.confirmPasswordField.text == "" {
            let alertController = UIAlertController(title: "Alert", message:"Please enter confirm password", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion:nil)
        }else if passwordTextField.text! != confirmPasswordField.text! {
            let alertController = UIAlertController(title: "Alert", message:"Password and confirm password should be same.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion:nil)
        }

        else if checkButton.isSelected == false {
            
            let alertController = UIAlertController(title: "Alert", message:"Please accept term and conditions", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion:nil)
        }
        else {
            
            
            if let apiString = URL(string:Constants.BaseUrl + "register") {
                var request = URLRequest(url:apiString)
                request.httpMethod = "POST"
                
                request.setValue("application/json",
                                 forHTTPHeaderField: "Content-Type")
                
                let values = [
                    
                    "name":self.fullNameField.text!,
                    "email":self.emailTextField.text!,
                    "password":self.passwordTextField.text!,
                    "password_confirmation":self.confirmPasswordField.text!,
                    "phone":self.phoneTextField.text!,
                    "city":self.cityTextField.text!,
                    "state_id":self.stateId as Any,
                    "address":self.addressTextField.text!,"referral_code":self.referralCodeField.text!]
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
                                print("response \(responseObject)")
                                SVProgressHUD.dismiss()
                                if let dict = responseObject as? [String:Any] {
                                    self.responseDictiomary = dict
                                    print("ResponseDictionary \(self.responseDictiomary)")
                                }
                                if let mssg = self.responseDictiomary["message"] as? String {
                                    self.message = mssg
                                    let status = self.responseDictiomary["status"] as? Int
                                    if status == 0 {
                                        let alertController = UIAlertController(title: "Alert", message:self.message, preferredStyle: .alert)
                                        let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                                            
                                        }
                                        alertController.addAction(okAction)
                                        self.present(alertController, animated: true, completion:nil)
                                        
                                    }
                                    else if status == 1{
                                        
                                        
                                        
                                        let alertController = UIAlertController(title: "Alert", message:self.message, preferredStyle: .alert)
                                        let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                            let menuVC  = storyboard.instantiateViewController(withIdentifier: "DPOTPVC") as? DPOTPVC
                                            menuVC?.mobile =  self.phoneTextField.text!
                                            menuVC?.flags = self.flag
                                            print("MenuVC.Flags \(String(describing: menuVC?.flags))")
                                            self.navigationController?.pushViewController(menuVC!, animated:true)
                                            print("you have pressed the Ok button");
                                        }
                                        alertController.addAction(okAction)
                                        self.present(alertController, animated: true, completion:nil)
                                    }
                                }
                                print("This is run on the main queue, after the previous code in outer block")
                            }
                            self.tableView.reloadData()
                        }
                    }
            }
        }
    }
}
extension DPRegistrationVC : signDataImage{
    func getError(message: String) {
        print(message)
    }
    func getData(data: SData?) {
        print(data)
        let userID = data?.userId
        Helper.saveStringInDefault(key: "userID", value:String(userID!))
        print(Helper.fetchString(key: "userID"))
        /*  let storyboard = UIStoryboard(name: "Main", bundle: nil)
         let menuVC  = storyboard.instantiateViewController(withIdentifier: "PaymentInformation") as? PaymentInformation
         self.navigationController?.pushViewController(menuVC!, animated: false)
         */
    }
}

