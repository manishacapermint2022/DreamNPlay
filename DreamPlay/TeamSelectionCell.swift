//
//  TeamSelectionCell.swift
//  DreamPlay
//
//  Created by MAC on 06/07/21.
//

import UIKit

protocol TableViewNew{
    func onCickCell(index:Int)

}


class TeamSelectionCell: UITableViewCell {
    
    
    var cellDelegate:TableViewNew?
    var index:IndexPath?
    @IBOutlet weak var playerImage: UIImageView!
    
    @IBOutlet weak var playerName: UILabel!
    
    @IBOutlet weak var teamName: UILabel!
    
    @IBOutlet weak var creditLabel: UILabel!
    @IBOutlet weak var playerAddButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        playerImage.makeCornerRadius(playerImage.frame.size.height / 2)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func clickMe(_ sender:UIButton) {
        
       cellDelegate?.onCickCell(index: index!.row)


}
}

