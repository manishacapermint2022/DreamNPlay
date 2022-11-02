//
//  Helper.swift
//  DoubtClass
//

//

import UIKit
class Helper: NSObject {
   
    //DISABLE ALL TOUCH
    class func disableAllEventTouch(){
        UIApplication.shared.beginIgnoringInteractionEvents();
    }
    //ENABLE ALL TOUCH
    class func enableAllEventTouch(){
        UIApplication.shared.endIgnoringInteractionEvents();
    }
    
    //OPEN URL IN SAFARI
    class func OpenSafariWithURl(urlStr:String){
        UIApplication.shared.openURL(NSURL(string: urlStr)! as URL);
    }
    
    static func showAlertMessage(vc: UIViewController, titleStr:String, messageStr:String) -> Void {
           let alert = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertController.Style.alert);
           
           let alertAction = UIAlertAction(title: "OK", style: .cancel) { (alert) in
               vc.dismiss(animated: true, completion: nil)
           }
           alert.addAction(alertAction)
           
           vc.present(alert, animated: true, completion: nil)
       }
    
    //SAVE BOOL IN DEFAULT
    class func saveBoolInDefaultkey(key:String,state:Bool) {
        UserDefaults.standard.set(state, forKey: key);
        UserDefaults.standard.synchronize();
    }
    
    //FETCH BOOL FROM DEFAULT
    class func fetchBool(key:String)->Bool{
        return UserDefaults.standard.bool(forKey: key);
    }
    
    //SAVE STRING IN USER DEFAULT
    class func saveStringInDefault(key:String,value:String) {
        UserDefaults.standard.set(value, forKey: key);
        UserDefaults.standard.synchronize();
    }
    
    class func getDeviceid() -> String {
        return (UIDevice.current.identifierForVendor?.uuidString)!

    }
    
    
    class func isKeyExistss(key:String ,dict :[String :AnyObject]) ->Bool {
        if let val = dict[key] {
           return true
        }else {
            return false
        }
    }
    
    class func isKeyExists(key:String) ->Bool {
        if (UserDefaults.standard.object(forKey: key) != nil) {
            return true
        }else {
            return false
        }
    }
    
    //SAVE OBJECTS IN USER DEFAULT
    class func saveObjectsInDefault(key:String,value:AnyObject) {
        let data =  NSKeyedArchiver.archivedData(withRootObject: value);
        UserDefaults.standard.set(data, forKey: key)
        UserDefaults.standard.synchronize();
    }
    
    
    //FETCH OBJECTS FROM USER DEFAULT
    class func fetchObjects(key:String)->AnyObject {
        var objData:AnyObject!
        if let data = UserDefaults.standard.object(forKey: key) as? NSData {
            objData = (NSKeyedUnarchiver.unarchiveObject(with: data as Data))! as AnyObject?
            
        }
        return objData;
        }
    
    
    //FETCH STRING FROM USER DEFAULT
    class func fetchString(key:String)->AnyObject {
        if (UserDefaults.standard.object(forKey: key) != nil) {
             return UserDefaults.standard.value(forKey: key)! as AnyObject;
        }else {
            return "" as AnyObject;
        }
    }

    // SAVE OBJECT ARRAY IN USER DEFAULT
    class func saveObjectArray(key:String, objArray:NSMutableArray){
        let data =  NSKeyedArchiver.archivedData(withRootObject: objArray);
        UserDefaults.standard.set(data, forKey: key)
        UserDefaults.standard.synchronize();
    
    }
    
    // SAVE OBJECT DICTONARY IN USER DEFAULT
    class func saveObjectDict(key:String, objArray:[String : AnyObject]){
        let data =  NSKeyedArchiver.archivedData(withRootObject: objArray);
        UserDefaults.standard.set(data, forKey: key)
        UserDefaults.standard.synchronize();
        
    }

    
    // FETCH OBJECT ARRAY FROM USER DEFAULT
    class func fetchObjectArray(key:String)->NSMutableArray {
        var objArray:NSMutableArray=NSMutableArray();
        if let data = UserDefaults.standard.object(forKey: key) as? NSData {
             objArray = (NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? NSMutableArray)!
           
        }
        return objArray;
    }
    
    // FETCH OBJECT DICTIONARY FROM USER DEFAULT
    class func fetchObjectDict(key:String)->[String : AnyObject] {
        var objArray = [String : AnyObject]();
        if let data = UserDefaults.standard.object(forKey: key) as? NSData {
            objArray = (NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? [String : AnyObject])!
        }
        return objArray;
    }
    
    //REMOVE NSUSER DEFAULT
    class func removeUserDefault(key:String) {
        UserDefaults.standard.removeObject(forKey: key);
    }
    
     // SAVE LOGIN AllResultLoginData
//    class func saveLoginCreditionals(loginUserObject:LoginObject) {
//        let data =  NSKeyedArchiver.archivedDataWithRootObject(loginUserObject);
//        NSUserDefaults.standardUserDefaults().setObject(data, forKey: "LOGINCREDENTIAL")
//        NSUserDefaults.standardUserDefaults().synchronize();
//    }
//    
//    // FETCH LOGIN AllResultLoginData
//    class func fetchLoginCreditionals()->LoginObject {
//            let fakeDict = NSDictionary();
//            if (NSUserDefaults.standardUserDefaults().objectForKey("LOGINCREDENTIAL") != nil) {
//                if let data = NSUserDefaults.standardUserDefaults().objectForKey("LOGINCREDENTIAL") as? NSData {
//                    return (NSKeyedUnarchiver.unarchiveObjectWithData(data) as? LoginObject)!;
//                }
//            }
//            let loginUser:LoginObject = LoginObject(dict: fakeDict);
//            return loginUser;
//     }

    
  
   // SEARCH DATA WITH PREDICATE
    class func getSearchList(searchText:String,searchList:NSArray,searchObject:String) -> NSArray {
        //var predicateFilter = NSPredicate(format:"SELF.%@ beginswith[c] %@",searchObject,searchText)
        let predicateFilter = NSPredicate(format:"SELF.%@ CONTAINS[c] %@",searchObject,searchText)
        let filteredList = searchList.filtered(using: predicateFilter)
        return filteredList as NSArray;
    }
    
    
    // SEARCH DATA WITH PREDICATE
//    class func getSearchListByResult(searchText:String,searchList:Results<City>,searchObject:String) -> Results<City> {
//        let predicate = NSPredicate(format: "%@ BEGINSWITH %@", searchObject,searchText)
//        return tanDogs = realm.objects(Dog).filter(predicate)
//    }

    
    class func pushController(cntrl:UIViewController, screenName:String) {
//        if let viewController = NSClassFromString(screenName) as? UIViewController.Type {
//           
//        
//    }
        
        
        
        func notifyUser(_ title: String, message: String, vc: UIViewController) -> Void
        {
            let alert = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: UIAlertController.Style.alert)
            
            let cancelAction = UIAlertAction(title: "OK",
                                             style: .cancel, handler: nil)
            
            alert.addAction(cancelAction)
            //vc will be the view controller on which you will present your alert as you cannot use self because this method is static.
            vc.present(alert, animated: true, completion: nil)
        }
        
}
    
    
   

    
    
    // SEPERATED STRING DATA INTO ARRAY
    class func seperatedByCommas(strValue:String)->NSArray {
        let array = strValue.components(separatedBy: ",") as NSArray
       
        return array;
    }
    
  class  func generateRandomDigits(_ digitNumber: Int) -> String {
        var number = ""
        for i in 0..<digitNumber {
            var randomNumber = arc4random_uniform(10)
            while randomNumber == 0 && i == 0 {
                randomNumber = arc4random_uniform(10)
            }
            number += "\(randomNumber)"
        }
        return number
    }
    
//    class func mergeString(strValue:String)->String {
//        var mergeStr:String = "";
//        let array = strValue.componentsSeparatedByString(" ") as NSArray
//        for (i,, in 0 ..< array.count += 1){
//            mergeStr = mergeStr + (array[i] as! String);
//        }
//        return mergeStr;
//    }
    
    
    // VALIDATE EMAIL ADDRESS
   class func isValidEmail(testStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
     // VALIDATE PHONE NUMBER
 class  func isValidPhone(value: String) -> Bool {
        let PHONE_REGEX = "[2356789][0-9]{6}([0-9]{3})?"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    
    

    
    // CHECK NULL VALUE
    class func checkNullValue(keyValue: String, dictValue:[String :AnyObject])->String{
        if dictValue[keyValue] is NSNull {
            return "";
        }
        else{
            return dictValue[keyValue] as! String
        }
    }
    
    
    class func checkNullValues(keyValue: String, dictValue:[String :AnyObject])->Int{
        if dictValue[keyValue] is NSNull {
            return 0;
        }
        else{
            return dictValue[keyValue] as! Int
        }
    }
    
    // GET YOUTUBE VIDEO ID



}
extension String {
    func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
      self = self.capitalizingFirstLetter()
    }
}
extension Int {
    init(_ range: Range<Int> ) {
        let delta = range.lowerBound < 0 ? abs(range.lowerBound) : 0
        let min = UInt32(range.lowerBound + delta)
        let max = UInt32(range.upperBound  + delta)
        self.init(Int(min + arc4random_uniform(max - min)) - delta)
    }
}
