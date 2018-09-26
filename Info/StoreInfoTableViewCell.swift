//
//  StoreInfoTableViewCell.swift
//  AR Furniture
//
//  Created by Igor Aleksic on 9/26/18.
//  Copyright © 2018 Dragan Milovanovic. All rights reserved.
//

import UIKit

class StoreInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var tel: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var hours: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUI (storeInfo : StoreInfo) {
        name.text = storeInfo.name
        address.text = storeInfo.address
        tel.text = storeInfo.tel
        email.text = storeInfo.email
        hours.text = storeInfo.hours
        
        
    }

}
