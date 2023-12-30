//
//  StartViewController.swift
//  firebase
//
//  Created by ほしょ on 2023/12/29.
//

import UIKit
import FirebaseAuth

class StartViewController: UIViewController {
    
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var loginButton: UIButton!
    
    private var auth = Auth.auth()
    private var saveData: UserDefaults = UserDefaults.standard
    private var handle: AuthStateDidChangeListenerHandle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !saveData.bool(forKey: "isLaunched") {
            // 初回起動したかをUserDefaultsに保存
            saveData.set(true, forKey: "isLaunched")
            do {
                try auth.signOut()
            }
            catch let error {
                print(error.localizedDescription)
            }
        } else {
            handle = auth.addStateDidChangeListener { auth, user in
                if (user != nil) {
                    let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                    self.present(homeViewController, animated: true, completion: nil)
                }
            }
        }
        
        signUpButton.layer.cornerRadius = 15
        loginButton.layer.cornerRadius = 15
        loginButton.setBorder(color: UIColor.darkGray.cgColor, width: 1.0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let handle = handle else { return }
        Auth.auth().removeStateDidChangeListener(handle)
    }
    
    // 画面遷移時の設定
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // ②Segueの識別子確認
        if segue.identifier == "HomeViewController" {
        }
    }
}
