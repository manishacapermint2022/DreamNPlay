//
//  DPBankDetailVC.swift
//  DreamPlay
//
//  Created by MAC on 14/06/21.
//

import UIKit
import Alamofire
import SVProgressHUD
import SkyFloatingLabelTextField
import SideMenu
import KSToastView

class DPBankDetailVC: UITableViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet weak var saveButton: UIButton!
    
    let userId: Any? = ""//UserDefaults.standard.object(forKey:"UserID") as Any?
    var isOpen = false
    var screenCheck = false
    var imageData:Data?
    var userImage:String?
    var message:String?
    var token:String?
    var photo1:UIImage?
    var dataDictionary:[String:Any] = [:]
    var bankDictionary:[String:Any] = [:]
    var adhaarVerifiedStatus:Int?
    var userName:String?
    var sideMenu:SideMenuNavigationController?
    var flag:Int?
    @IBOutlet weak var noFileSelectedLabel: UILabel!
    var userid:String?
    var userDetailDictionary:[String:Any] = [:]
    @IBOutlet weak var accountHolderName: SkyFloatingLabelTextField!
    
    @IBOutlet weak var branchNameField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var ifscCodeField: SkyFloatingLabelTextField!
    @IBOutlet weak var accountNumberField: SkyFloatingLabelTextField!
    @IBOutlet weak var bankNameField: SkyFloatingLabelTextField!
    @IBOutlet weak var lblWallet: UILabel!
    
    var responseDictionary:[String:Any] = [:]
    var walletView : UIView!
    //var walletlabel : UILabel!
    var userDictionary:[String:Any] = [:]
    var textFieldNavigator: TextFieldNavigation?
    var currentTextField: UITextField?
    var name:String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        
        if self.flag == 1 {
            self.userName = self.userDetailDictionary["name"] as? String
            print("UserNamess1\(String(describing:userName))")
            
        }
        else if self.flag == 2 {
            self.userName = name
            print("UserNamess2\(String(describing:userName))")
        }
        currentTextField?.delegate = self
        accountHolderName.delegate = self
        bankNameField.delegate = self
        accountNumberField.delegate = self
        branchNameField.delegate = self
        ifscCodeField.delegate = self
        
        textFieldNavigator = TextFieldNavigation()
        textFieldNavigator?.textFields = [accountHolderName,bankNameField,accountNumberField,branchNameField,ifscCodeField]
        
        self.setupMenu()
        self.setupWalletView()
        
        print("UserDetailDictionary\(String(describing:userDetailDictionary))")
        
        self.adhaarVerifiedStatus = self.userDetailDictionary["aadhar_verified"] as? Int
        print("AdhaarVerifiedStatus\(String(describing:adhaarVerifiedStatus))")
        self.userName = self.userDetailDictionary["name"] as? String
        print("UserName\(String(describing:userName))")
        self.adhaarVerifiedStatus = self.userDetailDictionary["aadhar_verified"] as? Int
        print("AdhaarVerifiedStatus\(String(describing:adhaarVerifiedStatus))")
        
        token = UserDefaults.standard.string(forKey:"AccessToken")!
        print("Token :", token as Any)
        self.bankDetails()
        
//        if self.adhaarVerifiedStatus == 0 {
//            let alertController = UIAlertController(title: "Alert", message: "Adhar card not verified", preferredStyle: .alert)
//            let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
//                self.navigationController?.popViewController(animated: true)
//                print("you have pressed the Ok button");
//            }
//            alertController.addAction(okAction)
//            self.present(alertController, animated: true, completion:nil)
//
//            //KSToastView.ks_showToast("Aadhar Card not verified", duration: 4.0) {
//            // KSToastView.ks_showToast("Game Over!", delay: 0.5)
//        }
        
        
        //showToast(message: "Aadhar Card not verified")
        /*
         */
