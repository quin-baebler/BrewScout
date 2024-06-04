//
//  FavoritesViewController.swift
//  BrewScout
//
//  Created by Olivia Sapp on 5/28/24.
//
import UIKit
import FirebaseCore
import FirebaseAuth
import GooglePlaces

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var apiKey: String = "AIzaSyDMfVpurbF4MJ2ZQnhbUPiU03KICxQ_uug"

    var filteredFaves = [ShopListViewController.Place]()
    var searchActive: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(favoritesUpdated), name: Notification.Name("FavoritesUpdated"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }

    @objc func favoritesUpdated() {
        tableView.reloadData()
    }

    func reloadData() {
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchActive ? filteredFaves.count : FavoriteShops.shared.list.count
    }

    func searchCafes(searchText: String) {
        filteredFaves = FavoriteShops.shared.list.filter { shop in
            return shop.name.localizedCaseInsensitiveContains(searchText)
        }
        searchActive = !filteredFaves.isEmpty
    }
    
    func fetchPlaceDetails(for placeID: String, completion: @escaping (String?) -> Void) {
            let urlString = "https://maps.googleapis.com/maps/api/place/details/json?place_id=\(placeID)&key=\(apiKey)"
            
            guard let url = URL(string: urlString) else {
                completion(nil)
                return
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    print("Error fetching place details: \(String(describing: error))")
                    completion(nil)
                    return
                }
                
                do {
                    let placeDetailsResponse = try JSONDecoder().decode(PlaceDetailsResponse.self, from: data)
                    let address = placeDetailsResponse.result.formatted_address
                    completion(address)
                } catch {
                    print("Error decoding place details JSON: \(error)")
                    completion(nil)
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favCell", for: indexPath) as! shopTableCell
        let favoriteShop = searchActive ? filteredFaves[indexPath.row] : FavoriteShops.shared.list[indexPath.row]
        
        
        if let photos = favoriteShop.photos, let photoReference = photos.first?.photo_reference {
                    fetchImage(for: photoReference) { image in
                        DispatchQueue.main.async {
                            cell.shopImage.image = image
                        }
                    }
                } else {
                    cell.shopImage.image = nil
                }
        // Fetch place details for the address
                fetchPlaceDetails(for: favoriteShop.place_id) { address in
                    DispatchQueue.main.async {
                        cell.shopLocationLabel.text = address
                    }
                }
        
        cell.configure(with: favoriteShop, isLiked: true)
        
        return cell
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCafe = searchActive ? filteredFaves[indexPath.row] : FavoriteShops.shared.list[indexPath.row]
        let placeID = selectedCafe.place_id
        performSegue(withIdentifier: "showFromFavs", sender: placeID)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchActive = false
            tableView.reloadData()
        } else {
            searchCafes(searchText: searchText)
            tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchActive = false
        filteredFaves.removeAll()
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFromFavs",
           let placeDetailVC = segue.destination as? PlaceDetailViewController,
           let placeID = sender as? String {
            placeDetailVC.placeID = placeID
        }
    }
    
    struct Place: Decodable {
            let name: String
            let place_id: String
            let types: [String]
            let formatted_address: String?
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
        
        struct PlaceDetailsResponse: Decodable {
            let result: PlaceDetails
        }

        struct PlaceDetails: Decodable {
            let formatted_address: String
        }
}
