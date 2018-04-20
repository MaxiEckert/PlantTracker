//
//  PlantTableViewController.swift
//  PlantTracker
//
//  Created by Maximilian Eckert on 4/19/18.
//  Copyright © 2018 Maximilian Eckert. All rights reserved.
//

import UIKit
import os.log

class PlantTableViewController: UITableViewController {
    
    //MARK: Properties
    var plants = [Plant]()
    
    struct PlantData : Codable {
        let value: String
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.navigationItem.leftBarButtonItem = editButtonItem
        
        if let savedPlants = loadPlants() {
            plants += savedPlants
        }
        
        //add refresh
        //self.refreshControl = [[UIRefreshControl alloc] init];
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor.lightGray;
        refreshControl.tintColor = UIColor.white;
        refreshControl.addTarget(self, action: #selector(self.refreshPlantData(_:)), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(refreshControl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plants.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "PlantTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PlantTableViewCell else {
            fatalError()
        }
        
        let plant = plants[indexPath.row]

        cell.nameLabel.text = plant.name
        cell.dataLabel.text = plant.data
        cell.photoImageView.image = plant.photo
        cell.wateringCharacteristicControl.characteristicsRating = plant.wateringCharacteristic
        cell.sunCharacteristicControl.characteristicsRating = plant.sunCharacteristic
        cell.tempCharacteristicControl.characteristicsRating = plant.tempCharacteristic

        return cell
    }
 

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
 

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            plants.remove(at: indexPath.row)
            savePlants()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: Actions
    @IBAction func unwindToPlantList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? PlantViewController, let plant = sourceViewController.plant {
            let newIndexPath = IndexPath(row: plants.count, section: 0)
            plants.append(plant)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            
            savePlants()
        }
    }
    
    //MARK: private methods
    
    private func savePlants() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(plants, toFile: Plant.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save meals...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadPlants() -> [Plant]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Plant.ArchiveURL.path) as? [Plant]
    }
    
    @objc private func refreshPlantData(_ refreshControl: UIRefreshControl) {
        os_log("Refresh called!!", log: OSLog.default, type: .debug)
        
        //do REST GET
        let urlString = "https://io.adafruit.com/api/v2/MaxiEckert/feeds/plant/data/last"
        var urlRequest = URLRequest(url: URL(string: urlString)!)
        urlRequest.addValue("7b34a2dac8aa4acf966ceb006dd65f10", forHTTPHeaderField: "X-AIO-Key")
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            
            //Implement JSON decoding and parsing
            let plantData = try! JSONDecoder().decode(PlantData.self, from: data)
            
            os_log("Data received!!!", log: OSLog.default, type: .debug)
            print(plantData.value)
            
            self.plants[0].data = plantData.value
            self.tableView.reloadData()
            
        }.resume()
        //end rest call
        
        
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }

}
