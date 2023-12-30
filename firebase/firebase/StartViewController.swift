//
//  StartViewController.swift
//  firebase
//
//  Created by ほしょ on 2023/12/29.
//

import UIKit

class StartViewController: UIViewController {
    
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        signUpButton.layer.cornerRadius = 15
        loginButton.layer.cornerRadius = 15
        loginButton.setBorder(color: UIColor.darkGray.cgColor, width: 1.0)
    }

}
