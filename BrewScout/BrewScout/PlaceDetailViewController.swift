//
//  PlaceDetailViewController.swift
//  BrewScout
//
//  Created by Quinton Baebler on 5/30/24.
//

import FirebaseCore
import FirebaseAuth
import UIKit
import GooglePlaces


   


class PlaceDetailViewController: UIViewController {
    var isHoursVisible = false
  
    @IBOutlet weak var toggleHoursButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let placesClient = GMSPlacesClient.shared()
              hoursLabel.isHidden = true

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var nameLabel: UILabel!
            @IBOutlet weak var addressLabel: UILabel!
            @IBOutlet weak var hoursLabel: UILabel!
            @IBOutlet weak var imageView: UIImageView!
            @IBOutlet weak var getDetailsButton: UIButton!

           
    @IBAction func toggleHoursTapped(_ sender: UIButton) {
                isHoursVisible.toggle() // Toggle the flag

                // Update the hours label visibility
                hoursLabel.isHidden = !isHoursVisible

                // Update the button title based on visibility
                let buttonTitle = isHoursVisible ? "Hide Hours" : "Show Hours"
                toggleHoursButton.setTitle(buttonTitle, for: .normal)
            }

            @IBAction func getDetailsTapped(_ sender: UIButton) {
                fetchPlaceDetails()
            }

            func fetchPlaceDetails() {
                let placesClient = GMSPlacesClient.shared()
                let placeID = "ChIJwZGQzPQUkFQRRhd8D82mN_k" // Replace with the actual Place ID

                placesClient.fetchPlace(fromPlaceID: placeID, placeFields: [.name, .formattedAddress, .openingHours, .photos, .coordinate], sessionToken: nil, callback: { (place, error) in
                    if let error = error {
                        print("Error fetching place details: \(error.localizedDescription)")
                        return
                    }
                    guard let place = place else {
                        print("No place details found")
                        return
                    }

                    self.updateUI(with: place)
                })
            }

            func updateUI(with place: GMSPlace) {
                nameLabel.text = place.name
                addressLabel.text = place.formattedAddress
                print(place.openingHours?.weekdayText ?? "No opening hours data")
                
                hoursLabel.text = place.openingHours?.weekdayText!.joined(separator: "\n")
               
                
                // Fetch the first photo to display
                if let firstPhotoMetadata = place.photos?.first {
                    GMSPlacesClient.shared().loadPlacePhoto(firstPhotoMetadata, callback: { (photo, error) in
                        if let error = error {
                            print("Error loading photo: \(error.localizedDescription)")
                            return
                        }
                        self.imageView.image = photo
                    })
                }
            }
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


