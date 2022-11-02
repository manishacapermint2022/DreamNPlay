//
//  DPWithdrawPopupVC.swift
//  DreamPlay
//
//  Created by MAC on 09/08/21.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire
import SVProgressHUD

protocol DPWithdrawPopupVCDelegate:AnyObject {
    func withdrawStatus(_ status:Bool)
    
}

class DPWithdrawPopupVC: UIViewController {
 
    weak var delegate:DPWithdrawPopupVCDelegate?
    var message:String?
    var responseDictionary:[String:Any] = [:]
    var dataDictionary:[String:Any] = [:]
    var token:String?
    @IBOutlet var amountTextField: UITextField!
    @IBOutlet var borderView: UIView!
    @IBOutlet var submitButton: UIButton!
    var textFieldNavigator: TextFieldNavigation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        submitButton.cornerRadius = 8
        borderView.cornerRadius = 8
        amountTextField.placeholderColor = .white
        
        token = UserDefaults.standard.string(forKey:"AccessToken")!
        print("Token :", token as Any)
        self.amountTextField.keyboardType = .numberPad
        textFieldNavigator = TextFieldNavigation()
        textFieldNavigator?.textFields = [self.amountTextField]
    }
    
    @IBAction func dismissPopUp(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        self.navigationController?.dismiss(animated: true, completion: nil)
        
       }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        
        widthdrawAmount()
        
    }
    
    func widthdrawAmount(){
        
            
            if isInternetAvailable() == false{
                let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else{
           
            SVProgressHUD.show()
                               
                               if let apiString = URL(string:Constants.BaseUrl + "withdraw") {
                                   var request = URLRequest(url:apiString)
                                   request.httpMethod = "POST"
                                   request.setValue("application/json",
                                                    forHTTPHeaderField: "Content-Type")
                                request.setValue("XMLHttpRequest",
                                                 forHTTPHeaderField: "XMLHttpRequest")
                                request.setValue("Bearer" + " " + token!,
                                                 forHTTPHeaderField: "Authorization")
                                   
                                let values = ["amount":self.amountTextField.text!]as [String : Any]
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
                                                self.delegate?.withdrawStatus(false)
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
                                                self.message = self.responseDictionary["message"] as? String
                                                if let dict = self.responseDictionary["data"] as? [String:Any] {
                                                    self.dataDictionary = dict
                                                    print("DataDictionary \(self.dataDictionary)")
                                                }
                                                
                                               
                                               
                                                
                                                let status = self.responseDictionary["status"] as? Bool ?? false
                                                
                                                if status == false {
                                                    let alertController = UIAlertController(title: "Alert", message:self.message, preferredStyle: .alert)
                                                    let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                                                      
                                                        print("you have pressed the Ok button");
                                                    }
                                                    alertController.addAction(okAction)
                                                    self.present(alertController, animated: true, completion:nil)
                                                }
                                                else if status == true {
                                                    
                                                    self.delegate?.withdrawStatus(true)
                                                    self.dismissPopUp(UIButton())
    
    
    

                                                }
                                                                                           
                                               }
                                           }
                                       }
                               }
            }
        
    }
}
