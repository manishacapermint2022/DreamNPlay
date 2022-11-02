//
//  MyContestCell.swift
//  DreamPlay
//
//  Created by MAC on 04/08/21.
//

import UIKit

protocol TableViewNewss{
    func onCickCell(index:Int)

}

class MyContestCell: UITableViewCell {
    
    @IBOutlet weak var prizeLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var winnerLabel: UILabel!
    @IBOutlet weak var joinContestButton: UIButton!
    @IBOutlet weak var leftSeat:UILabel!
    @IBOutlet weak var leftSeats:UILabel!
    @IBOutlet weak var labelTeamCount: UILabel!
    @IBOutlet weak var labelDTeam : UILabel!
    
    
    var cellDelegate:TableViewNewss?
    var index:IndexPath?
    
   

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