//        else{
//            self.tableView.rowHeight = 80.0
//            let logo = UIImage(named:"layer3")
//            let imageView = UIImageView(image:logo)
//            imageView.frame = CGRect(x: 150, y: 20, width: 180.0, height: 30.0)
//            self.navigationItem.titleView = imageView
//            tableView.backgroundView = UIImageView(image: UIImage(named: "Background"))
//            saveButton.layer.cornerRadius = 8
//            saveButton.layer.borderWidth = 1
//            saveButton.layer.borderColor = UIColor.clear.cgColor
//            let toggleButton = UIBarButtonItem(image: UIImage(named: "group12"),
//                                               style: .plain,
//                                               target: self,
//                                               action: #selector(DPBankDetailVC.toggle))
//            self.navigationItem.leftBarButtonItem = toggleButton
//            self.walletAmount()
//            if let id = self.userDetailDictionary["id"] as? Int {
//                //        if let id = self.userId as? Int {
//                self.userid = String(id)
//            }
//            print("UserID \(String(describing: userId))")
//        }
    }
    @IBAction func btnMenu(_ sender: UIButton){
       // viewHeader.isHidden = true
        present(sideMenu!, animated: true, completion: nil)
    }
    @IBAction func btnWalletClick(_ sender: UIButton){
        let menuVC  = storyboard?.instantiateViewController(withIdentifier: "DPWalletVC") as? DPWalletVC
        self.navigationController?.pushViewController(menuVC!, animated:true)
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
        //SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        SideMenuManager.default.leftMenuNavigationController = self.sideMenu
    }
    
    func bankDetails(){
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data","Authorization":"Bearer" + " " + token!,"X-Requested-With":"XMLHttpRequest"]
        let url = Constants.BaseUrl + "bank_accounts?user_id=\(self.userId!)"
        print("URL:" + url)
        SVProgressHUD.show()
        AF.upload(
            multipartFormData: { multipartFormData in },
            to: url, method: .get , headers: headers) .responseJSON { response in
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
                        print("response \(responseString)")  //34978723403
                    }
                case .success(let responseObject):
                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                        print("responseObject \(responseObject)")
                        self.responseDictionary = responseObject as! [String:Any]
                        if let dict = self.responseDictionary["data"]
                            as? [String:Any] {
                            self.dataDictionary = dict
                            print("DataDictionary \(self.dataDictionary)")
                        }
                        if let user = self.dataDictionary["bank_account"] as? [String:Any] {
                            self.bankDictionary = user
                            print("BankDictionary \(self.bankDictionary)")
                        }
                        
                        self.accountHolderName.text = self.bankDictionary["account_holder_name"] as? String
                        self.bankNameField.text = self.bankDictionary["name"] as? String
                        self.accountNumberField.text = self.bankDictionary["account_number"] as? String
                        self.ifscCodeField.text = self.bankDictionary["ifsc_code"] as? String
                        self.branchNameField.text = self.bankDictionary["branch"] as? String
                        /* let encodedImageData = self.bankDictionary["Image"] as! String?
                         
                         print("encodedImageData \(encodedImageData)")
                         
                         
                         let imageData = NSData(base64Encoded: encodedImageData!, options:   NSData.Base64DecodingOptions(rawValue:0))
                         
                         
                         
                         print("Data \(imageData)")
                         
                         let image = UIImage(data:imageData as! Data)
                         
                         
                         print("Image \(image)")
                         
                         self.profileImage.image = image
                         */
                        
                    }
                }
            }
    }
    
    func setupWalletView(){
        walletView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 92, height: 33))
        walletView.backgroundColor = .clear
        let imageView = UIImageView(image:#imageLiteral(resourceName: "wallet"))
        walletView.addSubview(imageView)
        imageView.frame = CGRect(x: walletView.frame.width/2-20/2, y: 0, width: 20, height: 20)
//        walletlabel = UILabel.init(frame: CGRect.init(x: 0, y: imageView.frame.maxY + 3, width: walletView.frame.width, height: 10))
//        walletlabel.textColor = .white
//        walletlabel.font = UIFont.systemFont(ofSize: 11)
//        walletlabel.text = " "
//        walletlabel.textAlignment = .center
//        walletView.addSubview(walletlabel)
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(DPHomePageVC.handleTap(_:)))
        walletView.addGestureRecognizer(tap1)
        let btn = UIBarButtonItem.init(customView: walletView)
        self.navigationItem.rightBarButtonItem = btn
        
    }
    
    func getJson(ifscCode: String, completion: @escaping (IFSCModel)-> ()) {
        let urlString = "https://ifsc.razorpay.com/\(ifscCode)"
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) {data, res, err in
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let json: IFSCModel = try decoder.decode(IFSCModel.self, from: data)
                        completion(json)
                    }catch let error {
                        print(error.localizedDescription)
                    }
                }
            }.resume()
        }
    }
    
    func callIFSCApi(str: String) {
        Console.log("callIFSCApi Fine")
        getJson(ifscCode: str) { (json) in
            DispatchQueue.main.async {
                self.branchNameField.text = json.BRANCH
                self.bankNameField.text = json.BANK
            }
        }
    }
}
    
