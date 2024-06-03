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

    class TableCell : UITableViewCell{
        //cell components
        @IBOutlet weak var shopImage: UIImageView!
        @IBOutlet weak var shopNameLabel: UILabel!
        @IBOutlet weak var shopLocationLabel: UILabel!
        @IBOutlet weak var otherInfoLabel: UILabel!
        @IBOutlet weak var filledHeartButton: UIButton!
    }

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        super.viewDidLoad()
        liked = true
        filteredFaves = cafeListFaves
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
    var filtered: String = ""
   
    var liked = true
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return filteredFaves.count
        if(searchActive) {
            return filteredFaves.count
        }
        return cafeListFaves.count;
    }
    
    //formating the table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exampleFavCell", for: indexPath) as! TableCell
        //let cafe = filteredFaves[indexPath.row]
        var cafe = cafeListFaves[indexPath.row]
        if(searchActive){
            for shop in cafeListFaves{
                var temp = filtered
                if shop.0.contains(String(temp)){
                    filteredFaves.append(shop)
                }
            }
             cafe = filteredFaves[indexPath.row]
        }
        
        cell.shopNameLabel.text = cafe.0
        cell.shopLocationLabel.text = cafe.1
        cell.otherInfoLabel.text = cafe.2
        if liked == true {
            cell.filledHeartButton.setImage(UIImage(named: "heart.fill"), for: .normal)
        } else {
            cell.filledHeartButton.setImage(UIImage(named: "heart"), for: .normal)
        }

        //add image and othercompenents
        let imgName: String
        switch cafe.0{
        case "Cafe Solstice":
            imgName = "solstice"
        case "Cafe Allegro":
            imgName = "allegro"
        case "Sip House":
            imgName = "sipHouse"
        default:
            imgName = ""
        }
        cell.shopImage.image = UIImage(named: imgName)
        
        return cell
    }
    
   
    @IBAction func clickHeartButton(_ sender: UIButton) {
        if liked == true{
            liked = false
        } else {
            liked = true
        }
    }
    
    //change view to the shop page
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //when clicked
        //switch pages
    }
    
    //set size
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 190
        }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            searchActive = true;
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        filtered = (shopNamesFaves).filter({ (text) -> Bool in
            let tmp: NSString = text as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
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
