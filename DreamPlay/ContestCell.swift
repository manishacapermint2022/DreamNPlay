//
//  ContestCell.swift
//  DreamPlay
//
//  Created by MAC on 15/07/21.
//

import UIKit

protocol TableViewNews{
    func onCickCell(index:Int)

}

class ContestCell: UITableViewCell {
    
    var cellDelegate:TableViewNews?
    var index:IndexPath?
    @IBOutlet weak var playerImage: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var prizeLabel: UILabel!
    @IBOutlet weak var winnerLabel: UILabel!
    @IBOutlet weak var joinContestButton: UIButton!
    @IBOutlet weak var leftSeat:UILabel!
    @IBOutlet weak var leftSeats:UILabel!
    @IBOutlet weak var labelTeamCount: UILabel!
    @IBOutlet weak var labelDTeam : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        joinContestButton.makeCornerRadius(5)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func clickMe(_ sender:UIButton) {
        cellDelegate?.onCickCell(index: index!.row)
    }
}


