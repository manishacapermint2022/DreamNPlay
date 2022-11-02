//
//  DPRegistrationVC+Action.swift
//  DreamPlay
//
//  Created by sismac020 on 05/05/22.
//

import UIKit

extension DPRegistrationVC {
    @IBAction func SignUpButtonTapped(_ sender:UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: - Table view data source
    
    @IBAction func checkButtonTapped(_ sender:UIButton) {
        if (sender.isSelected == true){
            sender.setBackgroundImage(UIImage(named: "addressUnCheck"), for: UIControl.State.normal)
            sender.isSelected = false;
        }else{
            sender.setBackgroundImage(UIImage(named: "addressCheck"), for: UIControl.State.normal)
            sender.isSelected = true;
        }
    }
    
    @objc func gestureTermsCondition(gesture: UITapGestureRecognizer) {
        let termsRange = (text as NSString).range(of: "Terms and Conditions")
        if gesture.didTapAttributedTextInLabel(label: labelTermsAndCondition, inRange: termsRange) {
            print("Terms and Conditions")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let menuVC  = storyboard.instantiateViewController(withIdentifier: "TermsConditionVC") as? TermsConditionVC
            navigationController?.pushViewController(menuVC!, animated: true)
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
}
