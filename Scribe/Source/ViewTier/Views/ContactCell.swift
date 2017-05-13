//
//  ContactCell.swift
//  Scribe
//
//  Created by Mikael Son on 5/10/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    private func commonInit() {
        nameLabel.textColor = UIColor.scribeGrey1
    }
    
    // MARK : UITableViewCell
    
//    override func prepareForReuse() {
//        <#code#>
//    }

//    override var isSelected: Bool {
//        
//    }
    
    // MARK : Private Methods
    
    internal func populateCell(with model: ContactVO) {
        self.commonInit()
        self.nameLabel.text = model.name
    }
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    

}
