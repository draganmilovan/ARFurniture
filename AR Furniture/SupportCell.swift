//
//  SupportCell.swift
//  AR Furniture
//
//  Created by Dragan Milovanovic on 9/28/18.
//  Copyright © 2018 Dragan Milovanovic. All rights reserved.
//

import UIKit

class SupportCell: UICollectionViewCell {
    
    @IBOutlet private weak var infoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 16.0
    }
    
}
