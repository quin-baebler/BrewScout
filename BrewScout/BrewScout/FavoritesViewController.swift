//
//  FavoritesViewController.swift
//  BrewScout
//
//  Created by Olivia Sapp on 5/28/24.
//

import FirebaseCore
import FirebaseAuth
import UIKit
import GooglePlaces

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
        if (!favoriteShops.likedShopIDs.isEmpty) {
            print(favoriteShops.likedShopIDs)
        }
    }

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var searchBar: UISearchBar!

    
    //temp hard coded list
    //need to change this to be adative to user input
    var filteredFaves = [shopTableCell]()
    var searchActive : Bool = false
       
    func reloadData(){
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchActive ? filteredFaves.count : favoriteShops.likedShopIDs.count
    }
    
    func searchCafes(searchText: String) {
        filteredFaves = favoriteShops.likedShopIDs.filter { shopID in
        if let shop = coffeeShops.first(where: { $0.place_id == shopID }) {
            return shop.name.localizedCaseInsensitiveContains(searchText)
        }
            return false
        }
        searchActive = searchText.count > 0
    }
    
    //formating the table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favCell", for: indexPath) as! shopTableCell
        let favoriteShop = favoriteShops.list[indexPath.row]
                
        cell.shopNameLabel.text = favoriteShop.shopName
        cell.shopID = favoriteShop.shopID
        cell.isLiked = true
        cell.filledHeartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                
        // Set other properties as needed
        cell.shopImage.image = favoriteShop.shopImage.image
        cell.shopLocationLabel.text = favoriteShop.shopLocationLabel.text
        cell.otherInfoLabel.text = favoriteShop.otherInfoLabel.text
                
        return cell
    }
    
    //change view to the shop page
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCafe = searchActive ? filteredFaves[indexPath.row] : favoriteShops.list[indexPath.row]
                let placeID = selectedCafe.shopID
                performSegue(withIdentifier: "showFromFavs", sender: placeID)
    }
    
    //set size
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 210
        }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchActive = false;
        filteredFaves.removeAll()
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCafes(searchText: searchText as String)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "showFromFavs", // whatever you make the segue called
               let placeDetailVC = segue.destination as? PlaceDetailViewController,
               let placeID = sender as? String { // can you pass the placeID here so I can access it to display the details
                placeDetailVC.placeID = placeID
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

}
