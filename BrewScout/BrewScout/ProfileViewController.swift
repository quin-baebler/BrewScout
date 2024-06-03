//
//  ProfileViewController.swift
//  BrewScout
//
//  Created by Olivia Sapp on 5/28/24.
//

import FirebaseCore
import FirebaseAuth
import UIKit
import GooglePlaces

class RevTableCell : UITableViewCell{
    
    @IBOutlet weak var revCafeNameLabel: UILabel!
    @IBOutlet weak var revDescLabel: UILabel!
    
    @IBOutlet weak var heartButton: UIButton!
}

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        emailLabel.text = profileData[0]
        nameLabel.text = profileData[1]
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func editProfile(_ sender: Any) {
        
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    //temp hard coded data
    //need to change this to be adative to user input
    var profileData = ["user@test.com", "Bob"]
    
    //temp hard coded list
    //need to change this to be adative to user input
    var reviewsList =  [
        ("Cafe Solstice", "nice staff, good coffee"),
        ("Cafe Alegro", "One of my favorite coffee shops in the area, greate coffee!"),
        ("Sip House", "The coffee is super sweet. The barista was nice.")
    ]
    
    @IBOutlet weak var tableView: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reviewsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exampleRevCell", for: indexPath) as! RevTableCell
        let cafe = reviewsList[indexPath.row]
        cell.revCafeNameLabel.text = cafe.0
        cell.revDescLabel.text = cafe.1
        //cell.heartButton.setImage(UIImage(named: "heart.fill"), for: .normal)
        
        return cell
    }
    
    //set size
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 120
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
