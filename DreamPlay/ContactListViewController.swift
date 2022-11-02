//
//  ContactListViewController.swift
//  GIFWar
//
//  Created by IOSdev on 8/11/20.
//  Copyright © 2020 EvirtualServices. All rights reserved.
//

import UIKit
import Contacts
import PhoneNumberKit
import MessageUI
import Messages
import Alamofire
import SVProgressHUD


class ContactListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, MFMessageComposeViewControllerDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let referralCode: Any? = UserDefaults.standard.object(forKey:"ReferralCode") as Any?
    @IBOutlet weak var contactListLabel: UILabel!
    @IBOutlet weak var registerUserLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var contactStore = CNContactStore()
    var contacts = [ContactStruct]()
    var filter = [ContactStruct]()
    var contactName:String?
    var contactSurname:String?
    var contactNumber:String?
    var referralString:String! = nil
    var walletView : UIView!
    var walletlabel : UILabel!
    var token:String?
    var responseDictionary:[String:Any] = [:]
    var dataDictionary:[String:Any] = [:]
    var userDictionary:[String:Any] = [:]
    var contactToAppend = ContactStruct(givenNames: "", familyName: "", number: "")
    var searching = false
    var dict:ContactStruct?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        self.tableView.rowHeight = 80.0
        let logo = UIImage(named:"layer3")
        let imageView = UIImageView(image:logo)
        imageView.frame = CGRect(x: 150, y: 20, width: 100.0, height: 30.0)
        self.navigationItem.titleView = imageView
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "Background"))
        self.setupWalletView()
        self.referralString = referralCode as? String
        token = UserDefaults.standard.string(forKey:"AccessToken")!
        print("Token :", token as Any)
        self.walletAmount()
        self.getContactList()
      /*  let contactStore = CNContactStore()
           var contacts = [CNContact]()
           let keys = [
               CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
               CNContactPhoneNumbersKey,
               CNContactEmailAddressesKey,
           ] as [Any]
           let request = CNContactFetchRequest(keysToFetch: keys as! [CNKeyDescriptor])
           do {
               try contactStore.enumerateContacts(with: request) {
                   contact, _ in
                   // Array containing all unified contacts from everywhere
                   contacts.append(contact)
                   for phoneNumber in contact.phoneNumbers {
                       if let number = phoneNumber.value as? CNPhoneNumber, let label = phoneNumber.label {
                           let localizedLabel = CNLabeledValue<CNPhoneNumber>.localizedString(forLabel: label)

                           // Get The Name
                           let name = contact.givenName + " " + contact.familyName
                           print(name)

                           // Get The Mobile Number
                           var mobile = number.stringValue
                           mobile = mobile.replacingOccurrences(of: " ", with: "")

                           // Parse The Mobile Number
                           let phoneNumberKit = PhoneNumberKit()

                           do {
                               let phoneNumberCustomDefaultRegion = try phoneNumberKit.parse(mobile, withRegion: "IN", ignoreType: true)
                               let countryCode = String(phoneNumberCustomDefaultRegion.countryCode)
                               let mobile = String(phoneNumberCustomDefaultRegion.nationalNumber)
                               let finalMobile = "+" + countryCode + mobile
                            print("FinalMobile :", finalMobile)
                               print(finalMobile)
                           } catch {
                               print("Generic parser error")
                           }

                           // Get The Email
                           var email: String
                           for mail in contact.emailAddresses {
                               email = mail.value as String
                               print(email)
                           }
                       }
                   }
               }

           } catch {
               print("unable to fetch contacts")
           }
        
      */
    }
    
    @objc func messageButtonTapped(_ sender:UIButton){
        let message = "Download the dreamnplay app from here Link https://www.google.com/?client=safari Use My Invite code \(String(describing: self.referralString ?? ""))" + "                                                                             " +
           "Let us play!"
        let row = sender.tag
        let dictionary = contacts[row]
        print("ContactDictionary\(dictionary)")
        let number = dictionary.number
        print("ContactNumbers\(String(describing: number))")
        print("Contact")
        // Present the view controller modally.
        if MFMessageComposeViewController.canSendText() {
            let controller = MFMessageComposeViewController()
            controller.body = message
            controller.recipients = [dictionary.number]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
        else{
            print("Cancel")
        }
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
                        
                        //                                    if let amount = self.userDictionary["balance"] as? Int {
                        //    //                                    self.amountLabel.text = "₹" + String(amount)
                        //                                        self.walletlabel.text = "₹" + String(amount)
                        //                                    }
                        
                        let stramount = self.getAmount(self.userDictionary["balance"] as Any )
                        self.walletlabel.text = "₹" + (stramount.isEmpty ? "0" : stramount)
                        
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
        walletlabel = UILabel.init(frame: CGRect.init(x: 0, y: imageView.frame.maxY + 3, width: walletView.frame.width, height: 10))
        walletlabel.textColor = .white
        walletlabel.font = UIFont.systemFont(ofSize: 11)
        walletlabel.text = " "
        walletlabel.textAlignment = .center
        walletView.addSubview(walletlabel)
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(ContactListViewController.wallets(_:)))
      
      walletView.addGestureRecognizer(tap1)
        let btn = UIBarButtonItem.init(customView: walletView)
        self.navigationItem.rightBarButtonItem = btn
        
    }
    @objc func wallets(_ sender: UITapGestureRecognizer) {
        let menuVC  = storyboard?.instantiateViewController(withIdentifier: "DPWalletVC") as? DPWalletVC
        self.navigationController?.pushViewController(menuVC!, animated:true)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController,
                                      didFinishWith result: MessageComposeResult) {
        // Check the result or perform other tasks.
        
        // Dismiss the message compose view controller.
        controller.dismiss(animated: true, completion: nil)}
    
    func getContactList(){
        
        let key = [CNContactGivenNameKey,CNContactFamilyNameKey,CNContactPhoneNumbersKey] as [CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: key)
       try! contactStore.enumerateContacts(with: request) { (contacts,stoppingPointer) in
            
        if let name = contacts.givenName as? String , let familyName = contacts.familyName as? String, let number = contacts.phoneNumbers.first?.value.stringValue{
            
            print("Name \(name)")
                print("Family Name \(familyName)")
                print("Number \(number)")
            
            self.contactName = name
            self.contactSurname = familyName
            self.contactNumber = number
            self.contactToAppend = ContactStruct(givenNames: name, familyName: familyName, number: number)
            print("ContactToAppend \(self.contactToAppend)")
            self.contacts.append(self.contactToAppend)
            self.filter = self.contacts
        }
        
         self.tableView.reloadData()
        
        }
   
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filter.count
      }
      
    
      
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
         let cell = self.tableView.dequeueReusableCell(withIdentifier: "DPContactListCell", for: indexPath) as! DPContactListCell
        
    
            self.dict = self.filter[indexPath.row]
        
       
        
         
         
         
            print("Dictionary \(self.dict)")
        
         if let nameLabel = cell.viewWithTag(10) as? UILabel{
            nameLabel.text = self.dict?.givenNames
               }
        
        if let phoneLabel = cell.viewWithTag(20) as? UILabel{
            phoneLabel.text = self.dict?.number
           }
        
       
        
        cell.messageButton.tag = indexPath.row
        cell.messageButton.addTarget(self, action: #selector(messageButtonTapped(_:)), for: .touchUpInside)
        return cell
        }
        
         
        
}

extension ContactListViewController:UISearchBarDelegate{
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.text = ""
        self.searchBar.endEditing(true)
       // self.filter = self.contacts
      //  self.tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        print("Search= \(String(describing: searchBar.text))")
        self.filter = searchText.isEmpty ? contacts:contacts.filter({ (contacts) -> Bool in   return contacts.givenNames.range(of:searchText,options: .caseInsensitive,range: nil,locale: nil) != nil
            })
        
        self.tableView.reloadData()
}
    
}
    
    class DPContactListCell: UITableViewCell {
        static let ID = "DPContactListCell"
        @IBOutlet weak var contactNameLabel: UILabel!
        @IBOutlet weak var contactNumberLabel:UILabel!
        @IBOutlet weak var messageButton: UIButton!
        
        @IBOutlet weak var borderView:UIView!
        
        

        override class func awakeFromNib() {
            super.awakeFromNib()
        }
}

