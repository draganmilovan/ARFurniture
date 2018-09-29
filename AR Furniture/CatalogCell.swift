//
//  CatalogCell.swift
//  AR Furniture
//
//  Created by Dragan Milovanovic on 9/25/18.
//  Copyright © 2018 Dragan Milovanovic. All rights reserved.
//

import UIKit


typealias CellData = (imageName: String, name: String)


class CatalogCell: UICollectionViewCell {
    
    // Data source
    var cellData: CellData? {
        didSet {
            guard let cellData = cellData else { return }
            populate(with: cellData)
        }
    }
    
    @IBOutlet private weak var catalogImage: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 16.0
        
        cleanCell()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cleanCell()
    }
    
    
    //
    // Method for cleaning datas for UI
    //
    private func cleanCell() {
        
        catalogImage.image = nil
        nameLabel.text = nil
    }
    
    
    //
    // Method for populating Cell
    //
    private func populate(with cellData: CellData) {
        
        catalogImage.image = UIImage(named: cellData.imageName)
        nameLabel.text = cellData.name
        
    }
    
}
