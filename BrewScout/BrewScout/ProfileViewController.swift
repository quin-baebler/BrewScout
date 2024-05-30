//
//  ProfileViewController.swift
//  BrewScout
//
//  Created by Olivia Sapp on 5/28/24.
//

import UIKit

class RevTableCell : UITableViewCell{
    
    @IBOutlet weak var revImage: UIImageView!
    @IBOutlet weak var revCafeNameLabel: UILabel!
    @IBOutlet weak var revDescLabel: UILabel!
    
    @IBOutlet weak var heartButton: UIButton!
}

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = profileData[0]
        usernameLabel.text = profileData[1]
        emailLabel.text = profileData[2]
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func editProfile(_ sender: Any) {
        
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    //temp hard coded data
    //need to change this to be adative to user input
    var profileData = ["Name", "userName", "email"]
    
    //temp hard coded list
    //need to change this to be adative to user input
    var reviewsList =  [
        ("Cafe Solstice", "my rev"),
        ("Cafe Alegro", "my rev"),
        ("Sip House", "my rev")
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
        //add image and othercompenents
        
        return cell
    }
    
    //set size
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 100
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



class EditProfileViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var FinishSaveButton: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var emailTextFeild: UITextField!
    
    
    var profileData = ["Name", "userName", "email"]

    
    @IBAction func changeName(_ sender: Any) {
        profileData[0] = nameTextField.text ?? profileData[0]
    }
    
    @IBAction func changeUsername(_ sender: Any) {
        profileData[1] = usernameTextField.text ?? profileData[1]
    }
    
    @IBAction func changeEmail(_ sender: Any) {
        profileData[2] = emailTextFeild.text ?? profileData[2]
    }
    
    
    @IBAction func FinishSaveButtonClick(_ sender: Any) {
        performSegue(withIdentifier: "saveEdits", sender: FinishSaveButton)
        //send updated profile data back to the profile page
        
    }
    
    
    @IBAction func cancelButtonClick(_ sender: Any) {
        performSegue(withIdentifier: "cancelEdits", sender: cancelButton)

    }
    
}
