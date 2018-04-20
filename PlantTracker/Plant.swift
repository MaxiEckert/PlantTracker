//
//  Plant.swift
//  PlantTracker
//
//  Created by Maximilian Eckert on 4/19/18.
//  Copyright © 2018 Maximilian Eckert. All rights reserved.
//

import UIKit
import os.log

class Plant: NSObject, NSCoding {
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        
        aCoder.encode(wateringCharacteristic, forKey: PropertyKey.wateringCharacteristic)
        aCoder.encode(sunCharacteristic, forKey: PropertyKey.sunCharacteristic)
        aCoder.encode(tempCharacteristic, forKey: PropertyKey.tempCharacteristic)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        let wateringCharacteristic = aDecoder.decodeInteger(forKey: PropertyKey.wateringCharacteristic)
        let sunCharacteristic = aDecoder.decodeInteger(forKey: PropertyKey.sunCharacteristic)
        let tempCharacteristic = aDecoder.decodeInteger(forKey: PropertyKey.tempCharacteristic)
        
        self.init(name: name, photo: photo, wateringCharacteristic: wateringCharacteristic, sunCharacteristic: sunCharacteristic, tempCharacteristic: tempCharacteristic)
    }
    
    
    //MARK: Properties
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        
        static let wateringCharacteristic = "wateringCharacteristic"
        static let sunCharacteristic = "sunCharacteristic"
        static let tempCharacteristic = "tempCharacteristic"
    }
    
    var name: String
    var photo: UIImage?
    
    var data: String?
    
    var wateringCharacteristic: Int
    var sunCharacteristic: Int
    var tempCharacteristic: Int
    
    //MARK:
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("plants")
    
    //MARK: Initialization
    
    init?(name: String, photo: UIImage?, wateringCharacteristic: Int, sunCharacteristic: Int, tempCharacteristic: Int) {
        if name.isEmpty || wateringCharacteristic < 0 || sunCharacteristic < 0 || tempCharacteristic < 0 {
            return nil
        }
        
        self.name = name
        self.photo = photo
        self.wateringCharacteristic = wateringCharacteristic
        self.sunCharacteristic = sunCharacteristic
        self.tempCharacteristic = tempCharacteristic
    }
    
    
    
}
