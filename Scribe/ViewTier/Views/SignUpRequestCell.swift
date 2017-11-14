//
//  SignUpRequestCell.swift
//  Scribe
//
//  Created by Mikael Son on 7/31/17.
//  Copyright © 2017 Mikael Son. All rights reserved.
//

import UIKit

public protocol SignUpRequestCellDelegate: class {
    func showAcceptAlert(with model: SignUpRequestVOM, sender: UITableViewCell)
    func showDenyAlert(with model: SignUpRequestVOM, sender: UITableViewCell)
}

class SignUpRequestCell: UITableViewCell {

    @IBOutlet weak var denyButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var layoutView: UIView!
    
    var requestModel: SignUpRequestVOM?
    
    weak var delegate: SignUpRequestCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.commonInit()
    }
    
    // MARK: Helper Functions
    
    private func commonInit() {
        self.layoutView.layer.cornerRadius = 3
        self.setButtonLayout()
        self.setShadowEffect()
    }
    
    private func setButtonLayout() {
        self.acceptButton.layer.borderColor = UIColor.scribeDesignTwoBlue.cgColor
        self.acceptButton.layer.borderWidth = 1
        self.acceptButton.layer.cornerRadius = 3
        self.denyButton.layer.borderColor = UIColor.scribeDesignTwoRed.cgColor
        self.denyButton.layer.borderWidth = 1
        self.denyButton.layer.cornerRadius = 3
    }
    
    private func setShadowEffect() {
        self.layoutView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        self.layoutView.layer.shadowColor = UIColor.black.cgColor
        self.layoutView.layer.shadowRadius = 3
        self.layoutView.layer.shadowOpacity = 0.2
        self.layoutView.layer.masksToBounds = false
    }
    
    // MARK: IBAction Functions
    
    @IBAction func acceptButtonTapped(_ sender: UIButton) {
        guard
            let delegate = self.delegate,
            let model = self.requestModel
        else {
            return
        }
        delegate.showAcceptAlert(with: model, sender: self)
    }
    
    @IBAction func denyButtonTapped(_ sender: UIButton) {
        guard
            let delegate = self.delegate,
            let model = self.requestModel
            else {
                return
        }
        delegate.showDenyAlert(with: model, sender: self)
    }
}
