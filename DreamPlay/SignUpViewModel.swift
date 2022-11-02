//
//  SignUpViewModel.swift
//  DreamPlay
//
//  Created by MAC on 23/06/21.
//

import UIKit
import MBProgressHUD

protocol signDataImage {
    func getData(data :SData? )
    func  getError(message : String)
}

class SignUpViewModel: NSObject {
    
    var loginModel : LoginModel?
    var responseData : SData?
    var delegate : signDataImage?
    
    
    func callGetImageApi(parameter:[String : Any],viewcont : UITableViewController){
        let spinnerActivity = MBProgressHUD.showAdded(to: viewcont.view, animated: true);
        spinnerActivity.label.text = "Loading";
        spinnerActivity.detailsLabel.text = "Please Wait!!";
        viewcont.view.isUserInteractionEnabled = false;
        NetworkManager.shared.performPOSTRequest(Constants.BaseUrl + "register", params: parameter as [String : AnyObject], headers:nil, success: { (response) in
            MBProgressHUD.hide(for: viewcont.view, animated: true)
            viewcont.view.isUserInteractionEnabled = true;
            do {
                print(response)
                if response.status == 1{
                    self.delegate?.getData(data: response.responseData)
                }else{
                    self.delegate?.getError(message: response.message!)
                    
                }
                // print(response.)
                //   self.loginModel = try JSONDecoder().decode(LoginModel.self, from: response.rawData())
                //
                //                      if(self.imgModel?.responseCode == "200" && self.imgModel?.responseStatus == "success"){
                //
                //
                //
                //                          self.dataImage = self.imgModel?.data
                //
                //                          self.delegate?.getImg(patvisitList: self.dataImage)
                //                             // self.delegate?.getPatMediHistoryList(patHisList: self.patMediHistryArr)
                //                      }
                //                      else{
                //                      }
                
            }catch{
                
            }
        }) { (error) in
            
            viewcont.view.isUserInteractionEnabled = true;
            MBProgressHUD.hide(for: viewcont.view, animated: true)
            print(error)
        }
    }
}
