//
//  TableCell.swift
//  UNO
//
//  Created by user on 16/05/2016.
//  Copyright © 2016 APP4-Info-Polytech. All rights reserved.
//

import Foundation
import UIKit

class TableCell: UITableViewCell {
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var detail: String? {
        didSet {
            detailLabel.text = detail
        }
    }
    
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!
    @IBOutlet var txtmdp: UITextField!
    
    var mdp: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        stackView.arrangedSubviews.last?.hidden = true
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
        
        UIView.animateWithDuration(0.5,
                                   delay: 0,
                                   usingSpringWithDamping: 1,
                                   initialSpringVelocity: 1,
                                   options: UIViewAnimationOptions.CurveEaseIn,
                                   animations: { () -> Void in
                                    self.stackView.arrangedSubviews.last?.hidden = !selected
            },
                                   completion: nil)
    }
}
