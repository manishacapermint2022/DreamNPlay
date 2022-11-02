//
//  DPLoginVC.swift
//  DreamPlay
//
//  Created by MAC on 10/06/21.
//

import UIKit
import Alamofire
import SVProgressHUD
import SkyFloatingLabelTextField

class DPLoginVC: UITableViewController {
    
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var loginButton: UIButton!
    var responseDictionary:[String:Any] = [:]
    var dataDictionary:[String:Any] = [:]
    var status:Int?
    var message:String?
    var authenticationToken:String?
    var textFieldNavigator: TextFieldNavigation?
    var currentTextField: UITextField?
    var balance:Int?
    var userDictionary:[String:Any] = [:]
    var referralCode:String?
    var phone:String?
    var name:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tableView.rowHeight = 80.0
        tableView.backgroundView = UIImageView(image: UIImage(named: "Background"))
        loginButton.layer.cornerRadius = 8
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor.clear.cgColor
        emailTextField?.delegate = self
        passwordTextField.delegate = self
        textFieldNavigator = TextFieldNavigation()
        textFieldNavigator?.textFields = [emailTextField,passwordTextField]
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = .red
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
    
    func saveLogin(){
        UserDefaults.standard.set(true, forKey:"isUserLoggedIn")
        UserDefaults.standard.synchronize()
    }
}

