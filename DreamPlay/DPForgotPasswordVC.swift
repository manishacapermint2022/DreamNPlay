//
//  DPForgotPasswordVC.swift
//  DreamPlay
//
//  Created by MAC on 10/06/21.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire
import SVProgressHUD

class DPForgotPasswordVC: UITableViewController {

    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var submitButton: UIButton!
    var responseDictionary:[String:Any] = [:]
    var message:String?
    var textFieldNavigator: TextFieldNavigation?
    var currentTextField: UITextField?
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tableView.rowHeight = 80.0
        tableView.backgroundView = UIImageView(image: UIImage(named: "Background"))
        submitButton.layer.cornerRadius = 8
        submitButton.layer.borderWidth = 1
        submitButton.layer.borderColor = UIColor.clear.cgColor
        textFieldNavigator = TextFieldNavigation()
        textFieldNavigator?.textFields = [emailTextField]
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = .red
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

extension DPForgotPasswordVC: UITextFieldDelegate {
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
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    @IBAction func submitButtonTapped(_ sender: Any) {
        if let apiString = URL(string:Constants.BaseUrl + "password/email") {
            var request = URLRequest(url:apiString)
            request.httpMethod = "POST"
            
            request.setValue("application/json",
                             forHTTPHeaderField: "Content-Type")
            
            let values = ["email":self.emailTextField.text!]
            printApiUrlAndParametre(urls: apiString, params: values)
            request.httpBody = try! JSONSerialization.data(withJSONObject: values)
            AF.request(request)
                .responseJSON { response in
                    // do whatever you want here
                    switch response.result {
                    case .failure(let error):
                        // SVProgressHUD.dismiss()
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
                            print("response \(responseObject)")
                            self.emailTextField.text = ""
                            self.responseDictionary = responseObject as! [String:Any]
                            self.message = self.responseDictionary["message"] as? String
                            let alertController = UIAlertController(title: "Alert", message:self.message, preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
                                print("you have pressed the Ok button");
                            }
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true, completion:nil)
                        }
                    }
                }
        }
    }
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */
            
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
