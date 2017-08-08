//
//  CustomRunTableViewCell.swift
//  MapMyTrack
//
//  Created by Stefan Auvergne on 9/22/16.
//  Copyright © 2016 com.example. All rights reserved.
//

import UIKit

class CustomRunTableViewCell: UITableViewCell {
    
    @IBOutlet weak var runNameOutlet: UILabel!
    @IBOutlet weak var runDistanceOutlet: UILabel!
    @IBOutlet weak var runImageOutlet: UIImageView!
    @IBOutlet weak var runResultOutlet: UILabel!
    @IBOutlet weak var editNameOutlet: UIButton!
    @IBOutlet weak var editDistanceOutlet: UIButton!
    @IBOutlet weak var editResultOutlet: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }
    
    func setButtonTag(tag:Int){
        editNameOutlet.tag = tag
        editResultOutlet.tag = tag
        editDistanceOutlet.tag = tag
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
