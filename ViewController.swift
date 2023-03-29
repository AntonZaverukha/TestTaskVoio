//
//  ViewController.swift
//  TestTaskVoio
//
//  Created by Anton on 27.03.2023.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    @IBOutlet weak var logInLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logInButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        emailTextField.autocapitalizationType = .none
        passTextField.isSecureTextEntry = true
    }
}

extension ViewController {
    @objc func didTapButton() {
        guard let email = emailTextField.text, !email.isEmpty,
              let pass = passTextField.text, !pass.isEmpty else {
            print("Missing data")
            return
        }
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: pass, completion: { [weak self] result, error in
            guard let strongSelf = self else {
                return
            }
            guard error == nil else {
                strongSelf.showCreateAccount(email: email, pass: pass)
                return
            }

            print("Signed in")
            strongSelf.handleSuccessfulAuth()
            strongSelf.moveToTabBarController()
        })
    }
    
    func showCreateAccount(email: String, pass: String) {
        let alert = UIAlertController(title: "Create account", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { _ in
            AuthManager.shared.createUser(email: email, password: pass) { result in
                switch result {
                case .success:
                    print("Signed in")
                    self.moveToTabBarController()
                    self.handleSuccessfulAuth()
                case .failure(let error):
                    print("Account creation failed \(error.localizedDescription)")
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}

extension ViewController {
    func handleSuccessfulAuth() {
        logInLabel.isHidden = true
        emailTextField.isHidden = true
        passTextField.isHidden = true
        logInButton.isHidden = true
        emailTextField.resignFirstResponder()
        passTextField.resignFirstResponder()
    }
    
    func moveToTabBarController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarVC = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = windowScene.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = tabBarVC
        }
    }
}


