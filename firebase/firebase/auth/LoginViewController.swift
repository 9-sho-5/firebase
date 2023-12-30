//
//  LoginViewController.swift
//  firebase
//
//  Created by ほしょ on 2023/12/29.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var emailTextFielad: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 15
    }
    
    @IBAction func login() {
        guard let email = emailTextFielad.text, let password = passwordTextField.text else {
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            
            if let error = error {
                print(error.localizedDescription)
                let alert: UIAlertController = UIAlertController(title: "メールアドレスまたはパスワードが異なります．", message: "もう一度やり直してください．", preferredStyle: .alert)
                
                //OKボタン
                let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: {
                    //ボタンが押された時の処理
                    (action: UIAlertAction) -> Void in
                })
                
                //UIAlertControllerにActionを追加
                alert.addAction(defaultAction)
                
                //Alertを表示
                strongSelf.present(alert, animated: true, completion: nil)
                return
            }
            
            if let currentUser = Auth.auth().currentUser {
                // メール認証されていれば
                if (currentUser.isEmailVerified) {
                    // 問題なくログインできれば，Homeに画面遷移する
                    let homeViewController = strongSelf.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                    strongSelf.present(homeViewController, animated: true, completion: nil)
                } else {
                    let alert: UIAlertController = UIAlertController(title: "メールアドレスが認証されていません．", message: "送信されたメールを確認してください．", preferredStyle: .alert)
                    
                    //OKボタン
                    let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: {
                        //ボタンが押された時の処理
                        (action: UIAlertAction) -> Void in
                    })
                    
                    //UIAlertControllerにActionを追加
                    alert.addAction(defaultAction)
                    
                    //Alertを表示
                    strongSelf.present(alert, animated: true, completion: nil)
                    return
                }
            }
        }
    }
    
    // 画面遷移時の設定
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // ②Segueの識別子確認
        if segue.identifier == "HomeViewController" {
        }
    }
}
