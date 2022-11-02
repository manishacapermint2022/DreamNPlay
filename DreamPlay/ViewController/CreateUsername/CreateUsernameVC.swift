//
//  CreateUsernameVC.swift
//  DreamPlay
//
//  Created by sismac20 on 20/05/22.
//

import UIKit
import SVProgressHUD
import Alamofire
 
class CreateUsernameVC: UIViewController {
    
    @IBOutlet weak var textFieldTeamName: UITextField!
    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var viewCard: UIView!
    var token: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    
    func setup() {
        token = UserDefaults.standard.string(forKey:"AccessToken")!
        viewCard.makeCornerRadius(15)
        buttonSubmit.makeCornerRadius(buttonSubmit.frame.size.height / 2)
    }
    func addCreateTeamAPI() {
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            SVProgressHUD.show()
            if let apiString = URL(string:Constants.BaseUrl + "update/username") {
                var request = URLRequest(url:apiString)
                request.httpMethod = "POST"
                request.setValue("application/json",
                                 forHTTPHeaderField: "Content-Type")
                request.setValue("X-Requested-With",
                                 forHTTPHeaderField:"XMLHttpRequest")
                request.setValue("Bearer" + " " + token!, forHTTPHeaderField: "Authorization")
                let values = [
                    "username": textFieldTeamName.text!] as [String : Any]
                print("Values \(values)")
                request.httpBody = try! JSONSerialization.data(withJSONObject: values)
                AF.request(request)
                    .responseJSON { response in
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
                            print("response \(responseObject)")
                            
                            let responseDictionary = responseObject as! [String:Any]
                            if let dict = responseDictionary["data"] as? [String:Any] {
                                let username = dict["username"] as? String
                                let prefs:UserDefaults = UserDefaults.standard
                                prefs.set(username, forKey: "UserTeamName")
                                let Name = UserDefaults.standard.string(forKey: "Name")
                                 if Name == "" {
                              //  if kUserDefaults.getUserTeamName() == "" {
                                    return
                                } else {
                                    self.dismiss(animated: false)
//                                    let menuVC  = self.storyboard?.instantiateViewController(withIdentifier: "DPTeamSelectionVC") as? DPTeamSelectionVC
//                                    self.navigationController?.viewControllers.insert(menuVC!, at: 2)
                                 //   self.navigationController?.pushViewController(menuVC!, animated: true)
                                }
                            }
                        }
                        SVProgressHUD.dismiss()
                    }
            }
        }
    }
}



extension CreateUsernameVC {
    @IBAction func buttonCloseTapped(_ sender: UIButton) {
        Console.log("buttonCloseTapped")
        dismiss(animated: true)
    }
    @IBAction func buttonSubmitTapped(_ sender: UIButton) {
        Console.log("buttonSubmitTapped")
        if isValidate() {
            addCreateTeamAPI()
        }
    }
    
    func isValidate() -> Bool {
        guard let text = textFieldTeamName.text, !text.isEmpty else {
            showAlert("Please enter name")
            return false
        }
        return true
    }
    
    
}
