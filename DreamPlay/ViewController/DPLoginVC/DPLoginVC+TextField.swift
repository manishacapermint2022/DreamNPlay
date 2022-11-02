//
//  DPLoginVC+TextField.swift
//  DreamPlay
//
//  Created by sismac020 on 18/04/22.
//

import UIKit
import Alamofire

extension DPLoginVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.currentTextField = textField
    }
    
    internal func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        self.currentTextField = nil
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let whitespaceSet = NSCharacterSet.whitespaces
        if textField == passwordTextField{
            if let _ = string.rangeOfCharacter(from: whitespaceSet){
                  return false
            }
        }
        return true
     }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
}
