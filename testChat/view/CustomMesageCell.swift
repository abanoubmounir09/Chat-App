//
//  CustomMesageCell.swift
//  testChat
//
//  Created by pop on 1/3/20.
//  Copyright © 2020 pop. All rights reserved.
//

import UIKit

class CustomMesageCell: UITableViewCell {

    @IBOutlet weak var messagebackground: UIView!
    @IBOutlet weak var senderUserName: UILabel!
    @IBOutlet weak var messageBody: UILabel!
    @IBOutlet weak var avtarimageview: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
