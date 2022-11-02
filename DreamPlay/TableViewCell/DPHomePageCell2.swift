//
//  DPHomePageCell2.swift
//  DreamPlay
//
//  Created by sismac020 on 06/05/22.
//

import UIKit
import UPCarouselFlowLayout

class DPHomePageCell2: UITableViewCell {
    static let ID = "DPHomePageCell2"
    @IBOutlet weak var collectionView: UICollectionView!
    let floawLayout = UPCarouselFlowLayout()
    var nav : UINavigationController? = nil
    
    fileprivate var pageSize: CGSize {
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        var pageSize = layout.itemSize
        if layout.scrollDirection == .horizontal {
            pageSize.width += layout.minimumLineSpacing
        } else {
            pageSize.height += layout.minimumLineSpacing
        }
        return pageSize
    }
    
    var completedGame = [[String: Any]]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        registerCVCell()
    }
    
    func getCompletedGame(data: [[String: Any]], vc: UINavigationController?) {
        self.completedGame = data
        self.nav = vc
        collectionView.reloadData()
    }
    
    func registerCVCell() {
        floawLayout.itemSize = CGSize(width: UIScreen.main.bounds.size.width / 1.2 , height: collectionView.frame.size.height)
        floawLayout.scrollDirection = .horizontal
        floawLayout.sideItemScale = 0.95
        floawLayout.sideItemAlpha = 1.0
        floawLayout.spacingMode = .fixed(spacing: 5.0)
        self.collectionView.collectionViewLayout = floawLayout
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "HomeMyMatchesCVCell", bundle: nil), forCellWithReuseIdentifier: "HomeMyMatchesCVCell")
    }
    
}

extension DPHomePageCell2: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.completedGame.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeMyMatchesCVCell", for: indexPath)as? HomeMyMatchesCVCell else { return UICollectionViewCell() }
        let data = completedGame[indexPath.row]
        cell.lblTeamAScore.text = data["teama_score"] as? String ?? ""
        cell.lblTeamBScore.text = data["teamb_score"] as? String ?? ""
        if let teamAIcon = cell.viewWithTag(40) as? UIImageView {
            if let imageUrl = data["teama_image"] as? String,
               !imageUrl.isEmpty, let imgURl =  URL(string:imageUrl) {
                teamAIcon.sd_setImage(with: imgURl, placeholderImage: UIImage(named: "placeholder_icon"), completed: nil)
            }
            else {
                teamAIcon.image = UIImage(named: "placeholder_icon")
            }
        }
        cell.borderView.layer.cornerRadius = 8
        cell.borderView.layer.borderWidth = 1
        cell.borderView.layer.borderColor = UIColor.clear.cgColor
        cell.borderView.layer.masksToBounds = true
        cell.borderView.clipsToBounds = true
        
        if let teamBIcon = cell.viewWithTag(50) as? UIImageView {
            if let imageUrl = data["teamb_image"] as? String,
               !imageUrl.isEmpty, let imgURl =  URL(string:imageUrl) {
                teamBIcon.sd_setImage(with: imgURl,placeholderImage: UIImage(named: "placeholder_icon"), completed: nil)
            }
            else {
                teamBIcon.image = UIImage(named: "placeholder_icon")
            }
        }
        
        if let teamA = cell.viewWithTag(60) as? UILabel {
            teamA.text = data["teama_short_name"] as? String
        }
        
        if let teamB = cell.viewWithTag(70) as? UILabel {
            teamB.text = data["teamb_short_name"] as? String
        }
        if let gameStatus = cell.viewWithTag(80) as? UILabel {
            gameStatus.backgroundColor = .red
            gameStatus.textColor = .white
            if  let stats = data["status"] as? String {
                if stats == "LIVE" {
                    gameStatus.text = "Time's up!"
                }
                else{
                    gameStatus.text = data["status"] as? String
                }
            }
            
        }
        if let gameType = cell.viewWithTag(90) as? UILabel {
            gameType.text = data["type"] as? String
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dictionary = self.completedGame[indexPath.row]
        print("Dictionary \(dictionary)")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let menuVC  = storyboard.instantiateViewController(withIdentifier: "DPContestVC") as? DPContestVC
        menuVC?.contestDictionary = dictionary
        menuVC?.tagController = "homeDetail"
        self.nav?.pushViewController(menuVC!, animated: true)
    }
}

extension DPHomePageCell2: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 1.1 , height: 120)
    }
}
