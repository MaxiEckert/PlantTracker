//
//  PlantViewController.swift
//  PlantTracker
//
//  Created by Maximilian Eckert on 4/17/18.
//  Copyright © 2018 Maximilian Eckert. All rights reserved.
//

import UIKit
import os.log

class PlantViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var WateringCharacteristicControl: PlantCharacteristicsControl!
    @IBOutlet weak var SunCharacteristicControl: PlantCharacteristicsControl!
    @IBOutlet weak var TempCharacteristicControl: PlantCharacteristicsControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var plant: Plant?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        nameTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //
    }
    
    //MARK ImagePickeController
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Error picking Photo")
        }
        
        photoImageView.image = selectedImage
        
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = nameTextField.text ?? ""
        let photo = photoImageView.image
        let wateringCharacteristic = WateringCharacteristicControl.characteristicsRating
        let sunCharacteristic = SunCharacteristicControl.characteristicsRating
        let tempCharacteristic = TempCharacteristicControl.characteristicsRating
        
        plant = Plant(name: name, photo: photo, wateringCharacteristic: wateringCharacteristic, sunCharacteristic: sunCharacteristic, tempCharacteristic: tempCharacteristic)
    }
    
    //MARK: Actions
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        nameTextField.resignFirstResponder()
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
        

}

