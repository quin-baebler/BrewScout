//
//  MapViewController.swift
//  BrewScout
//
//  Created by Hong Ton on 5/30/24.
//

import UIKit
import MapKit
import GooglePlaces
import CoreLocation

class MapViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let locationManager = CLLocationManager()
    var coffeeShops: [Place] = []
    var apiKey: String = "AIzaSyDMfVpurbF4MJ2ZQnhbUPiU03KICxQ_uug"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
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

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return coffeeShops.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            let place = coffeeShops[indexPath.row]
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = "\(place.name)\nLat: \(place.geometry.location.lat), Lng: \(place.geometry.location.lng)"
            print(place)
            return cell
        }
    }

    struct Place: Decodable {
        let name: String
        let place_id: String
        let types: [String]
        let geometry: Geometry
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


