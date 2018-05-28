//
//  InnoSelectorCustomCellViewController.swift
//  InnoSelector
//
//  Created by gopinath.a on 25/05/18.
//  Copyright © 2018 innoplexus. All rights reserved.
//

import Foundation
import UIKit

class InnoSelectorCustomCellViewController: UITableViewCell {
    
    var mainImage: UIImage?
    var mainMessage: String?
    var subMessage: String?
    
    var mainMessageColor: UIColor = UIColor.black
    var subMessageColor: UIColor = UIColor.darkGray
    
    
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellPrimaryText: UILabel!
    @IBOutlet weak var cellSubText: UILabel!
    
    @IBOutlet weak var cellImageViewLeadingSpace: NSLayoutConstraint!
    @IBOutlet weak var cellImageViewWidth: NSLayoutConstraint!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if mainMessage != nil {
            cellPrimaryText.attributedText = NSAttributedString(string: mainMessage!, attributes: [NSAttributedStringKey.foregroundColor: mainMessageColor])
        }
        
        if subMessage != nil {
            cellSubText.attributedText = NSAttributedString(string: subMessage!, attributes: [NSAttributedStringKey.foregroundColor: subMessageColor])
        }
        
        if mainImage == nil {
            cellImageViewWidth.constant = CGFloat(0)
            cellImageViewLeadingSpace.constant = CGFloat(0)
        }else {
            cellImageView.image = mainImage
        }
        
    }
    
}
