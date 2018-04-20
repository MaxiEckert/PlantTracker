//
//  PlantTableViewCell.swift
//  PlantTracker
//
//  Created by Maximilian Eckert on 4/19/18.
//  Copyright © 2018 Maximilian Eckert. All rights reserved.
//

import UIKit

class PlantTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var dataLabel: UILabel!
    
    @IBOutlet weak var wateringCharacteristicControl: PlantCharacteristicsControl!
    @IBOutlet weak var sunCharacteristicControl: PlantCharacteristicsControl!
    @IBOutlet weak var tempCharacteristicControl: PlantCharacteristicsControl!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
