//
//  LoginViewController.swift
//  BrewScout
//
//  Created by Quinton Baebler on 5/30/24.
//

import FirebaseCore
import FirebaseAuth
import UIKit
import GooglePlaces

class LoginViewController : UIViewController {
    var isHoursVisible = false
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
  
  

    

  override func viewDidLoad() {
    super.viewDidLoad()
  

  }
    

    @IBAction func LoginButtonTapped(_ sender: UIButton) {
        
        addAccount(email: email.text!, password: password.text!)
    }
    
    func addAccount(email: String, password: String) {
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                guard let strongSelf = self else {
                    print("Self is nil.")
                    return
                }
                
                if let error = error {
                    print("Error signing in: \(error.localizedDescription)")
                } else if let authResult = authResult {
                    print("Successfully signed in! User: \(authResult.user.email ?? "No email")")
                } else {
                    print("Unknown error occurred.")
                }
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
