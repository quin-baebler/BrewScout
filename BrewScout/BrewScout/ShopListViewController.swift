//
//  ShopListViewController.swift
//  BrewScout
//
//  Created by Phillip Dang on 6/1/24.
//

import UIKit
import MapKit
import GooglePlaces
import CoreLocation



class shopTableCell : UITableViewCell {
    //cell components
    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var shopImage: UIImageView!
    @IBOutlet weak var shopLocationLabel: UILabel!
    @IBOutlet weak var otherInfoLabel: UILabel!
    @IBOutlet weak var filledHeartButton: UIButton!
    var isLiked = false
    var shopID = ""
    @IBAction func likeShop(_ sender: UIButton) {
        isLiked = !isLiked
        if (isLiked) {
            favoriteShops.list.append(self)
            print(favoriteShops.list.count)
            filledHeartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            favoriteShops.list.removeAll(where: {$0.shopID == shopID})
            print(favoriteShops.list.count)
            filledHeartButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
}

class ShopListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var coffeeShops: [Place] = []
    var filteredCafes = [Place]()
    var isFiltered = false
    var apiKey: String = "AIzaSyDMfVpurbF4MJ2ZQnhbUPiU03KICxQ_uug"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        self.filteredCafes = coffeeShops
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        // Do any additional setup after loading the view.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            fetchNearbyCoffeeShops(location: location)
            locationManager.stopUpdatingLocation()
        }
    }

    func fetchNearbyCoffeeShops(location: CLLocation) {
        let urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(location.coordinate.latitude),\(location.coordinate.longitude)&radius=1000&type=cafe&key=\(apiKey)"

        guard let url = URL(string: urlString) else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data: (String(describing: error))")
                return
            }

            do {
                let placesResponse = try JSONDecoder().decode(PlacesResponse.self, from: data)
                self.coffeeShops = placesResponse.results

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("Error decoding JSON: (error)")
            }
        }.resume()
    }
    
    func fetchImage(for photoReference: String, completion: @escaping (UIImage?) -> Void) {
        let urlString = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=100&photoreference=\(photoReference)&key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching image: \(String(describing: error))")
                completion(nil)
                return
            }
                
            let image = UIImage(data: data)
            completion(image)
        }.resume()
    }
    
    struct Place: Decodable {
        let name: String
        let place_id: String
        let types: [String]
        let geometry: Geometry
        let photos: [Photo]?
    }
    
    struct Photo: Decodable {
        let photo_reference: String
        let height: Int
        let width: Int
    }

    struct Geometry: Decodable {
        let location: Location
    }

    struct Location: Decodable {
        let lat: Double
        let lng: Double
    }

    struct PlacesResponse: Decodable {
        let results: [Place]
    }
    

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var liked = true
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltered ? filteredCafes.count : coffeeShops.count
    }
    
    //formating the table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shopCell", for: indexPath) as! shopTableCell
        let place = isFiltered ? filteredCafes[indexPath.row] : coffeeShops[indexPath.row]
        print(place)
        cell.shopNameLabel.text = place.name
        cell.shopLocationLabel.text = "Location"
        cell.otherInfoLabel.text = "Other Info"
        cell.shopID = place.place_id
        if (favoriteShops.list.contains(where: {$0.shopID == cell.shopID})) {
            cell.filledHeartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            cell.isLiked = true
        } else {
            cell.filledHeartButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        cell.shopID = place.place_id
        
        if let photos = place.photos, let photoReference = photos.first?.photo_reference {
            fetchImage(for: photoReference) { image in
                DispatchQueue.main.async {
                    cell.shopImage.image = image
                }
            }
        } else {
            cell.shopImage.image = nil
        }
        //add image and othercompenents
        return cell
    }
    

    
    //change view to the shop page
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //when clicked
        //switch pages
    }
    
    //set size
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            filteredCafes = coffeeShops.filter({$0.name.contains(searchText)})
            isFiltered = true
            tableView.reloadData()
        } else {
            self.filteredCafes = coffeeShops
            isFiltered = false
            tableView.reloadData()
        }
    }
    // Use this to pass the place id into the details page for the specific shop - Quin
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "showPlaceDetail", // whatever you make the segue called
               let placeDetailVC = segue.destination as? PlaceDetailViewController,
               let placeID = sender as? String { // can you pass the placeID here so I can access it to display the details
                placeDetailVC.placeID = placeID
            }
        } */
}
