//
//  String+Extensions.swift
//  DreamPlay
//
//  Created by sismac20 on 20/05/22.
//


import Foundation
import UIKit

extension String {
    static func getString(_ message: Any?) -> String {
        if let string = message {
            guard let strMessage = string as? String else {
                guard let doubleValue = string as? Double else {
                    guard let intValue = string as? Int else {
                        guard string is Float else {
                            guard let int64Value = string as? Int64 else {
                                guard let int32Value = string as? Int32 else {
                                    guard let int16Value = string as? Int32 else {
                                        return ""
                                    }
                                    return String(int16Value)
                                }
                                return String(int32Value)
                            }
                            return String(int64Value)
                        }
                        return String(format: "%.2f", string as! Float)
                    }
                    return String(intValue)
                }
                let formatter = NumberFormatter()
                formatter.minimumFractionDigits = 0
                formatter.maximumFractionDigits = 2
                formatter.minimumIntegerDigits = 1
                guard let formattedNumber = formatter.string(from: NSNumber(value: doubleValue)) else {
                    return ""
                }
                return formattedNumber
            }
            return strMessage
        }
        return ""
    }
    var html2AttributedString: NSAttributedString? {
        //        guard
        //            let data = data(using: String.Encoding.utf16)
        //            else { return nil }
        do {
            return try NSAttributedString(data: Data(utf8), options: [.documentType:NSAttributedString.DocumentType.html,.characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch  {
            return  nil
        }
    }
    
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
    
    func isValidPhone(phone: String) -> Bool {
        let phoneRegex = "^[0-9]{6,14}$";
        let valid = NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: phone)
        return valid
    }
    
    func isValidEmail() -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[_A-Za-z0-9-]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9.-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
//    func isValidPassword()-> Bool {
//        let regex = try! NSRegularExpression(pattern: "", options: .caseInsensitive)
//        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
//    }
    
    func isValidPassword() -> Bool {
        // least one uppercase,
        // least one digit
        // least one lowercase
        // least one symbol
        //  min 8 characters total
        // not enter spacing
        let password = self.trimmingCharacters(in: CharacterSet.whitespaces)
        let passwordRegx = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&<>*~:`-]).{8,}$"
        let passwordCheck = NSPredicate(format: "SELF MATCHES %@",passwordRegx)
        return passwordCheck.evaluate(with: password)

    }
    
    static func randomString() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0...9).map{ _ in letters.randomElement()! })
    }
    
    static func getString(_ value: Int?) -> String{
        if let value = value {
            return "\(value)"
        }
        return ""
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
   
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "\(self)", comment: "")
    }
    
    var withoutHtmlTags: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: " \n", options:
            .regularExpression, range: nil).replacingOccurrences(of: "&[^;]+;", with:
                "", options:.regularExpression, range: nil)
    }
    func checkForValidLength(min: Int, max: Int) -> Bool{
        return self.count >= min && self.count <= max
    }
    static func join(strings: [String?]?, separator: String) -> String {
        guard let strings = strings else{return ""}
        return strings.compactMap { $0 }.joined(separator: separator)
    }
}


