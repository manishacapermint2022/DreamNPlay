//
//  DPTransactionHistoryVC.swift
//  DreamPlay
//
//  Created by MAC on 10/08/21.
//

import UIKit
import Alamofire
import SVProgressHUD

class DPTransactionHistoryVC: UIViewController, UIScrollViewDelegate {
    var spinner = UIActivityIndicatorView()
    @IBOutlet weak var dataNotAvailableLabel: UILabel!
    var token:String?
    var responseDictionary:[String:Any] = [:]
    var paymentArray:[[String:Any]] = []
    var dataDictionary:[String:Any] = [:]
    var walletView : UIView!
    var walletlabel : UILabel!
    var userDictionary:[String:Any] = [:]
    var currentPage = 1
    var perPage = 0
    var totalPage: Int?
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupWalletView()
        self.dataNotAvailableLabel.isHidden = true
        let logo = UIImage(named: "layer3")
        let imageView = UIImageView(image:logo)
        imageView.frame = CGRect(x: 150, y: 20, width: 100.0, height: 30.0)
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "Background"))
        self.navigationItem.titleView = imageView
        token = UserDefaults.standard.string(forKey:"AccessToken")!
        print("Token :", token as Any)
        transactionHistory(page: currentPage)
        
        
        spinner = UIActivityIndicatorView(style: .whiteLarge)
        spinner.stopAnimating()
        spinner.hidesWhenStopped = true
        spinner.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 60)
        tableView.tableFooterView = spinner
    }
    func setupWalletView(){
        walletView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 92, height: 33))
        walletView.backgroundColor = .clear
        let imageView = UIImageView(image:#imageLiteral(resourceName: "wallet"))
        walletView.addSubview(imageView)
        imageView.frame = CGRect(x: walletView.frame.width/2-20/2, y: 0, width: 20, height: 20)
        walletlabel = UILabel.init(frame: CGRect.init(x: 0, y: imageView.frame.maxY + 3, width: walletView.frame.width, height: 10))
        walletlabel.textColor = .white
        walletlabel.font = UIFont.systemFont(ofSize: 11)
        walletlabel.text = " "
        walletlabel.textAlignment = .center
        walletView.addSubview(walletlabel)
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(DPTeamHistoryVC.handleTap(_:)))
        walletView.addGestureRecognizer(tap1)
        let btn = UIBarButtonItem.init(customView: walletView)
        self.navigationItem.rightBarButtonItem = btn
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let menuVC  = storyboard?.instantiateViewController(withIdentifier: "DPWalletVC") as? DPWalletVC
        self.navigationController?.pushViewController(menuVC!, animated:true)
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offset = scrollView.contentOffset
        let bounds = scrollView.bounds
        let size = scrollView.contentSize
        let inset = scrollView.contentInset
        
        let y = offset.y + bounds.size.height - inset.bottom
        let h = size.height
        
        let reloadDistance = CGFloat(30.0)
        if y > h + reloadDistance {
            print("fetch more data")
            spinner.startAnimating()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.walletAmount()
        //       navigationController?.setNavigationBarHidden(true, animated: true)
        
        
        //        userImg.image = UIImage(data:Data(contentsOf: URL(string: Helper.getUserDetails()?.i ?? "First name" )))
    }
    
    func walletAmount(){
        
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
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
                    let stramount = self.getAmount(self.userDictionary["balance"] as Any )
                    self.walletlabel.text = "₹" + (stramount.isEmpty ? "0" : stramount)
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
    
    
    func transactionHistory(page: Int?) {
        if isInternetAvailable() == false{
            let alert = UIAlertController(title: "Alert", message: "Device is not connected to Internet", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            if currentPage == 1 {
                SVProgressHUD.show()
            }
            if let apiString = URL(string:Constants.BaseUrl + "payments?page=\(page ?? 0)") {
                var request = URLRequest(url:apiString)
                printApiUrlAndParametre(urls: apiString, params: nil)
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
                                SVProgressHUD.dismiss()
                                self.responseDictionary = responseObject as! [String:Any]
                                if let dict = self.responseDictionary["data"] as? [String:Any], let payment = dict["payments"] as? [[String:Any]] {
                                    //  self.paymentArray = payment
                                    
                                    self.totalPage = dict["total"]as? Int
                                    self.paymentArray.append(contentsOf: payment)
                                    self.perPage = dict["per_page"] as! Int
                                    print(self.paymentArray)
                                    if self.paymentArray.count == 0 {
                                        self.dataNotAvailableLabel.isHidden = false
                                    }
                                }
                            }
                            
                        }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            
                        }
                        
                    }
                
            }
        }
    }
}
extension DPTransactionHistoryVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.paymentArray.count
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
                let lastItem = self.paymentArray.count - 1
                print("lastItem:- \(lastItem)")
        //        if indexPath.row == lastItem {
        //            print("IndexRow\(indexPath.row)")
        //            if currentPage < totalPage ?? 0 {
        //                currentPage += 1
        //                transactionHistory(page: currentPage)
        //            }
        //        }
        if indexPath.row == lastItem && self.totalPage ?? 0 > self.currentPage * perPage {
            self.currentPage += 1
            transactionHistory(page: currentPage)
        } else {
            spinner.stopAnimating()
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionHistoryCell.ID, for: indexPath) as! TransactionHistoryCell
        
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
    
class TransactionHistoryCell: UITableViewCell {
    static let ID = "TransactionHistoryCell"
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */



