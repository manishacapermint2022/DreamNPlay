//
//  DPWalletPopViewController.swift
//  DreamPlay
//
//  Created by MAC on 06/08/21.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire
import SVProgressHUD
import Razorpay

protocol DPWalletPopViewControllerDelegate:AnyObject {
    func paymentStatus(_ status:Bool)
    
}

class DPWalletPopViewController: UIViewController,UITextFieldDelegate {
    weak var delegate:DPWalletPopViewControllerDelegate?
    var token:String?
    @IBOutlet weak var amountTextField: UITextField!
    var responseDictionary:[String:Any] = [:]
    @IBOutlet weak var addMoneyButton: UIButton!
    var dataDictionary:[String:Any] = [:]
    var userDictionary:[String:Any] = [:]
    var razorpay: RazorpayCheckout!
    var key:String?
    var paymentId:String = ""
    var message:String?
    var status:String?
    var paymentArray:[[String:Any]] = []
    var textFieldNavigator: TextFieldNavigation?
   
    @IBOutlet weak var popupView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        addMoneyButton.cornerRadius = 8
        popupView.cornerRadius = 8
        amountTextField.placeholderColor = .white
        token = UserDefaults.standard.string(forKey:"AccessToken")!
        print("Token :", token as Any)
        self.amountTextField.keyboardType = .numberPad
        textFieldNavigator = TextFieldNavigation()
        textFieldNavigator?.textFields = [self.amountTextField]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // self.view.backgroundColor = .red
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardDidShow(notification: NSNotification) {
            let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            let keyboardSize:CGSize = keyboardFrame.size
            let contentInsets:UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
           // tableView.contentInset = contentInsets
//           //tableView.scrollIndicatorInsets = contentInsets
//            var aRect:CGRect = self.view.frame
//            aRect.size.height -= keyboardSize.height
//            if amountTextField != nil {
//                self.view.frame = CGRect.init(x: 0, y: self.view.frame.origin.y, width: <#T##CGFloat#>, height: <#T##CGFloat#>)
//            }
        }
        
        @objc func keyboardWillHide(notification: NSNotification) {
            let contentInsents:UIEdgeInsets = UIEdgeInsets.zero
//            tableView.contentInset = contentInsents
//            tableView.scrollIndicatorInsets = contentInsents
        }
    
    func goPayment(_ key:String, _ dic:[String:Any]){
//        "rzp_live_kHzfM8JQ2BFdjE"
        self.razorpay = RazorpayCheckout.initWithKey(key, andDelegate: self)
        self.razorpay.open(dic)//open(dic, displayController: self)
    }
}
extension DPWalletPopViewController : RazorpayPaymentCompletionProtocol {

            func onPaymentError(_ code: Int32, description str: String) {
                print("error: ", code, str)
                
            }

            func onPaymentSuccess(_ payment_id: String) {
                print("success: ", payment_id)
                self.paymentId = payment_id
                self.savePayment()
                
               
                //self.present(withTitle: "Success", message: "Payment Succeeded")
            
        }
    
    func walletDetail(){
        
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data","Authorization":"Bearer" + " " + token!,"X-Requested-With":"XMLHttpRequest"]

                   AF.upload(
                       multipartFormData: { multipartFormData in
                       
                        multipartFormData.append((self.amountTextField.text!).data(using: String.Encoding.utf8)!, withName:"amount")

                   },
                    to: Constants.BaseUrl + "generate_hash", method: .post , headers: headers)
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
                                if let user = self.dataDictionary["data"] as? [String:Any] {
                                    self.userDictionary = user
                                    print("UserDictionary \(self.userDictionary)")
                                    if let key = self.userDictionary["key"] as? String{
                                        self.goPayment(key,user)
                                    }
                                    self.navigationController?.dismiss(animated: true, completion: nil)
                                }
                                
                            }
                                }
                            }
                        }
                       
        
      }
    
    
    func savePayment(){
        
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
       
        SVProgressHUD.show()
                           
                           if let apiString = URL(string:Constants.BaseUrl + "payments") {
                               var request = URLRequest(url:apiString)
                               request.httpMethod = "POST"
                               request.setValue("application/json",
                                                forHTTPHeaderField: "Content-Type")
                            request.setValue("XMLHttpRequest",
                                             forHTTPHeaderField: "XMLHttpRequest")
                            request.setValue("Bearer" + " " + token!,
                                             forHTTPHeaderField: "Authorization")
                               
                            let values = ["amount":self.amountTextField.text!,
                                          "payment_id":self.paymentId as Any]as [String : Any]
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
                                            self.delegate?.paymentStatus(false)
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
                                            
                                            if let dict = self.dataDictionary["payments"] as? [[String:Any]] {
                                                self.paymentArray = dict
                                                
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
                                                
                                                self.delegate?.paymentStatus(true)
                                                self.dismissPopUp(UIButton())
//                                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//
//                                                let homeVC  = storyboard.instantiateViewController(withIdentifier: "UITabBarController") as? UITabBarController
//
//                                                AppDelegate.getAppDelegate().setRoot(homeVC as AnyObject)
//                                                self.navigationController?.pushViewController(menuVC!, animated: true)
                                            }
                                           }
                                          
                                           }
                                       
                                   }
                           
        }
    }
                        }
    
    @IBAction func dismissPopUp(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        self.navigationController?.dismiss(animated: true, completion: nil)
        
       }
                       
    @IBAction func addMoneyButtonTapped(_ sender: Any) {
        self.walletDetail()
        
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
