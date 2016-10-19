//
//  CustomSavedRunTableViewCell.swift
//  MapMyTrack
//
//  Created by Stefan Auvergne on 9/27/16.
//  Copyright © 2016 com.example. All rights reserved.
//

import UIKit

class CustomSavedRunTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBOutlet weak var runDistanceOutlet: UILabel!
    @IBOutlet weak var runResultOutlet: UILabel!
    @IBOutlet weak var runNameOutlet: UILabel!
    @IBOutlet weak var runImageOutlet: UIImageView!
    @IBOutlet weak var editNameOutlet: UIButton!
    @IBOutlet weak var editResultOutlet: UIButton!
    @IBOutlet weak var editDistanceOutlet: UIButton!
    
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
