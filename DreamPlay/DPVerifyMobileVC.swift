//
//  DPVerifyMobileVC.swift
//  DreamPlay
//
//  Created by MAC on 22/07/21.
//

import UIKit
import Alamofire
import SVProgressHUD

class DPVerifyMobileVC: UIViewController {

    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    let fixtureId: Any? = UserDefaults.standard.object(forKey:"FixtureId") as Any?
    var token:String?
    var responseDictionary:[String:Any] = [:]
    var message:String?
    var status:Int?
    var mobileNum:Int?
    var flag:Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 8
         loginButton.layer.borderWidth = 1
         loginButton.layer.borderColor = UIColor.clear.cgColor
        let logo = UIImage(named:"layer3")
        let imageView = UIImageView(image:logo)
        imageView.frame = CGRect(x: 150, y: 20, width: 100.0, height: 30.0)
        self.navigationItem.titleView = imageView

        self.flag = 1
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
      // navigationController?.setNavigationBarHidden(true, animated: true)
        
        
       
//        userImg.image = UIImage(data:Data(contentsOf: URL(string: Helper.getUserDetails()?.i ?? "First name" )))
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    @IBAction func loginButtonTapped(_ sender: Any) {
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
                        multipartFormData.append((self.mobileTextField.text!).data(using: String.Encoding.utf8)!, withName:"phone")
                       
                        
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
                                   // self.message = self.adhaarDictionary["message"] as? String
                                    let alertController = UIAlertController(title: "Alert", message: self.message, preferredStyle: .alert)
                                    let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                                        print("you have pressed the Ok button");
                                    }
                                    alertController.addAction(okAction)
                                    self.present(alertController, animated: true, completion:nil)
                                
                                }
                                else if self.status == 1{
                                    
                                
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    let menuVC  = storyboard.instantiateViewController(withIdentifier: "DPOTPVC") as? DPOTPVC
                                    menuVC?.mobile = self.mobileTextField.text!
                                    menuVC?.flags = self.flag
                                   // menuVC?.topDictionary = self.contestDictionary
                                    
                                    self.navigationController?.pushViewController(menuVC!, animated: true)
                                  
                                   
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
        }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */



