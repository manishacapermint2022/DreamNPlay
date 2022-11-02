//
//  DPFindPeopleVC.swift
//  DreamPlay
//
//  Created by MAC on 15/06/21.
//

import UIKit

class DPFindPeopleVC: UIViewController {
    
    var isOpen = false
    var screenCheck = false
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 70.0
        let logo = UIImage(named:"layer3")
        let imageView = UIImageView(image:logo)
        imageView.frame = CGRect(x: 150, y: 20, width: 100.0, height: 30.0)
        self.navigationItem.titleView = imageView
        
        tableView.backgroundView = UIImageView(image: UIImage(named: "Background"))
    }
    @IBAction func toggleButtonTapped(_ sender: Any) {
        
    }
}

    
extension DPFindPeopleVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if let borderView = cell.viewWithTag(10) {
            
            borderView.layer.cornerRadius = 8
            borderView.layer.borderWidth = 1
            borderView.layer.borderColor = UIColor.clear.cgColor
        }
        
        if let profileImage = cell.viewWithTag(20) {
            profileImage.layer.borderWidth = 1.0
            profileImage.layer.masksToBounds = true
            profileImage.layer.borderColor = UIColor.clear.cgColor
            // self.profileImageView.borderColor = UIColor(red: 0.0/255, green: 145.0/255, blue: 186.0/255, alpha: 1.0)
            profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
            profileImage.clipsToBounds = true
        }
        
        
        return cell
    }
    
    
    
}

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


