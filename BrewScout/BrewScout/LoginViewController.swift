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
  
  

    

  override func viewDidLoad() {
    super.viewDidLoad()
  

  }
    

    @IBAction func LoginButtonTapped(_ sender: UIButton) {
        let email = "test@example.com"
        let password = "password123"
        addAccount(email: email, password: password)
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