struct IFSCModel: Codable {
    //let MICR: String?
    let BRANCH: String?
    let ADDRESS: String?
    let STATE: String?
   // let CONTACT: String?
    //let UPI: Bool?
   // let RTGS: Bool?
    let CITY: String?
  //  let CENTRE: String?
  //  let DISTRICT: String?
  //  let NEFT: Bool?
  //  let IMPS: Bool?
  //  let SWIFT: String?
  //  let ISO3166: String?
    let BANK: String?
    let BANKCODE: String?
    let IFSC: String?
}


extension DPBankDetailVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.currentTextField = textField
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == ifscCodeField {
            let maxLength = 11
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =  currentString.replacingCharacters(in: range, with: string) as NSString
            Console.log(newString)
            if newString.length == maxLength {
                callIFSCApi(str : newString as String)
            }
            return newString.length <= maxLength
        }
        return true
    }
    
    
    
    internal func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        self.currentTextField = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let menuVC  = storyboard?.instantiateViewController(withIdentifier: "DPWalletVC") as? DPWalletVC
        self.navigationController?.pushViewController(menuVC!, animated:true)
    }
    
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
                        SVProgressHUD.dismiss()
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
                        //
                        let stramount = self.getAmount(self.userDictionary["balance"] as Any )
                        self.lblWallet.text = "₹" + (stramount.isEmpty ? "0" : stramount)
                        
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
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 100, y: self.view.frame.size.height-300, width: 200, height: 35))
        toastLabel.textAlignment = .center
        //toastLabel.alignmentRect(forFrame: <#T##CGRect#>)
        toastLabel.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.black
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 10.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    @IBAction func profileButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menuVC  = storyboard.instantiateViewController(withIdentifier: "DPProfileVC") as? DPProfileVC
        //menuVC?.createDictionary = self.contestDictionary
        self.navigationController?.pushViewController(menuVC!, animated: false)
    }
    @objc func toggle(){
        present(sideMenu!, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
       // self.navigationController?.setNavigationBarHidden(false, animated: false)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.bankDetails()
        //self.tabBarController?.tabBar.isHidden = true
    }
    
   
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    
    func isValidate() -> Bool {
        guard let ifscCode = ifscCodeField.text, !ifscCode.trim().isEmpty else {
            self.showAlert("IFSC code count not empty.")
            return false
        }
        if charactorCount(ifscCode.count) {
            return true
        } else {
            return false
        }
    }
    
    func charactorCount(_ count: Int) -> Bool {
        if count > 10 {
            return true
        } else {
            self.showAlert("Please enter valid IFSC code.")
            return false
        }
    }
    
    func saveBankDetails() {
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else  if self.userName?.lowercased() != self.self.accountHolderName.text!.lowercased() {
            //print("BankNameField \(String(describing: self.bankNameField.text))")
            // print("UserNames \(String(describing: self.userName))")
            let alertController = UIAlertController(title: "Alert", message: "Name not matched", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion:nil)
        }
        else{
            let id = self.bankDictionary["id"] as? Int ?? 0
            var parameters = [
                "account_holder_name":self.accountHolderName.text!,
                "name":self.bankNameField.text!,
                "account_number":self.accountNumberField.text!,
                "branch":self.branchNameField.text! ,
                "ifsc_code":self.ifscCodeField.text!] as [String : Any]
            if id > 0 { //for new account register
                parameters["_method"] = "PUT"
            }
            print("Parametersss \(String(describing:parameters))")
            let ID:String = (id == 0) ? "" : "\(id)"
            let url = Constants.BaseUrl + "bank_accounts/"+ID
            print("API URL: \(url)")
            var header = HTTPHeaders()
            header = ["Content-type": "multipart/form-data",
                      "Authorization":"Bearer" + " " + token!,
                      "X-Requested-With":"XMLHttpRequest"]
            AF.upload(multipartFormData: { multipartFormData in
                if let img = self.imageData {
                    multipartFormData.append(img, withName:"photo", fileName: "File.jpg", mimeType: "image/jpg")
                }
                for (key, value) in parameters {
                    if let temp = value as? String {
                        multipartFormData.append(temp.data(using: .utf8)!, withName: key)
                    }
                    else if let temp = value as? Int {
                        multipartFormData.append("\(temp)".data(using: .utf8)!, withName: key)
                    }
                    else if let temp = value as? NSArray {
                        temp.forEach({ element in
                            let keyObj = key + "[]"
                            if let string = element as? String {
                                multipartFormData.append(string.data(using: .utf8)!, withName: keyObj)
                            } else
                            if let num = element as? Int {
                                let value = "\(num)"
                                multipartFormData.append(value.data(using: .utf8)!, withName: keyObj)
                            }
                        })
                    }
                }
                //    multipartFormData.append(self.imageData!, withName:"image", fileName: "File.jpg", mimeType: "image/jpg")
            }, to:url, method: .post , headers: header).responseJSON(completionHandler: { (response) in
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
                        SVProgressHUD.dismiss()
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
                            let alertController = UIAlertController(title: "Alert", message: self.message, preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                                print("you have pressed the Ok button");
                            }
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true, completion:nil)
                        }
                    }
                }
            }
        )}
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if isValidate() {
            saveBankDetails()
        }
    }
    @IBAction func chooseFileButtonTapped(_ sender: Any) {
        
        let actionSheetController: UIAlertController = UIAlertController(title: "Action Sheet", message: "Swiftly Now! Choose an option!", preferredStyle: .actionSheet)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
        }
        actionSheetController.addAction(cancelAction)
        let takePictureAction: UIAlertAction = UIAlertAction(title: "Take Picture", style: .default) { action -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerController.SourceType.camera;
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
            
        }
        actionSheetController.addAction(takePictureAction)
        let choosePictureAction: UIAlertAction = UIAlertAction(title: "Choose From Camera Roll", style: .default) { action -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary;
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        actionSheetController.addAction(choosePictureAction)
        
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width:size.width * heightRatio, height:size.height * heightRatio)
        } else {
            newSize = CGSize(width:size.width * widthRatio,  height:size.height * widthRatio)
        }
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x:0, y:0, width:newSize.width, height:newSize.height)
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 8.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    
    
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        
        //SVProgressHUD.show()
        photo1 = info[UIImagePickerController.InfoKey.originalImage] as? UIImage //2
        let img = self.resizeImage(image: self.photo1!, targetSize:CGSize(width:100.0 , height:100.0))
        
        photo1 = img //4
        //  print("profileImage \(String(describing: self.documentImageView.image))")
        if let image  = photo1,let imageData = image.jpegData(compressionQuality: 8.0){
            
            self.imageData = imageData
            self.dismiss(animated:true, completion: nil)}
        
        dismiss(animated:true, completion: nil)
        self.noFileSelectedLabel.text = "File Selected"
    }
}

   

