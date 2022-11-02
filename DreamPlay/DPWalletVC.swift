//
//  DPWalletVC.swift
//  DreamPlay
//
//  Created by MAC on 16/06/21.
//

import UIKit
import SideMenu
import Alamofire
import SVProgressHUD
import Razorpay

class DPWalletVC: UIViewController,UIAdaptivePresentationControllerDelegate{
    
    @IBOutlet weak var addMoneyView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var sideMenu:SideMenuNavigationController?
    
    @IBOutlet weak var walletBalanceIcon: UIButton!
    @IBOutlet weak var winningAmountLabel: UILabel!
    @IBOutlet weak var walletAmountLabel: UILabel!
    @IBOutlet weak var withdrawButton: UIButton!
    @IBOutlet weak var amountWonView: UIView!
    @IBOutlet weak var dataNotAvailableLabel: UILabel!
    var token:String?
    var responseDictionary:[String:Any] = [:]
    var userDictionary:[String:Any] = [:]
    var dataDictionary:[String:Any] = [:]
    var isOpen = false
    var screenCheck = false
    var razorpay: RazorpayCheckout!
    var paymentArray:[[String:Any]] = []
    var withdrawAmount: NSNumber = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupMenu()
        self.dataNotAvailableLabel.isHidden = true
        let logo = UIImage(named:"layer3")
        let imageView = UIImageView(image:logo)
        imageView.frame = CGRect(x: 150, y: 20, width: 100.0, height: 30.0)
        self.navigationItem.titleView = imageView
        
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "Background"))
        addMoneyView.layer.cornerRadius = 8
        addMoneyView.layer.borderWidth = 1
        addMoneyView.layer.borderColor = UIColor.clear.cgColor
        amountWonView.layer.cornerRadius = 8
        amountWonView.layer.borderWidth = 1
        amountWonView.layer.borderColor = UIColor.clear.cgColor
        withdrawButton.layer.cornerRadius = 8
        withdrawButton.layer.borderWidth = 1
        withdrawButton.layer.borderColor = UIColor.clear.cgColor
        token = UserDefaults.standard.string(forKey:"AccessToken")!
        print("Token :", token as Any)
        self.walletAmountAPI()
        self.transactionHistory()
        self.winningAmount()
    }
    override func viewWillAppear(_ animated: Bool) {
        
        //self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        
        //self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func amountWonInfoTapped(_ sender:UIButton) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let popupVC = storyboard.instantiateViewController(withIdentifier: "DPAmountWalletWonPopController") as! DPAmountWalletWonPopController
        popupVC.modalPresentationStyle = .popover
        popupVC.preferredContentSize = CGSize(width: 200, height: 50)
        let pVC = popupVC.popoverPresentationController
        pVC?.permittedArrowDirections = .up
        pVC?.delegate = self
        pVC?.sourceView = sender
        //pVC?.sourceRect = CGRect(x: 100, y: 100, width: 1, height: 1)
        present(popupVC, animated: true, completion: nil)
    }
    @IBAction func walletButtonInfoTapped(_ sender:UIButton) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let popupVC = storyboard.instantiateViewController(withIdentifier: "WalletBalanceInfoPopController") as! WalletBalanceInfoPopController
        popupVC.modalPresentationStyle = .popover
        popupVC.preferredContentSize = CGSize(width: 200, height: 50)
        let pVC = popupVC.popoverPresentationController
        pVC?.permittedArrowDirections = .up
        pVC?.delegate = self
        pVC?.sourceView = sender
        //pVC?.sourceRect = CGRect(x: 100, y: 100, width: 1, height: 1)
        present(popupVC, animated: true, completion: nil)
    }
    @IBAction func addMoneyTapped(_ sender: Any) {
        let menuVC  = storyboard?.instantiateViewController(withIdentifier: "DPWalletPopViewController") as? DPWalletPopViewController
        menuVC?.delegate = self
        self.navigationController?.modalPresentationStyle = .overCurrentContext
        self.navigationController?.present(menuVC!, animated: true, completion: nil)
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
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        SideMenuManager.default.leftMenuNavigationController = self.sideMenu
    }
    
    func winningAmount(){
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
                        
                        //                                    if let winAmount = self.userDictionary["winning_amount"] as? Int {
                        //                                        self.withdrawAmount = winAmount
                        //                                        self.winningAmountLabel.text = "₹" + String(winAmount)
                        //                                    }
                        let stramount = self.getAmount(self.userDictionary["winning_amount"] as Any )
                        self.winningAmountLabel.text = "₹" + (stramount.isEmpty ? "0" : stramount)
                        self.withdrawAmount = NumberFormatter().number(from: stramount.isEmpty ? "0" : stramount) ?? 0
                        
                    }
                    
                    
                }
            }
        }
    }
    
    @IBAction func seeAllButtonTapped(_ sender: Any) {
        let menuVC  = storyboard?.instantiateViewController(withIdentifier: "DPTransactionHistoryVC") as? DPTransactionHistoryVC
        self.navigationController?.pushViewController(menuVC!, animated: true)
    }
    @IBAction func btnMenu(_ sender: UIButton){
        present(sideMenu!, animated: true, completion: nil)
    }
    func transactionHistory(){
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            
            SVProgressHUD.show()
            
            if let apiString = URL(string:Constants.BaseUrl + "payments") {
                var request = URLRequest(url:apiString)
                request.httpMethod = "Get"
                request.setValue("application/json",
                                 forHTTPHeaderField: "Content-Type")
                request.setValue("XMLHttpRequest",
                                 forHTTPHeaderField: "XMLHttpRequest")
                request.setValue("Bearer" + " " + token!,
                                 forHTTPHeaderField: "Authorization")
                
                
                
                
                AF.request(request)
                    .responseJSON { response in
                        // do whatever you want here
                        DispatchQueue.main.async {
                            SVProgressHUD.dismiss()
                        }
                        switch response.result {
                        case .failure(let error): break
                            
                        case .success(let responseObject):
                            DispatchQueue.main.async {
                                print("responseObject \(responseObject)")
                                self.responseDictionary = responseObject as! [String:Any]
                                if let dict = self.responseDictionary["data"] as? [String:Any], let payment = dict["payments"] as? [[String:Any]] {
                                    self.paymentArray = payment
                                    //                                                self.dataDictionary = dict
                                    //                                                print("DataDictionary \(self.dataDictionary)")
                                    print(self.paymentArray)
                                }
                            }
                        }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            self.dataNotAvailableLabel.isHidden = !(self.paymentArray.count == 0)
                        }
                    }
            }
        }
    }
    
    internal func showPaymentForm(){
        let options: [String:Any] = [
            "amount": "10", //This is in currency subunits. 100 = 100 paise= INR 1.
            "currency": "INR",//We support more that 92 international currencies.
            "description": "purchase description",
            "order_id": "order_DBJOWzybf0sJbb",
            "image": "https://url-to-image.png",
            "name": "business or product name",
            "prefill": [
                "contact": "9797979797",
                "email": "foo@bar.com"
            ],
            "theme": [
                "color": "#F37254"
            ]
        ]
        razorpay.open(options)
    }
}

