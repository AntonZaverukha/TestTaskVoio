//
//  ProfileViewController.swift
//  TestTaskVoio
//
//  Created by Anton on 30.03.2023.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileLogInName: UILabel!
    @IBOutlet weak var LogOutButton: UIButton!
    var userMail = Auth.auth().currentUser?.email
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! ViewController
            vc.modalPresentationStyle = .fullScreen
            vc.isModalInPresentation = true
            present(vc, animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileLogInName.text = userMail
    }

}
