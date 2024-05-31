//
//  FavoritesViewController.swift
//  BrewScout
//
//  Created by Olivia Sapp on 5/28/24.
//

import UIKit
class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    class TableCell : UITableViewCell{
        //cell components
        @IBOutlet weak var shopImage: UIImageView!
        @IBOutlet weak var shopNameLabel: UILabel!
        @IBOutlet weak var shopLocationLabel: UILabel!
        @IBOutlet weak var otherInfoLabel: UILabel!
        @IBOutlet weak var filledHeartButton: UIButton!
    }


    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.delegate = self
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBOutlet weak var tableView: UITableView!
    
    //temp hard coded list
    //need to change this to be adative to user input
    var cafeListFaves =  [
        ("Cafe Solstice", "Seattle, WA", "Wifi, Bathroom, Hours 8am - 5pm"),
        ("Cafe Alegro", "Seattle, WA", "Wifi, Bathroom, Hours 8am - 4pm"),
        ("Sip House", "Seattle, WA", "Wifi, Bathroom, Hours 8am - 5pm")
    ]
    
    var liked = true
    
    //click to like or unlike the caffe
    /*@IBAction func clickHeartButton(_ sender: Any) {
        likeIt(<#T##tableView: UITableView##UITableView#>, cellForRowAt: <#T##IndexPath#>)
    }*/
   
    //likes and unlikes the caffes
    //updates the list of liked cafes
    func likeIt(_ tableView: UITableView, cellForRowAt indexPath: IndexPath){
        let cell = tableView.dequeueReusableCell(withIdentifier: "exampleFavCell", for: indexPath) as! TableCell
        let cafe = cafeListFaves[indexPath.row]
        
        if liked == true{
            cell.filledHeartButton.setImage(UIImage(named: "heart"), for: .normal)
            //remove from favorites list
            cafeListFaves.remove(at: indexPath.row)
            liked = false
        } else { //changes heart to full
            cell.filledHeartButton.setImage(UIImage(named: "heart.fill"), for: .normal)
            //add to favorites list
            //cafeListFaves.append(<#T##newElement: (String, String, String)##(String, String, String)#>)
            liked = true
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cafeListFaves.count
    }
    
    //formating the table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exampleFavCell", for: indexPath) as! TableCell
        let cafe = cafeListFaves[indexPath.row]
        cell.shopNameLabel.text = cafe.0
        cell.shopLocationLabel.text = cafe.1
        cell.otherInfoLabel.text = cafe.2
        cell.filledHeartButton.setImage(UIImage(named: "heart.fill"), for: .normal)
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
            return 150
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
