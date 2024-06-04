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
        if (searchActive) {
            return filteredFaves.count
        } else {
            return favoriteShops.list.count
        }
    }
    func searchCafes(searchText: String){
        //clear previous filter results
        filteredFaves.removeAll()
        
        //filter the shop name based on the search text
        let filteredNames = favoriteShops.list.map({$0.shopName}).filter {$0.localizedCaseInsensitiveContains(searchText as String)}
        
        //add matching cafes' data to filteredFaves
        for cafe in favoriteShops.list {
            if filteredNames.contains(cafe.shopName) {
                filteredFaves.append(cafe)
            }
        }
        
        //set search actiity to true if there is search text
        searchActive = searchText.count > 0
    }
    
    //formating the table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (searchActive) {
            return filteredFaves[indexPath.row]
        } else {
            return favoriteShops.list[indexPath.row]
        }
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
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
