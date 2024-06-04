//
//  SettingsViewController.swift
//  BrewScout
//
//  Created by Hong Ton on 6/3/24.
//

import UIKit

class SettingsViewController: UIViewController {

    
    @IBOutlet weak var radiusButton: UIButton!
    
    @IBOutlet weak var radiusSlider: UISlider!

    @IBOutlet weak var radiusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let savedRadius = UserDefaults.standard.double(forKey: "searchRadius")
        radiusSlider.value = Float(savedRadius != 0 ? savedRadius : 1000)
        updateRadiusLabel()
        
        radiusSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
            updateRadiusLabel()
        }
        
        func updateRadiusLabel() {
            radiusLabel.text = "Radius: \(Int(radiusSlider.value)) meters"
        }
        
    @IBAction func saveButton(_ sender: Any) {
        let radius = Double(radiusSlider.value)
        UserDefaults.standard.set(radius, forKey: "searchRadius")
        
        let alert = UIAlertController(title: "Settings Saved", message: "Your search radius has been updated.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
