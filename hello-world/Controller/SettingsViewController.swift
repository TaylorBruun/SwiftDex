//
//  SettingsViewController.swift
//  hello-world
//
//  Created by Taylor on 9/22/22.
//

import Foundation
import UIKit


class SettingsViewController : UIViewController {
    
    private let limitSlider = UISlider(frame: CGRect(x: 0, y: 0, width: 300, height: 20))
    private let buildButton = UIButton()
    private let limitLabel = UILabel()
    var currentLimit = Int()
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        
        limitSlider.center = self.view.center
        limitSlider.minimumValue = 1
        limitSlider.maximumValue = 721
        view.addSubview(limitSlider)
        
        
    }
    
    @objc func handleSliderValueChange(slider: UISlider){
        limitLabel.text = "\(currentLimit)"
    }
    
}
