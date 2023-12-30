//
//  HomeViewController.swift
//  firebase
//
//  Created by ほしょ on 2023/12/29.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {
    
    @IBOutlet var userNameLabel: UILabel!
    
    private var handle: AuthStateDidChangeListenerHandle!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        handle = Auth.auth().addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.userNameLabel.text = user.displayName
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let handle = handle else { return }
        Auth.auth().removeStateDidChangeListener(handle)
    }
}
