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
//        liked = true
        // Do any additional setup after loading the view.
    }


    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var searchBar: UISearchBar!

    
    //temp hard coded list
    //need to change this to be adative to user input
    var cafeListFaves =  [
        ("Cafe Solstice", "Seattle, WA", "Wifi, Bathroom, Hours 8am - 5pm"),
        ("Cafe Alegro", "Seattle, WA", "Wifi, Bathroom, Hours 8am - 4pm"),
        ("Sip House", "Seattle, WA", "Wifi, Bathroom, Hours 8am - 5pm")
    ]
    var shopNamesFaves = ["Cafe Solstice", "Cafe Alegro", "Sip House"]
   
    var filteredFaves = [(String, String, String)]()
    var searchActive : Bool = false
    //var filtered: String = ""
   
    var liked = true
    
    func reloadData(){
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteShops.list.count
    }
    func searchCafes(searchText: String){
        //clear previous filter results
        filteredFaves.removeAll()
        
        //filter the shop name based on the search text
        let filteredNames = shopNamesFaves.filter {$0.localizedCaseInsensitiveContains(searchText as String)}
        
        //add matching cafes' data to filteredFaves
        for cafe in cafeListFaves{
            if filteredNames.contains(cafe.0){
                filteredFaves.append(cafe)
            }
        }
        
        //set search actiity to true if there is search text
        searchActive = searchText.count > 0
    }
    
    //formating the table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return favoriteShops.list[indexPath.row]
    }
    
   //the like button does not work
    @IBAction func clickHeartButton(_ sender: UIButton) {
        if liked == true{
            liked = false
        } else {
            liked = true
        }
        reloadData()
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
