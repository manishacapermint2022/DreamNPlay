//
//  HomeMyMatchesCVCell.swift
//  DreamPlay
//
//  Created by sismac020 on 06/05/22.
//

import UIKit

class HomeMyMatchesCVCell: UICollectionViewCell {

    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var lblTeamAScore: UILabel!
    @IBOutlet weak var lblTeamBScore: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        borderView.makeCornerRadius(8)
    }

}
