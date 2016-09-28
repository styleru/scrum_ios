//
//  TableViewCell.swift
//  scrum
//
//  Created by Anton Shcherbakov on 24/09/2016.
//  Copyright © 2016 Styleru. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var project: UILabel!
    @IBOutlet weak var deadline: UILabel!
    @IBOutlet weak var background: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.background.layer.cornerRadius = 1.0
        self.background.layer.shadowColor = UIColor.black.cgColor
        self.background.layer.shadowOffset = .zero
        self.background.layer.shadowOpacity = 0.2
        self.background.layer.shadowRadius = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
