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
    var placeID: String?
  
    @IBOutlet weak var toggleHoursButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let placesClient = GMSPlacesClient.shared()
            reviewsTextView.isHidden = true
        fetchPlaceDetails()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var nameLabel: UILabel!
            @IBOutlet weak var addressLabel: UILabel!
            @IBOutlet weak var hoursLabel: UILabel!
            @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var ratingsLabel: UILabel!
    @IBOutlet weak var reviewsTextView: UITextView!
         

           
    @IBAction func toggleHoursTapped(_ sender: UIButton) {
                isHoursVisible.toggle() // Toggle the flag

                // Update the hours label visibility
                reviewsTextView.isHidden = !isHoursVisible

                // Update the button title based on visibility
                let buttonTitle = isHoursVisible ? "Hide Reviews" : "Show Reviews"
                toggleHoursButton.setTitle(buttonTitle, for: .normal)
            }

            @IBAction func getDetailsTapped(_ sender: UIButton) {
                fetchPlaceDetails()
            }

            func fetchPlaceDetails() {
                let placesClient = GMSPlacesClient.shared()
                guard let placeID = placeID else { return }
                //let placeID = "ChIJwZGQzPQUkFQRRhd8D82mN_k" // Replace with the actual Place ID

                placesClient.fetchPlace(fromPlaceID: placeID, placeFields: [.name, .formattedAddress, .openingHours, .rating, .photos, .coordinate,], sessionToken: nil, callback: { (place, error) in
                    if let error = error {
                        print("Error fetching place details: \(error.localizedDescription)")
                        return
                    }
                    guard let place = place else {
                        print("No place details found")
                        return
                    }

                    self.updateUI(with: place)
                    self.fetchPlaceReviews(placeID: placeID)
                })
            }

            func updateUI(with place: GMSPlace) {
                nameLabel.text = place.name
                addressLabel.text = place.formattedAddress
                print(place.openingHours?.weekdayText ?? "No opening hours data")
                if place.rating > 0 {
                    ratingsLabel.attributedText = createRatingAttributedString(rating: Double(place.rating))
                        } else {
                            ratingsLabel.text = "Rating: N/A"
                        }
                //hoursLabel.text = place.openingHours?.weekdayText!.joined(separator: "\n")
               
                
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
    func fetchPlaceReviews(placeID: String) {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                print("Unable to access AppDelegate")
                return
            }

            let urlString = "https://maps.googleapis.com/maps/api/place/details/json?place_id=\(placeID)&fields=reviews&key=\(appDelegate.googlePlacesAPIKey)"
            guard let url = URL(string: urlString) else {
                print("Invalid URL")
                return
            }

            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Error fetching reviews: \(error.localizedDescription)")
                    return
                }

                guard let data = data else {
                    print("No data returned")
                    return
                }

                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    if let result = json?["result"] as? [String: Any], let reviews = result["reviews"] as? [[String: Any]] {
                        var reviewsText = NSMutableAttributedString()
                        for review in reviews {
                            if let authorName = review["author_name"] as? String, let rating = review["rating"] as? Int, let text = review["text"] as? String {
                                let reviewString = self.createReviewAttributedString(authorName: authorName, rating: rating, text: text)
                                reviewsText.append(reviewString)
                                reviewsText.append(NSAttributedString(string: "\n\n"))
                            }
                        }

                        DispatchQueue.main.async {
                            self.reviewsTextView.attributedText = reviewsText
                        }
                    }
                } catch {
                    print("Error parsing JSON: \(error.localizedDescription)")
                }
            }

            task.resume()
        }

    func createReviewAttributedString(authorName: String, rating: Int, text: String) -> NSAttributedString {
            let boldAttribute = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]
            let regularAttribute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
            
            let boldString = NSMutableAttributedString(string: authorName, attributes: boldAttribute)
            boldString.append(NSAttributedString(string: "\n"))
            
            let ratingString = NSMutableAttributedString(string: "\(rating) ")
            for _ in 0..<rating {
                let imageAttachment = NSTextAttachment()
                imageAttachment.image = UIImage(named: "star.png")
                imageAttachment.bounds = CGRect(x: 0, y: -2, width: 14, height: 14)
                ratingString.append(NSAttributedString(attachment: imageAttachment))
            }
            ratingString.append(NSAttributedString(string: "\n", attributes: regularAttribute))
            
            let reviewTextString = NSAttributedString(string: text, attributes: regularAttribute)
            
            let fullString = NSMutableAttributedString()
            fullString.append(boldString)
            fullString.append(ratingString)
            fullString.append(reviewTextString)
            
            return fullString
        }
    }
func createRatingAttributedString(rating: Double) -> NSAttributedString {
        let roundedRating = String(format: "%.1f", rating)
        let fullString = NSMutableAttributedString(string: "\(roundedRating) ")
       // Add star image
       let imageAttachment = NSTextAttachment()
       imageAttachment.image = UIImage(named: "star.png")
       imageAttachment.bounds = CGRect(x: 0, y: -2, width: 28, height: 28) 

       let imageString = NSAttributedString(attachment: imageAttachment)
       fullString.append(imageString)

       return fullString
   }


    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


