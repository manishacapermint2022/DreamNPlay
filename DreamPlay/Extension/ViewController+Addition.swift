//
//  ViewController+Addition.swift
//  DreamPlay
//
//  Created by sismac020 on 05/05/22.
//

import UIKit

extension UIViewController {
    func printApiUrlAndParametre(urls: URL?, params: [String: Any]?) {
        print("Url:- \(urls)")
        print("Parameter:- \(params)")
    }
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}



