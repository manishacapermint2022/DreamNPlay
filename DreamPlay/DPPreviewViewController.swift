//
//  DPPreviewViewController.swift
//  DreamPlay
//
//  Created by MAC on 10/08/21.
//

import UIKit
import Alamofire
import SVProgressHUD


let kScrollDirectionIsHorizontal = false
let kShouldRefresh = false

class DPPreviewViewController: UIViewController {
    
    @IBOutlet weak var teamBLabel: UILabel!
    @IBOutlet weak var labelTeamName: UILabel!
    @IBOutlet weak var teamALabel: UILabel!
    @IBOutlet weak var teamBImageView: UIImageView!
    @IBOutlet weak var teamAImageView: UIImageView!
    var previewArray:[[String:Any]] = []
    @IBOutlet weak var wicketKeeperCollectionView: UICollectionView!
    var responseDictionary:[String:Any] = [:]
    var dataDictionary:[String:Any] = [:]
    var walletView : UIView!
    var walletlabel : UILabel!
    var userDictionary:[String:Any] = [:]
    var token:String?
   
  
    var wicketKeeperArray:[[String:Any]] = []
    var batsmanArray:[[String:Any]] = []
    var bowlerArray:[[String:Any]] = []
    var alrounderArray:[[String:Any]] = []
    var contestDictionary:[String:Any] = [:]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupWalletView()
        
        let flowLayout = wicketKeeperCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        flowLayout?.scrollDirection = .vertical
        
        let logo = UIImage(named:"layer3")
        let imageView = UIImageView(image:logo)
        imageView.frame = CGRect(x: 150, y: 20, width: 100.0, height: 30.0)
        self.navigationItem.titleView = imageView

        token = UserDefaults.standard.string(forKey:"AccessToken")!
        print("Token :", token as Any)
      //  labelTeamName.text = kUserDefaults.getUserTeamName()
        
        
        self.wicketKeeperArray.removeAll()
        self.batsmanArray.removeAll()
        self.bowlerArray.removeAll()
        self.alrounderArray.removeAll()
        print("PreviewArray \(String(describing:previewArray))")
        
        contestDictionary = UserDefaults.standard.object(forKey:"ContestDictionary") as? [String:Any] ?? [:]
        
        self.teamALabel.text = self.contestDictionary["teama"] as? String
        self.teamBLabel.text = self.contestDictionary["teamb"] as? String
        
        if let imageUrl = self.contestDictionary["teama_image"] as? String, let  url = URL(string:imageUrl){
                print("UserURLImage \(url)")
                if let data = try? Data(contentsOf: url)  {
                    teamAImageView.image = UIImage(data: data)
                    //teamAIcon.contentMode = .scaleAspectFill
                }
            }
         

        
        if let imageUrl1 = self.contestDictionary["teamb_image"] as? String, let  url1 = URL(string:imageUrl1){
            print("UserURLImage \(url1)")
            if let data = try? Data(contentsOf: url1)  {
                teamBImageView.image = UIImage(data: data)
                //teamBIcon.contentMode = .scaleAspectFill
            }
        }
        for wk in self.previewArray {
            if wk["position"] as! String == "WK"{
                print("WiketKeeperList \(wk)")
                self.wicketKeeperArray.append(wk)
            }
        }
        
        for wk in self.previewArray {
            if wk["position"] as! String == "BAT"{
                print("BatsmanList \(wk)")
                self.batsmanArray.append(wk)
            }
        }
        
        for wk in self.previewArray {
            if wk["position"] as! String == "AR"{
                print("AlrounderList \(wk)")
                self.alrounderArray.append(wk)
            }
        }
        
        for wk in self.previewArray {
            if wk["position"] as! String == "BOWL"{
                print("BatsmanList \(wk)")
                self.bowlerArray.append(wk)
            }
        }
        self.wicketKeeperCollectionView.reloadData()
        

        
        

        // Do any additional setup after loading the view.
    

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
                                
                              print("responseObject \(responseObject)")
                                SVProgressHUD.dismiss()
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
                       
    


override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    self.walletAmount()
//       navigationController?.setNavigationBarHidden(true, animated: true)
    
   
//        userImg.image = UIImage(data:Data(contentsOf: URL(string: Helper.getUserDetails()?.i ?? "First name" )))
}
}
extension DPPreviewViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = wicketKeeperCollectionView.dequeueReusableCell(withReuseIdentifier: "WicketKeeperCell", for: indexPath)
        let section = indexPath.section
        if section == 0 {
            let dictionary = self.wicketKeeperArray[indexPath.row]
            
            if let playerName = cell.viewWithTag(10) as? UILabel {
                playerName.text = dictionary["name"] as? String
            }
            if let credit = cell.viewWithTag(20) as? UILabel {
                credit.text = dictionary["credit"] as? String
            }
            
            //end of section 0
        } else if section == 1 {
            let dictionary = self.batsmanArray[indexPath.row]
            if let playerName = cell.viewWithTag(10) as? UILabel {
                playerName.text = dictionary["name"] as? String
            }
            if let credit = cell.viewWithTag(20) as? UILabel {
                credit.text = dictionary["credit"] as? String
            }
        }
        else if section == 2 {
            let dictionary = self.alrounderArray[indexPath.row]
            if let playerName = cell.viewWithTag(10) as? UILabel {
                playerName.text = dictionary["name"] as? String
            }
            if let credit = cell.viewWithTag(20) as? UILabel {
                credit.text = dictionary["credit"] as? String
            }
        }
        else if section == 3 {
            let dictionary = self.bowlerArray[indexPath.row]
            if let playerName = cell.viewWithTag(10) as? UILabel {
                playerName.text = dictionary["name"] as? String
            }
            if let credit = cell.viewWithTag(20) as? UILabel {
                credit.text = dictionary["credit"] as? String
            }
        }
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4 // Replace with count of your data for collectionViewA
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return self.wicketKeeperArray.count
        } else if section == 1 {
            return self.batsmanArray.count
        }
        else if section == 2{
            return self.alrounderArray.count
        }
        else if section == 3 {
            return self.bowlerArray.count
        }
        
        return 0
    }
}

//extension DPPreviewViewController:UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let collectionViewWidth = collectionView.bounds.width
//        return CGSize(width: collectionViewWidth / 4, height: 120)
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 4
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 3
//    }
//
//}
extension DPPreviewViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        return CGSize(width: collectionViewWidth / 4, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
           return 4
       }
   
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
           return 3
       }
}
