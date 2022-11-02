//
//  DPLoginVC+Action.swift
//  DreamPlay
//
//  Created by sismac020 on 18/04/22.
//

import UIKit
import SVProgressHUD
import Alamofire

extension DPLoginVC {
    @objc func keyboardDidShow(notification: NSNotification) {
        let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardSize:CGSize = keyboardFrame.size
        let contentInsets:UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        tableView.contentInset = contentInsets
        tableView.scrollIndicatorInsets = contentInsets
        var aRect:CGRect = self.view.frame
        aRect.size.height -= keyboardSize.height
        if currentTextField != nil {
            if !(aRect.contains(currentTextField!.frame.origin)) {
                tableView.scrollRectToVisible(currentTextField!.frame, animated: true)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsents:UIEdgeInsets = UIEdgeInsets.zero
        tableView.contentInset = contentInsents
        tableView.scrollIndicatorInsets = contentInsents
    }
    
    @IBAction func SignUpButtonTapped(_ sender:UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menuVC  = storyboard.instantiateViewController(withIdentifier: "DPRegistrationVC") as? DPRegistrationVC
        self.navigationController?.pushViewController(menuVC!, animated: true)
    }
    
    @IBAction func loginOTPButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menuVC  = storyboard.instantiateViewController(withIdentifier: "DPVerifyMobileVC") as? DPVerifyMobileVC
        self.navigationController?.pushViewController(menuVC!, animated: true)
    }
    // MARK: - Table view data source
    @IBAction func loginButtonTapped(_ sender: Any) {
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            }else if self.emailTextField.text == "" {
                let alertController = UIAlertController(title: "Alert", message:"Please enter email", preferredStyle: .alert)
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
        }else{
            SVProgressHUD.show()
            if let apiString = URL(string:Constants.BaseUrl + "login") {
                var request = URLRequest(url:apiString)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                let values = ["email":emailTextField.text!, "password":passwordTextField.text!]as [String : Any]
                print("Values \(values)")
                request.httpBody = try! JSONSerialization.data(withJSONObject: values)
                AF.request(request).responseJSON { response in
                    // do whatever you want here
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
                            print("responseObjectLogin \(responseObject)")
                            SVProgressHUD.dismiss()
                            self.responseDictionary = responseObject as! [String:Any]
                            self.message = self.responseDictionary["message"] as? String
                            
                            
                            self.status = self.responseDictionary["status"] as? Int
                            
                            if self.status == 0 {
                                let alertController = UIAlertController(title: "Alert", message:self.message, preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                                    /*let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                     let menuVC  = storyboard.instantiateViewController(withIdentifier: "DPVerifyMobileVC") as? DPVerifyMobileVC
                                     self.navigationController?.pushViewController(menuVC!, animated:true)
                                     */
                                    print("you have pressed the Ok button");
                                }
                                alertController.addAction(okAction)
                                self.present(alertController, animated: true, completion:nil)
                            }
                            else if self.status == 1 {
                                
                                
                                if let dict = self.responseDictionary["data"] as? [String:Any] {
                                    self.dataDictionary = dict
                                    print("DataDictionaryLogin \(self.dataDictionary)")
                                }
                                
                                if let dict = self.dataDictionary["user"] as? [String:Any] {
                                    self.userDictionary = dict
                                    // let prefs:UserDefaults = UserDefaults.standard
                                    //prefs.set(dict, forKey: "user_detail")
                                }
                                self.authenticationToken = self.dataDictionary["token"] as? String
                                self.balance = self.userDictionary["balance"] as? Int
                                self.name = self.userDictionary["name"] as? String
                                self.referralCode = self.userDictionary["referral_code"] as? String
                                self.phone = self.userDictionary["phone"] as? String
                                print("LoginBalance \(String(describing: self.balance))")
                                print("ReferenceCode \(String(describing: self.referralCode))")
                                let prefs:UserDefaults = UserDefaults.standard
                                prefs.set(self.authenticationToken, forKey: "AccessToken")
                                prefs.set(self.phone, forKey: "Phone")
                                prefs.set(self.balance, forKey: "Balance")
                                prefs.set(self.name, forKey: "Name")
                                prefs.set(self.referralCode, forKey: "ReferralCode")
                                let teamUserName = self.userDictionary["username"] as? String
                                prefs.set(teamUserName, forKey: "UserTeamName")
                                
                                prefs.synchronize()
                                // self.delegate?.passingData(message: self.text!)
                                self.saveLogin()
                                
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let homeVC  = storyboard.instantiateViewController(withIdentifier: "UITabBarController") as? TabBarController//UITabBarController
                                AppDelegate.getAppDelegate().setRoot(homeVC as AnyObject)
                                //                                                self.navigationController?.pushViewController(menuVC!, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
}
