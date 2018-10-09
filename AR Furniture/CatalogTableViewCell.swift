//
//  CatalogTableViewCell.swift
//  AR Furniture
//
//  Created by Dragan Milovanovic on 10/5/18.
//  Copyright © 2018 Dragan Milovanovic. All rights reserved.
//

import UIKit

class CatalogTableViewCell: UITableViewCell {
    
    var rowLabelText: String? {
        didSet {
            guard let rowLabelText = rowLabelText else { return }

            rowNameLabel.text = rowLabelText
        }
    }

    
    @IBOutlet private weak var rowNameLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        rowNameLabel.text = nil
    }

}
