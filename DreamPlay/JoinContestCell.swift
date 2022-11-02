//
//  JoinContestCell.swift
//  DreamPlay
//
//  Created by MAC on 16/07/21.
//

import UIKit

protocol TableViewContest{
    func onCickCell(index:Int)

}

class JoinContestCell: UITableViewCell {

    var cellDelegate:TableViewContest?
    var index:IndexPath?
    @IBOutlet weak var wicketKeeperCount:UILabel!
    @IBOutlet weak var batsmanCount:UILabel!
    @IBOutlet weak var alrounderCount:UILabel!
    @IBOutlet weak var bowlerCount:UILabel!
    @IBOutlet weak var teamAName:UILabel!
    @IBOutlet weak var teamBName:UILabel!
    @IBOutlet weak var captainName:UILabel!
    @IBOutlet weak var viceCaptainName:UILabel!
    @IBOutlet weak var teamACount:UILabel!
    @IBOutlet weak var teamBCount:UILabel!
    @IBOutlet weak var borderView:UIView!
    
    
    @IBOutlet weak var joinContestButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func clickMe(_ sender:UIButton) {
        
       cellDelegate?.onCickCell(index: index!.row)
        if (joinContestButton.isSelected == true)
            {
            joinContestButton.setBackgroundImage(UIImage(named: "addressUnCheck"), for: UIControl.State.normal)
            joinContestButton.isSelected = false;
            }
            else
            {
                joinContestButton.setBackgroundImage(UIImage(named: "addressCheck"), for: UIControl.State.normal)
                joinContestButton.isSelected = true;
            }


}
}
