//
//  DPProfileVC.swift
//  DreamPlay
//
//  Created by MAC on 14/06/21.
//

import UIKit
import Alamofire
import SVProgressHUD
import SkyFloatingLabelTextField
import SideMenu
import SDWebImage
import KSToastView

class DPProfileVC: UITableViewController,UIPickerViewDelegate,UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var isOpen = false
    var screenCheck = false
    var photo1:UIImage?
    var responseDictionary:[String:Any] = [:]
    var dataDictionary:[String:Any] = [:]
    var userDictionary:[String:Any] = [:]
    var resultDictionary:[String:Any] = [:]
    var stateDictionary:[String:Any] = [:]
    var imageData:Data?
    var userImage:String?
    var textFieldNavigator: TextFieldNavigation?
    var isTakingPhoto:Bool = false
    
    let accessToken: Any? = UserDefaults.standard.object(forKey:"AccessToken") as Any?
    let statess: Any? = UserDefaults.standard.object(forKey:"State") as Any?
    @IBOutlet weak var nameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var addressTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var stateTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var cityTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var phoneTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var dobTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var genderTextField: SkyFloatingLabelTextField!
    var currentTextField: UITextField?
    
    @IBOutlet weak var adharCardTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var lblWallet: UILabel!
    
    var sideMenu:SideMenuNavigationController?
    var token:String?
    var message:String?
    var status:Int?
    var str:String?
    let pickerView1 = UIPickerView()
    let pickerView2 = UIPickerView()
    var genderArray:[[String:Any]] = []
    var stateArray:[[String:Any]] = []
    var datePicker = UIDatePicker()
    var stateId:String?
    var stateIds:String?
    var genderId:String?
    var states:String?
    var clientId:String?
    var adhaarDictionary:[String:Any] = [:]
    var clientDictionary:[String:Any] = [:]
    var walletView : UIView!
    @IBOutlet weak var panNumberField: SkyFloatingLabelTextField!
   // var walletlabel : UILabel!
    var aadharStatus:Int?
    var alreadySelectedArray:[[String:Any]] = []
    @IBOutlet weak var saveButton: UIButton!
    var flags:Int?
    var fullName:String?
    
    
    //MARK:- View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupMenu()
        self.setupWalletView()
        self.stateList()
        navigationController?.isNavigationBarHidden = true
        self.flags = 1
        currentTextField?.delegate = self
        nameTextField.delegate = self
        genderTextField.delegate = self
        dobTextField.delegate = self
        emailTextField.delegate = self
        phoneTextField.delegate = self
        cityTextField.delegate = self
        stateTextField.delegate = self
        addressTextField.delegate = self
        self.adharCardTextField.delegate = self
        self.panNumberField.delegate = self
        textFieldNavigator = TextFieldNavigation()
        textFieldNavigator?.textFields = [nameTextField,genderTextField,emailTextField,phoneTextField,cityTextField,stateTextField,addressTextField,adharCardTextField,panNumberField]
        phoneTextField.keyboardType = .phonePad
        self.tableView.rowHeight = 80.0
        let logo = UIImage(named: "layer3")
        let imageView = UIImageView(image:logo)
        imageView.frame = CGRect(x: 150, y: 20, width: 100.0, height: 30.0)
        self.navigationItem.titleView = imageView
        tableView.backgroundView = UIImageView(image: UIImage(named: "Background"))
        profileImageView.layer.borderWidth = 1.0
        profileImageView.layer.masksToBounds = true
        // self.profileImageView.borderColor = UIColor(red: 0.0/255, green: 145.0/255, blue: 186.0/255, alpha: 1.0)
        profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
        saveButton.layer.cornerRadius = 8
        saveButton.layer.borderWidth = 1
        saveButton.layer.borderColor = UIColor.clear.cgColor
        token = UserDefaults.standard.string(forKey:"AccessToken")!
        print("Token :", token as Any)
        self.walletAmount()
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction1))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.genderTextField.inputAccessoryView = doneToolbar
        
        let flexSpace2 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done2: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction2))
        
        let doneToolbar2: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar2.barStyle = .default
        
        let items2 = [flexSpace2, done2]
        doneToolbar2.items = items2
        doneToolbar2.sizeToFit()
        self.state()
        self.pickerView2.reloadAllComponents()
        
        self.stateTextField.inputAccessoryView = doneToolbar2
        self.pickerView1.delegate = self
        self.pickerView1.dataSource = self
        self.pickerView2.delegate = self
        self.pickerView2.dataSource = self
        self.genderTextField.inputView = self.pickerView1
        self.stateTextField.inputView = self.pickerView2
        
        self.genderArray = [["Gender":"Male","GenderId":"m"],["Gender":"Female","GenderId":"f"]]
        
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        self.dobTextField.inputView = datePicker
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        } else {
            // Fallback on earlier versions
        }
        
        let doneToolbar5: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar5.barStyle = .default
        
        let flexSpace5 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done5: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(DPProfileVC.showSelectedDate))
        
        let itemss = [flexSpace5, done5]
        doneToolbar5.items = itemss
        doneToolbar5.sizeToFit()
        self.dobTextField.inputAccessoryView = doneToolbar5
        let toggleButton = UIBarButtonItem(image: UIImage(named: "group12"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(DPProfileVC.toggle))
        self.navigationItem.leftBarButtonItem = toggleButton
        print("AuthTokensss \(String(describing: accessToken))")
        

        self.profileData()
    }
    
    
    
    func profileData(){
        SVProgressHUD.show()
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            let headers: HTTPHeaders = ["Content-type": "multipart/form-data","Authorization":"Bearer" + " " + token!,"X-Requested-With":"XMLHttpRequest"]
            AF.upload(multipartFormData: { multipartFormData in }, to: Constants.BaseUrl + "me", method: .get , headers: headers).responseJSON { response in
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
                        self.nameTextField.text = self.userDictionary["name"] as? String
                        self.phoneTextField.text = self.userDictionary["phone"] as? String
                        self.emailTextField.text = self.userDictionary["email"] as? String
                        self.cityTextField.text = self.userDictionary["city"] as? String
                        self.addressTextField.text = self.userDictionary["address"] as? String
                        self.stateTextField.text = self.userDictionary["state_name"] as? String
                        if let id = self.userDictionary["state_id"] as? Int {
                            self.stateId = String(id)
                        }
                        let gender = self.userDictionary["gender"] as? String
                        if gender == "m" {
                            self.genderTextField.text = "Male"
                            self.genderId = "m"
                        }
                        else if gender == "f" {
                            self.genderTextField.text = "Female"
                            self.genderId = "f"
                        }
                        if self.userDictionary["date_of_birth"] as? String != ""{
                            self.dobTextField.text = self.userDictionary["date_of_birth"] as? String
                        }else{
                            let dateFormatter1 = DateFormatter()
                            dateFormatter1.dateStyle = .medium
                            dateFormatter1.timeStyle = .none
                            dateFormatter1.dateFormat = "yyyy-MM-dd"
                            let date = dateFormatter1.string(from: NSDate() as Date)
                            self.dobTextField.text = date
                        }
                        
                       // self.dobTextField.text = ""
                        self.adharCardTextField.text = self.userDictionary["aadhar_no"] as? String
                        self.panNumberField.text = self.userDictionary["pan_no"] as? String
                        if let imageUrl = self.userDictionary["image_path"] as? String,
                           !imageUrl.isEmpty, let imgURl =  URL(string:imageUrl) {
                            self.profileImageView.sd_setImage(with: imgURl, completed: nil)
                            self.profileImageView.contentMode = .scaleAspectFill
                        }
                        if let imageUrl = self.userDictionary["image_path"] as? String, let  url = URL(string:imageUrl) {
                            print("UserURLImage \(url)")
                            if let data = try? Data(contentsOf: url)  {
                                self.profileImageView.image = UIImage(data: data)
                                self.profileImageView.contentMode = .scaleAspectFill
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc func aadharFieldTapped() {
        print("Ankit")
    }
    @IBAction func btnMenu(_ sender: UIButton){
       // viewHeader.isHidden = true
        present(sideMenu!, animated: true, completion: nil)
    }
    func stateList(){
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
                    //SVProgressHUD.dismiss()
                    print("This is run on the main queue, after the previous code in outer block")
                }
                print("responseState \(responseObject)")
                self.resultDictionary = responseObject as! [String:Any]
                if let dict =  self.resultDictionary["data"] as? [String:Any] {
                    self.stateDictionary = dict
                }
                if let myArray = self.stateDictionary["states"] as? [[String:Any]] {
                    self.stateArray = myArray
                    print("StateArray \(self.stateArray)")
                }
            }
        }
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
                to: Constants.BaseUrl + "me", method: .get , headers: headers).responseJSON { response in
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
                            if let user = self.dataDictionary["user"] as? [String:Any] {
                                self.userDictionary = user
                                print("UserDictionary \(self.userDictionary)")
                            }
                            //                                if let amount = self.userDictionary["balance"] as? Int {
                            ////                                    self.amountLabel.text = "₹" + String(amount)
                            //                                    self.walletlabel.text = "₹" + String(amount)
                            //                                }
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
    
    func setupWalletView(){
        walletView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 92, height: 33))
        walletView.backgroundColor = .clear
        let imageView = UIImageView(image:#imageLiteral(resourceName: "wallet"))
        walletView.addSubview(imageView)
        imageView.frame = CGRect(x: walletView.frame.width/2-20/2, y: 0, width: 20, height: 20)
       // walletlabel = UILabel.init(frame: CGRect.init(x: 0, y: imageView.frame.maxY + 3, width: walletView.frame.width, height: 10))
       // walletlabel.textColor = .white
       // walletlabel.font = UIFont.systemFont(ofSize: 11)
       // walletlabel.text = " "
       // walletlabel.textAlignment = .center
       // walletView.addSubview(walletlabel)
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(DPHomePageVC.handleTap(_:)))
        walletView.addGestureRecognizer(tap1)
        let btn = UIBarButtonItem.init(customView: walletView)
        self.navigationItem.rightBarButtonItem = btn
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let menuVC = storyboard?.instantiateViewController(withIdentifier: "DPWalletVC") as? DPWalletVC
        self.navigationController?.pushViewController(menuVC!, animated:true)
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
        
        //   SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        SideMenuManager.default.leftMenuNavigationController = self.sideMenu
        
    }
}

