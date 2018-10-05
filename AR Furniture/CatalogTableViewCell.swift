//
//  CatalogTableViewCell.swift
//  AR Furniture
//
//  Created by Dragan Milovanovic on 10/5/18.
//  Copyright © 2018 Dragan Milovanovic. All rights reserved.
//

import UIKit

class CatalogTableViewCell: UITableViewCell {

    @IBOutlet weak var rowNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
