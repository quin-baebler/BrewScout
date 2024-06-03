//
//  MapViewController.swift
//  BrewScout
//
//  Created by Hong Ton on 6/3/24.
//

import UIKit
import MapKit
import GooglePlaces
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var coffeeShops: [Place] = []
    var apiKey: String = "AIzaSyDMfVpurbF4MJ2ZQnhbUPiU03KICxQ_uug"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.first {
                fetchNearbyCoffeeShops(location: location)
                locationManager.stopUpdatingLocation()
                
                let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                mapView.setRegion(region, animated: true)
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
                        self.addAnnotationsToMap()
                    }
                } catch {
                    print("Error decoding JSON: (error)")
                }
            }.resume()
        }

        func addAnnotationsToMap() {
            for place in coffeeShops {
                let annotation = MKPointAnnotation()
                annotation.title = place.name
                annotation.coordinate = CLLocationCoordinate2D(latitude: place.geometry.location.lat, longitude: place.geometry.location.lng)
                mapView.addAnnotation(annotation)
            }
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
