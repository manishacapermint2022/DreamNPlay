//
//  NetworkManager.swift
//  RhytRx
//
//  Created by Appzlogic on 03/09/19.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit
import Alamofire


class NetworkManager: NSObject {

    static let shared = NetworkManager()
    private  override init() {} //This prevents others from using the default '()' initializer for this class.
    
    
    func performPOSTRequest(_ strURL : String, params : [String : AnyObject]?, headers : [String : AnyObject]?, success:@escaping (SignUpModel) -> Void, failure:@escaping (Error) -> Void){
         
    
        AF.request(strURL, method: .post, parameters: params, encoding:URLEncoding.default, headers:  nil, interceptor:nil).response { (response) in
            
            switch response.result {
            case .success(let data):
                do {
                    print(data as Any)
                     let resuestResponse = try JSONDecoder().decode(SignUpModel.self, from: data!)
                    print(resuestResponse)
//                let parsedData = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
//                    print(parsedData)
              success(resuestResponse)
//
//                    let resuestResponse = try JSONDecoder().decode(APIResponseModel<UserModel>.self, from: data!)
//                    print(resuestResponse.statusCode)
                    
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
                
            case .failure(let error):
                NSLog("Error en searchEmbassy: \(error.localizedDescription)")
            }
        }
        
       
       
//          Alamofire.request(strURL, method: .post, parameters: params!, encoding: URLEncoding.default,headers: headers as? HTTPHeaders).responseJSON { (responseObject) -> Void in
//              #if DEBUG
////              print(responseObject)
//              #endif
//              if responseObject.result.isSuccess {
//                  let resJson = JSON(responseObject.result.value!)
//                  UIApplication.shared.keyWindow?.rootViewController?.view.isUserInteractionEnabled = true
//
//                  success(resJson)
//              }
//              if responseObject.result.isFailure {
//                  let error : Error = responseObject.result.error!
//                  UIApplication.shared.keyWindow?.rootViewController?.view.isUserInteractionEnabled = true
//
//                  failure(error)
//              }
//          }
      }
      /*func performPOSTRequest1(_ strURL : String, params : [String : AnyObject]?, headers : [String : AnyObject]?, success:@escaping (Data) -> Void, failure:@escaping (Error) -> Void){
                     
                
                    AF.request(strURL, method: .post, parameters: params, encoding:URLEncoding.default, headers:  nil, interceptor:nil).response { (response) in
                        
                        switch response.result {
                        case .success(let data):
                            do {
                                print(data)
                                let resuestResponse = try JSONDecoder().decode(HelpModel.self, from: data!)
                                                print(resuestResponse)
                                
    //
            //                let parsedData = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
            //                    print(parsedData)
                                success(data!)
            //
            //                    let resuestResponse = try JSONDecoder().decode(APIResponseModel<UserModel>.self, from: data!)
            //                    print(resuestResponse.statusCode)
                                
                            } catch let error as NSError {
                                print(error.localizedDescription)
                            }
                            
                        case .failure(let error):
                            NSLog("Error en searchEmbassy: \(error.localizedDescription)")
                        }
                    }
    }
    func performPOSTRequest2(_ strURL : String, params : [String : AnyObject]?, headers : [String : AnyObject]?, success:@escaping (Data) -> Void, failure:@escaping (Error) -> Void){
                     
                
                    AF.request(strURL, method: .post, parameters: params, encoding:URLEncoding.default, headers:  nil, interceptor:nil).response { (response) in
                        
                        switch response.result {
                        case .success(let data):
                            do {
                                print(data)
                              
                                
    //
            //                let parsedData = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
            //                    print(parsedData)
                                success(data!)
            //
            //                    let resuestResponse = try JSONDecoder().decode(APIResponseModel<UserModel>.self, from: data!)
            //                    print(resuestResponse.statusCode)
                                
                            } catch let error as NSError {
                                print(error.localizedDescription)
                            }
                            
                        case .failure(let error):
                            NSLog("Error en searchEmbassy: \(error.localizedDescription)")
                        }
                    }
    }
 */
}