extension DPProfileVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.currentTextField = textField
    }
    
    internal func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        self.currentTextField = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        
    }
    
    @objc func toggle(){
        present(sideMenu!, animated: true, completion: nil)
        
        
    }
    
    @objc func showSelectedDate() {
        self.datePicker.resignFirstResponder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if dobTextField.isFirstResponder {
            self.dobTextField.text = "\(formatter.string(from: datePicker.date))"
            self.dobTextField.resignFirstResponder()
        }
    }
    
    @objc func doneButtonAction1(){
        // self.genderTextField.text  = self.genderArray[0]["Gender"] as? String
        self.genderTextField.resignFirstResponder()
    }
    
    @objc func doneButtonAction2(){
        // self.stateTextField.text  = self.stateArray[0]["name"] as? String
        self.stateTextField.resignFirstResponder()
        
    }
    @IBAction func cameraButtonTapped(_ sender: Any) {
        let actionSheetController: UIAlertController = UIAlertController(title: "Action Sheet", message: "Swiftly Now! Choose an option!", preferredStyle: .actionSheet)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
        }
        actionSheetController.addAction(cancelAction)
        let takePictureAction: UIAlertAction = UIAlertAction(title: "Take Picture", style: .default) { action -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerController.SourceType.camera;
                imagePicker.allowsEditing = true
                self.isTakingPhoto = true
                self.present(imagePicker, animated: true, completion: nil)
            }
            
        }
        actionSheetController.addAction(takePictureAction)
        let choosePictureAction: UIAlertAction = UIAlertAction(title: "Choose From Camera Roll", style: .default) { action -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary;
                imagePicker.allowsEditing = true
                self.isTakingPhoto = true
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        actionSheetController.addAction(choosePictureAction)
        if let popoverController = actionSheetController.popoverPresentationController {
            popoverController.sourceView = self.profileImageView
            
        }
        
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
    
    
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        //SVProgressHUD.show()
        photo1 = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.editedImage.rawValue)] as? UIImage //2
        let img = self.resizeImage(image: self.photo1!, targetSize:CGSize(width:100.0 , height:100.0))
        profileImageView.contentMode = .scaleAspectFill //3
        profileImageView.image = img //4
        print("profileImage \(String(describing: profileImageView.image))")
        if let image  = profileImageView.image,let imageData = image.jpegData(compressionQuality: 8.0) {
            
            self.imageData = imageData
        }
        dismiss(animated:true, completion: nil)
    }
    
    func updateProfileData(){
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            SVProgressHUD.show()
            let parameters = ["name":self.nameTextField.text!,
                              "phone":self.phoneTextField.text!,
                              "state_id":self.stateId as Any ,
                              "gender":genderId as Any,
                              "city":self.cityTextField.text!,
                              "address":self.addressTextField.text!,
                              "date_of_birth":self.dobTextField.text!,//"1986-06-18",
                              "aadhar_no":self.adharCardTextField.text!,
                              "pan_no":self.panNumberField.text!] as [String : Any] //Optional for extra parameter
            print("Parametersss \(String(describing:parameters))")
            let url = Constants.BaseUrl + "update/profile"
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
                    if let temp = value as? Int {
                        multipartFormData.append("\(temp)".data(using: .utf8)!, withName: key)
                    }
                    if let temp = value as? NSArray {
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
                
            },
                      to:url, method: .post , headers: header)
            .responseJSON(completionHandler: { (response) in
                
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
                        self.saveButton.titleLabel?.text = "Update"
                        self.saveButton.addTarget(self, action: #selector(self.saveupdatedProfileData(_:)), for: .touchUpInside)
                        self.responseDictionary = responseObject as! [String:Any]
                        if let dict = self.responseDictionary["data"] as? [String:Any] {
                            self.dataDictionary = dict
                            print("DataDictionary \(self.dataDictionary)")
                        }
                        self.message = self.responseDictionary["message"] as? String
                        print("Message \(String(describing: self.message))")
                        
                        
                        self.status = self.responseDictionary["status"] as? Int
                        
                        if self.status == 0 {
                            if let adhaar = self.dataDictionary["aadhar_response"] as? [String:Any] {
                                self.adhaarDictionary = adhaar
                                print("AdhaarDictionary \(self.adhaarDictionary)")
                            }
                            if let adharStatus = self.adhaarDictionary["status_code"] as? Int  {
                                self.aadharStatus = adharStatus
                                print("AadharStatus \(String(describing: self.aadharStatus))")
                            }
                            
                            self.message = self.adhaarDictionary["message"] as? String
                            
                            
                            if self.aadharStatus == 500 {
                                
                                
                                let alertController = UIAlertController(title: "Alert", message: self.message, preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                                    print("you have pressed the Ok button");
                                }
                                
                                alertController.addAction(okAction)
                                self.present(alertController, animated: true, completion:nil)
                                
                            }
                            else if self.aadharStatus == 422 {
                                self.message = self.adhaarDictionary["message"] as? String
                                print("AadharMessage \(String(describing: self.message))")
                                let alertController = UIAlertController(title: "Alert", message: self.message, preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                                    print("you have pressed the Ok button");
                                }
                                
                                alertController.addAction(okAction)
                                self.present(alertController, animated: true, completion:nil)
                                
                            }
                            
                        }
                        else if self.status == 1{
                            
                            if let adhaar = self.dataDictionary["aadhar_response"] as? [String:Any] {
                                self.adhaarDictionary = adhaar
                                print("AdhaarDictionary \(self.adhaarDictionary)")
                            }
                            
                            
                            
                            if let data = self.adhaarDictionary["data"] as? [String:Any] {
                                self.clientDictionary = data
                                print("ClientDictionary \(self.clientDictionary)")
                            }
                            self.clientId = self.clientDictionary["client_id"] as? String
                            print("ClientID \(String(describing: self.clientId))")
                            if let adharStatus = self.adhaarDictionary["status_code"] as? Int{
                                self.aadharStatus = adharStatus
                                print("AadharStatus \(String(describing: self.aadharStatus))")
                            }
                            
                            if self.aadharStatus == 200{
                                
                                self.adharCardTextField.addTarget(self, action: #selector(DPProfileVC.aadharFieldTapped), for: .editingDidEnd)
                                
                                let alertController = UIAlertController(title: "Alert", message: self.message, preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    /* let menuVC  = storyboard.instantiateViewController(withIdentifier: "DPAdharCardOTPVC") as? DPAdharCardOTPVC
                                     menuVC?.clientIds = self.clientId
                                     menuVC?.mobileNumber = self.phoneTextField.text!
                                     print("MenuVC.MobileNumber \(String(describing: menuVC?.mobileNumber))")
                                     
                                     
                                     self.navigationController?.pushViewController(menuVC!, animated: true)
                                     */
                                    
                                }
                                alertController.addAction(okAction)
                                self.present(alertController, animated: true, completion:nil)
                            }
                        }
                        
                        let alertController = UIAlertController(title: "Alert", message: "Profile Updated.", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                            print("you have pressed the Ok button");
                        }
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion:nil)
                        
                    }
                }
                
            }
                          
        )}
        
        
    }
    
    func state(){
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
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
                        print("response \(responseString)")
                    }
                case .success(let responseObject):
                    DispatchQueue.main.async {
                        // SVProgressHUD.dismiss()
                        print("This is run on the main queue, after the previous code in outer block")
                    }
                    print("response \(responseObject)")
                    self.resultDictionary = responseObject as! [String:Any]
                    print("ResultDictionary \(self.resultDictionary)")
                    
                    if let dict =  self.resultDictionary["data"] as? [String:Any] {
                        self.stateDictionary = dict
                    }
                    if let myArray = self.stateDictionary["states"] as? [[String:Any]] {
                        
                        self.stateArray = myArray
                        print("StateArrayss \(self.stateArray)")
                    }
                    
                    self.pickerView2.reloadAllComponents()
                    
                }
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !self.isTakingPhoto {
            self.profileData()
        }
       // self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.tabBarController?.tabBar.isHidden = false
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.isTakingPhoto = false
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        
        
        if pickerView == self.pickerView1{
            return self.genderArray.count
        }
        else if pickerView == self.pickerView2{
            return self.stateArray.count
        }
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == self.pickerView1{
            self.str = self.genderArray[row]["Gender"] as? String
        }
        else if pickerView == self.pickerView2{
            self.str = self.stateArray[row]["name"] as? String
            
        }
        
        return self.str
        
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.pickerView1{
            self.genderTextField.text = self.genderArray[row]["Gender"] as? String
            self.genderId = self.genderArray[row]["GenderId"] as? String
            
            self.view.endEditing(false)
        }
        else if pickerView == self.pickerView2{
            self.stateTextField.text = self.stateArray[row]["name"] as? String
            self.states = self.stateTextField.text!
            let pref:UserDefaults = UserDefaults.standard
            pref.set(self.stateTextField.text!, forKey:"State")
            pref.synchronize()
            if let id = self.stateArray[row]["id"] as? Int {
                self.stateId = String(id)
                print("StateIDSelected \(String(describing: self.stateId))")
            }
            
            self.view.endEditing(false)
        }
    }
    @objc func saveupdatedProfileData(_ sender:UIButton){
        self.updateProfileData()
    }
    func validatePanCardNumber(_ cardNumber: String?) -> Bool {
        let emailRegex = "^([a-zA-Z]){5}([0-9]){4}([a-zA-Z]){1}?$"
        let cardTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return cardTest.evaluate(with: cardNumber)
    }
    func validateAdharCardNumber(_ cardNumber: String?) -> Bool {
        let emailRegex = "^[2-9]{1}[0-9]{3}[0-9]{4}[0-9]{4}$"
        let cardTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return cardTest.evaluate(with: cardNumber)
    }
    
    func saveProfileData(){
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            if self.genderTextField.text == "" {
                let alertController = UIAlertController(title: "Alert", message:"Please select gender", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                    
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion:nil)
            }
//            else if dobTextField.text == ""{
//                let alertController = UIAlertController(title: "Alert", message:"Please select date of birth", preferredStyle: .alert)
//                let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
//
//                }
//                alertController.addAction(okAction)
//                self.present(alertController, animated: true, completion:nil)
//
//            }
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            if let dob = formatter.date(from: self.dobTextField.text!){
                // Age of 18.
                let MINIMUM_AGE: Date = Calendar.current.date(byAdding: .year, value: -18, to: Date())!;
                if MINIMUM_AGE < dob{
                    let alert = UIAlertController(title: "Alert", message: "Age should be above 18 years !", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return;
                }else if adharCardTextField.text != "" && validateAdharCardNumber(adharCardTextField.text) == false{
                    let alert = UIAlertController(title: "Alert", message: "Enter validate aadhar card number", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return;
                }else if panNumberField.text != "" && validatePanCardNumber(panNumberField.text) == false{
                    let alert = UIAlertController(title: "Alert", message: "Enter validate pan card number", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return;
                }
            }
            else{
                let alertController = UIAlertController(title: "Alert", message: "Please select date of birth"/*"DOB is wrong!"*/, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion:nil)
                return;
            }
            
            
            SVProgressHUD.show()
            let parameters = ["name":self.nameTextField.text!,
                              "phone":self.phoneTextField.text!,
                              "state_id":self.stateId as Any ,
                              "gender":genderId as Any,
                              "city":self.cityTextField.text!,
                              "address":self.addressTextField.text!,
                              "date_of_birth":self.dobTextField.text!,//"1986-06-18",
                              "aadhar_no":self.adharCardTextField.text!,
                              "pan_no":self.panNumberField.text!] as [String : Any] //Optional for extra parameter
            print("Parametersss \(String(describing:parameters))")
            
            let url = Constants.BaseUrl + "update/profile"//Constants.BaseUrl + "bank_accounts/"+"\(id)"
            print("API URL: \(url)")
            
            var header = HTTPHeaders()
            header = ["Content-type": "multipart/form-data","Authorization":"Bearer" + " " + token!,"X-Requested-With":"XMLHttpRequest"]
            AF.upload(multipartFormData: { multipartFormData in
                
                if let img = self.imageData {
                    
                    multipartFormData.append(img, withName:"photo", fileName: "File.jpg", mimeType: "image/jpg")
                }
                
                for (key, value) in parameters {
                    if let temp = value as? String {
                        multipartFormData.append(temp.data(using: .utf8)!, withName: key)
                    }
                    if let temp = value as? Int {
                        multipartFormData.append("\(temp)".data(using: .utf8)!, withName: key)
                    }
                    if let temp = value as? NSArray {
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
                
            },
                      to:url, method: .post , headers: header)
            .responseJSON(completionHandler: { (response) in
                
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
                        self.saveButton.setTitle("Update", for: UIControl.State.normal)
                        
                        // self.saveButton.titleLabel?.text = "Update"
                        self.responseDictionary = responseObject as! [String:Any]
                        if let dict = self.responseDictionary["data"] as? [String:Any] {
                            self.dataDictionary = dict
                            print("DataDictionary \(self.dataDictionary)")
                        }
                        self.message = self.responseDictionary["message"] as? String
                        print("Message \(String(describing: self.message))")
                        
                        
                        self.status = self.responseDictionary["status"] as? Int
                        
                        if self.status == 0 {
                            let alertController = UIAlertController(title: "Alert", message: self.message, preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                                print("you have pressed the Ok button");
                            }
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true, completion:nil)
                            if let adhaar = self.dataDictionary["aadhar_response"] as? [String:Any] {
                                self.adhaarDictionary = adhaar
                                print("AdhaarDictionary \(self.adhaarDictionary)")
                            }
                            if let adharStatus = self.adhaarDictionary["status_code"] as? Int  {
                                self.aadharStatus = adharStatus
                                print("AadharStatus \(String(describing: self.aadharStatus))")
                            }
                            self.message = self.adhaarDictionary["message"] as? String
                            if self.aadharStatus == 500 {
                                let alertController = UIAlertController(title: "Alert", message: self.message, preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                                    print("you have pressed the Ok button");
                                }
                                alertController.addAction(okAction)
                                self.present(alertController, animated: true, completion:nil)
                            }
                            else if self.aadharStatus == 422 {
                                self.message = self.adhaarDictionary["message"] as? String
                                if let aadharNu = self.userDictionary["aadhar_no"] as? String {
                                    if aadharNu != self.adharCardTextField.text! {
                                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                        let menuVC  = storyboard.instantiateViewController(withIdentifier: "DPAdharCardOTPVC") as? DPAdharCardOTPVC
                                        menuVC?.clientIds = self.clientId
                                        menuVC?.mobileNumber = self.phoneTextField.text!
                                        menuVC?.fullNames = self.fullName
                                        menuVC?.aadharNo = self.adharCardTextField.text ?? ""
                                        print("MenuVC.MobileNumber \(String(describing: menuVC?.mobileNumber))")
                                        print("MenuVC.MobileNumber \(String(describing: menuVC?.fullNames))")
                                        self.navigationController?.pushViewController(menuVC!, animated: true)
                                    }
                                } else {
                                    print("AadharMessage \(String(describing: self.message))")
                                    let alertController = UIAlertController(title: "Alert", message: self.message, preferredStyle: .alert)
                                    let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                                        print("you have pressed the Ok button");
                                    }
                                    alertController.addAction(okAction)
                                    self.present(alertController, animated: true, completion:nil)
                                }
                                
                                
                                
                                
                            }
                            
                        }
                        else if self.status == 1{
                            
                            if let adhaar = self.dataDictionary["aadhar_response"] as? [String:Any] {
                                self.adhaarDictionary = adhaar
                                print("AdhaarDictionary \(self.adhaarDictionary)")
                            }
                            if let data = self.adhaarDictionary["data"] as? [String:Any] {
                                self.clientDictionary = data
                                print("ClientDictionary \(self.clientDictionary)")
                            }
                            self.clientId = self.clientDictionary["client_id"] as? String
                            print("ClientID \(String(describing: self.clientId))")
                            if let adharStatus = self.adhaarDictionary["status_code"] as? Int{
                                self.aadharStatus = adharStatus
                                print("AadharStatus \(String(describing: self.aadharStatus))")
                            }
                            
                            if self.aadharStatus == 200{
                                self.adharCardTextField.addTarget(self, action: #selector(DPProfileVC.aadharFieldTapped), for: .editingDidEnd)
                                let alertController = UIAlertController(title: "Alert", message: self.message, preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    let menuVC  = storyboard.instantiateViewController(withIdentifier: "DPAdharCardOTPVC") as? DPAdharCardOTPVC
                                    menuVC?.clientIds = self.clientId
                                    menuVC?.mobileNumber = self.phoneTextField.text!
                                    menuVC?.fullNames = self.fullName
                                    menuVC?.aadharNo = self.adharCardTextField.text ?? ""
                                    print("MenuVC.MobileNumber \(String(describing: menuVC?.mobileNumber))")
                                    print("MenuVC.MobileNumber \(String(describing: menuVC?.fullNames))")
                                    self.navigationController?.pushViewController(menuVC!, animated: true)
                                }
                                alertController.addAction(okAction)
                                self.present(alertController, animated: true, completion:nil)
                            } else {
                                if let aadharNu = self.userDictionary["aadhar_no"] as? String {
                                    if aadharNu != self.adharCardTextField.text! {
                                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                        let menuVC  = storyboard.instantiateViewController(withIdentifier: "DPAdharCardOTPVC") as? DPAdharCardOTPVC
                                        menuVC?.clientIds = self.clientId
                                        menuVC?.mobileNumber = self.phoneTextField.text!
                                        menuVC?.fullNames = self.fullName
                                        print("MenuVC.MobileNumber \(String(describing: menuVC?.mobileNumber))")
                                        print("MenuVC.MobileNumber \(String(describing: menuVC?.fullNames))")
                                        self.navigationController?.pushViewController(menuVC!, animated: true)
                                    } else {
                                        print("AadharMessage \(String(describing: self.message))")
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
                        //                            let alertController = UIAlertController(title: "Alert", message: "Profile Updated.", preferredStyle: .alert)
                        //                            let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                        //                                print("you have pressed the Ok button");
                        //                            }
                        //                            alertController.addAction(okAction)
                        //                            self.present(alertController, animated: true, completion:nil)
                    }
                }
            }
            )}
        
    }
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }
    @IBAction func bankDetailTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menuVC  = storyboard.instantiateViewController(withIdentifier:"DPBankDetailVC") as? DPBankDetailVC
        menuVC?.userDetailDictionary = self.userDictionary
        menuVC?.flag = self.flags
        print("MenuVC.UserDetailDictionary\(String(describing:menuVC?.userDetailDictionary))")
        self.navigationController?.pushViewController(menuVC!, animated: false)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        self.saveProfileData()
    }
}
