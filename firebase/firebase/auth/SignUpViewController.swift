//
//  SignUpViewController.swift
//  firebase
//
//  Created by ほしょ on 2023/12/27.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var emailTextFielad: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpButton.layer.cornerRadius = 15
    }
    
    @IBAction func signUp() {
        guard let email = emailTextFielad.text, let password = passwordTextField.text  else {
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if (authResult != nil && error == nil) {
                print("register successed")
                
                self.sendLoginLink(email, password)
                
                self.emailTextFielad.text = "";
                self.passwordTextField.text = ""
            } else {
                print("register failed")
                print(error?.localizedDescription)
                
                let alert: UIAlertController = UIAlertController(title: "エラーが発生しました．", message: "もう一度やり直してください．", preferredStyle: .alert)
                
                //OKボタン
                let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: {
                    //ボタンが押された時の処理
                    (action: UIAlertAction) -> Void in
                })
                
                //UIAlertControllerにActionを追加
                alert.addAction(defaultAction)
                
                //Alertを表示
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func sendLoginLink(_ email: String, _ password: String) {
        
        if let user = Auth.auth().currentUser {
            user.sendEmailVerification( completion: { error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                // Email verification sent.
                let alert: UIAlertController = UIAlertController(title: "確認メールを送信しました．", message: "メールを確認してください．", preferredStyle: .alert)
                
                //OKボタン
                let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: {
                    //ボタンが押された時の処理
                    (action: UIAlertAction) -> Void in
                    self.navigationController?.popViewController(animated: true)
                })
                
                //UIAlertControllerにActionを追加
                alert.addAction(defaultAction)
                
                //Alertを表示
                self.present(alert, animated: true, completion: nil)
            })
            return
        }
        
    }
    
}
