//
//  CustomTableView.swift
//  DreamPlay
//
//  Created by sismac20 on 27/05/22.
//



import Foundation
import UIKit

class CustomTableView: UITableView {
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return self.contentSize
    }

    override var contentSize: CGSize {
        didSet{
            self.invalidateIntrinsicContentSize()
        }
    }

    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
    }
}