extension DPWalletVC:DPWalletPopViewControllerDelegate{
    func paymentStatus(_ status: Bool) {
        self.walletAmountAPI()
        self.transactionHistory()
    }
}

extension DPWalletVC: DPWithdrawPopupVCDelegate{
    func withdrawStatus(_ status: Bool) {
        self.walletAmountAPI()
        self.transactionHistory()
        self.winningAmount()
    }
}
extension DPWalletVC : RazorpayPaymentCompletionProtocol {
    
    func onPaymentError(_ code: Int32, description str: String) {
        print("error: ", code, str)
        
    }
    
    func onPaymentSuccess(_ payment_id: String) {
        print("success: ", payment_id)
        //self.presentAlert(withTitle: "Success", message: "Payment Succeeded")
        
    }
    
    
    
    
    
    func walletAmountAPI(){
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            let headers: HTTPHeaders = ["Content-type": "multipart/form-data","Authorization":"Bearer" + " " + token!,"X-Requested-With":"XMLHttpRequest"]
            let url = Constants.BaseUrl + "me"
            print("URL:\(url)")
            
            AF.upload(
                multipartFormData: { multipartFormData in
                    
                    
                },
                to: url, method: .get , headers: headers)
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
                        if let user = self.dataDictionary["user"] as? [String:Any] {
                            self.userDictionary = user
                            print("UserDictionary \(self.userDictionary)")
                        }
                        
                        //                                if let amount = self.userDictionary["balance"] as? Int {
                        //                                    self.walletAmountLabel.text = "₹" + String(amount)
                        //                                }
                        let stramount = self.getAmount(self.userDictionary["balance"] as Any )
                        self.walletAmountLabel.text = "₹" + (stramount.isEmpty ? "0" : stramount)
                        
                        
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
    
    
    
    @IBAction func toggleButtonTapped(_ sender: Any) {
        present(sideMenu!, animated: true, completion: nil)
        
        
    }
    @IBAction func withdrawButtonTapped(_ sender: Any) {
        
        if self.withdrawAmount.floatValue <= 0{
            let alertController = UIAlertController(title: "Alert", message: "Insufficient Balance", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                print("you have pressed the Ok button");
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion:nil)
            return;
        }
        
        let menuVC  = storyboard?.instantiateViewController(withIdentifier: "DPWithdrawPopupVC") as? DPWithdrawPopupVC
        menuVC?.delegate = self
        self.navigationController?.modalPresentationStyle = .overCurrentContext
        
        
        self.navigationController?.present(menuVC!, animated: true, completion: nil)
    }
    
}


extension DPWalletVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.paymentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WalletHistoryCell.ID, for: indexPath) as! WalletHistoryCell
        
        let dict = self.paymentArray[indexPath.row]
        
        cell.img.layer.cornerRadius = cell.img.frame.height/2
        cell.img.layer.masksToBounds = true
        
        
        cell.borderView.layer.cornerRadius = 8
        cell.borderView.layer.borderWidth = 1
        cell.borderView.layer.borderColor = UIColor.clear.cgColor
        cell.borderView.clipsToBounds = true
        
        var formattedTime = ""
        let time = dict["created_at"] as? String ?? ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat="yyyy-MM-dd'T'HH:mm:ss.sssz"
        dateFormatter.timeZone = TimeZone.current
        
        if let date = dateFormatter.date(from: time){
            let dateFormatter2 = DateFormatter()
            dateFormatter2.dateFormat="dd-MMM-yyyy"
            dateFormatter2.timeZone = TimeZone.current
            formattedTime = dateFormatter2.string(from: date)
        }
        
        
        
        cell.lblName.text = dict["description"] as? String ?? ""
        cell.lblAmount.text =  "₹" + (dict["amount"] as? String ?? "0")
        cell.lblDesc.text = dict["transaction_id"] as? String ?? ""
        cell.lblDate.text = formattedTime
        return cell
    }
    
    
}
    

class WalletHistoryCell: UITableViewCell {
    static let ID = "WalletHistoryCell"
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}




extension DPWalletVC:UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        
        return .none
    }

func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
    
    
}
}

