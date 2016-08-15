//
//  FicCell.swift
//  FicFeed
//
//  Created by Michelle Ran on 7/24/16.
//  Copyright © 2016 Michelle Ran LLC. All rights reserved.
//

import Foundation
import UIKit

class FicCell: UITableViewCell {
    @IBOutlet var title: UILabel!
    @IBOutlet var author: UILabel!
    @IBOutlet var warnings: UILabel!
    @IBOutlet var relationships: UILabel!
    @IBOutlet var summary: UILabel!
    @IBOutlet var rating: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
