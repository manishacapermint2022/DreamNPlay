//
//  TermsConditionVC.swift
//  DreamPlay
//
//  Created by sismac020 on 09/05/22.
//


import UIKit
import WebKit
import Alamofire
import SVProgressHUD
import SideMenu

class TermsConditionVC: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var labelHtml: UILabel!
    
    
    var isOpen = false
    var screenCheck = false
    var token:String?
    var sideMenu:SideMenuNavigationController?
    var walletView : UIView!
    var walletlabel : UILabel!
    var dataDictionary:[String:Any] = [:]
    var userDictionary:[String:Any] = [:]
    var responseDictionary:[String:Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logo = UIImage(named:"layer3")
        let imageView = UIImageView(image:logo)
        imageView.frame = CGRect(x: 150, y: 20, width: 100.0, height: 30.0)
        self.navigationItem.titleView = imageView
        
        token = UserDefaults.standard.string(forKey:"AccessToken") ?? ""
        print("Token :", token as Any)
        
        
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        else{
            
            SVProgressHUD.show()
            let headers: HTTPHeaders = ["Content-type": "multipart/form-data","X-Requested-With":"XMLHttpRequest"]
            
            AF.upload(
                multipartFormData: { multipartFormData in
                    
                    
                },
                to: Constants.BaseUrl + "pages/terms", method: .get , headers: headers)
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
                    SVProgressHUD.dismiss()
                    DispatchQueue.main.async {
                        print("responseObject \(responseObject)")
                        self.responseDictionary = responseObject as! [String:Any]
                        if let data = self.responseDictionary["data"]  as? [String:Any] {
                            self.dataDictionary = data
                        }
                        print("DataDictionary \(self.dataDictionary)")
                        let message = self.dataDictionary["data"] as? String ?? ""
                        self.labelHtml.attributedText = message.htmlToAttributedString
                        self.labelHtml.textColor = .white
                        self.labelHtml.font = UIFont(name: "Helvetica Neue", size: 17.0)
                        // self.webView.loadHTMLString(fontSetting + "<html><body>\(String(describing: message))</body></html>", baseURL: nil)
                    }
                }
            }
        }
    }

    @IBAction func btnMenu(_ sender: UIButton){
        present(sideMenu!, animated: true, completion: nil)
    }
    
    @IBAction func buttonBackTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
    
