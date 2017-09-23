//
//  CustomCell.swift
//  CustomCalendar
//
//  Created by APPLE-HOME on 21/09/17.
//  Copyright © 2017 Encureit system's pvt.ltd. All rights reserved.
//

import UIKit
import JTAppleCalendar

let preDateSelectable: Bool = false

class CustomCell: JTAppleCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var selectedView: UIView!
}
