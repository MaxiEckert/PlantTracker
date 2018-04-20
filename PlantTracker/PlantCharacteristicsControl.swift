//
//  PlantCharacteristicsControl.swift
//  PlantTracker
//
//  Created by Maximilian Eckert on 4/17/18.
//  Copyright © 2018 Maximilian Eckert. All rights reserved.
//

import UIKit

@IBDesignable class PlantCharacteristicsControl: UIStackView {
    
    private var characteristicsButtons = [UIButton]()
    var characteristicsRating = 0 {
        didSet {
            updateButtonSelectionStates()
        }
    }
    
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            setupButtons()
        }
    }
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setupButtons()
        }
    }
    @IBInspectable var starColor: String = "blue" {
        didSet {
            setupButtons()
        }
    }
    

    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    //MARK: Button action
    @objc func characteristicSelectionButtonTapped(button: UIButton) {
        guard let index = characteristicsButtons.index(of: button) else {
            fatalError("The button, \(button), is not in the ratingButtons array: \(characteristicsButtons)")
        }
        
        // Calculate the rating of the selected button
        let selectedRating = index + 1
        
        if selectedRating == characteristicsRating {
            // If the selected star represents the current rating, reset the rating to 0.
            characteristicsRating = 0
        } else {
            // Otherwise set the rating to the selected star
            characteristicsRating = selectedRating
        }
    }
    
    private func updateButtonSelectionStates() {
        for (index, button) in characteristicsButtons.enumerated() {
            // If the index of a button is less than the rating, that button should be selected.
            button.isSelected = index < characteristicsRating
        }
    }
    
    
    //MARK: Private Methods
    private func setupButtons() {
        for button in characteristicsButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        characteristicsButtons.removeAll()
        
        let bundle = Bundle(for: type(of: self))
        
        let filledStarBlue = UIImage(named: "filledStarBlue", in: bundle, compatibleWith: self.traitCollection)
        let emptyStarBlue = UIImage(named:"emptyStarBlue", in: bundle, compatibleWith: self.traitCollection)
        
        let filledStarRed = UIImage(named: "filledStarRed", in: bundle, compatibleWith: self.traitCollection)
        let emptyStarRed = UIImage(named:"emptyStarRed", in: bundle, compatibleWith: self.traitCollection)
        
        let filledStarYellow = UIImage(named: "filledStarYellow", in: bundle, compatibleWith: self.traitCollection)
        let emptyStarYellow = UIImage(named:"emptyStarYellow", in: bundle, compatibleWith: self.traitCollection)
        
        for _ in 0..<starCount {
            let button = UIButton()
            
            //button.backgroundColor = starColor
            switch starColor {
                case "blue":
                    button.setImage(emptyStarBlue, for: .normal)
                    button.setImage(filledStarBlue, for: .selected)
                case "red":
                    button.setImage(emptyStarRed, for: .normal)
                    button.setImage(filledStarRed, for: .selected)
                case "yellow":
                    button.setImage(emptyStarYellow, for: .normal)
                    button.setImage(filledStarYellow, for: .selected)
                default:
                    button.setImage(emptyStarBlue, for: .normal)
                    button.setImage(filledStarBlue, for: .selected)
            }
            
            
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            button.addTarget(self, action: #selector(PlantCharacteristicsControl.characteristicSelectionButtonTapped(button:)), for: .touchUpInside)
            
            addArrangedSubview(button)
            
            characteristicsButtons.append(button)
        }
        
        updateButtonSelectionStates()
    }

}


