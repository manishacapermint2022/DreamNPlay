import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tbSubView: UITableView!
    
    
    var isExpand:Bool = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        config()
    }
    
    func config(){
        tbSubView.tableFooterView = UIView()
        if #available(iOS 15.4, *) {
            self.tbSubView.sectionHeaderTopPadding = 0.0
        }
        
        // Setup Header
//        self.collectionView?.register
//        self.collectionView?.register(DPBatsmanHeaderCell.self, forCellWithReuseIdentifier: "DPBatsmanHeaderCell")
//        self.collectionView?.register(DPBowlerHeaderCell.self, forCellWithReuseIdentifier: "DPBowlerHeaderCell")
//        self.collectionView?.register(DPFallWicketHeaderCell.self, forCellWithReuseIdentifier: "DPFallWicketHeaderCell")
        
//        self.collectionView?.register(DPBatsmanHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "DPBatsmanHeaderCell")
//        self.collectionView?.register(DPBowlerHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "DPBowlerHeaderCell")
//        self.collectionView?.register(DPFallWicketHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "DPFallWicketHeaderCell")
        
//        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
//        layout.headerReferenceSize = CGSize(width: collectionView.frame.size.width, height: 40)
//        flowLayout.headerReferenceSize = CGSize(CGSize(width: self.collectionView.frame.size.width, height: 100)
    }

}

extension TableViewCell {

    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.setContentOffset(collectionView.contentOffset, animated:false) // Stops collection view if it was scrolling.
        collectionView.reloadData()
        
    }
    
    func setTableViewDataSourceDelegate<D: UITableViewDataSource & UITableViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {

        tbSubView.delegate = dataSourceDelegate
        tbSubView.dataSource = dataSourceDelegate
        tbSubView.tag = row
        tbSubView.setContentOffset(tbSubView.contentOffset, animated:false) // Stops collection view if it was scrolling.
        tbSubView.reloadData()
        
        
    }
    
    var tableViewOffset: CGFloat {
        set { tbSubView.contentOffset.x = newValue }
        get { return tbSubView.contentOffset.x }
        
      
    }

    var collectionViewOffset: CGFloat {
        set { collectionView.contentOffset.x = newValue }
        get { return collectionView.contentOffset.x }
        
      
    }
    
}
