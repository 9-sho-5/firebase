import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var emailTextFielad: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    private var saveData: UserDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 15
    }
    
    @IBAction func back() {
        dismiss(animated: true)
    }
    
    @IBAction func login() {
        guard let email = emailTextFielad.text, let password = passwordTextField.text else {
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            
            if let error = error {
                print(error.localizedDescription)
                let alert = UIAlertController(title: "メールアドレスまたはパスワードが異なります．", message: "もう一度やり直してください．", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(defaultAction)
                strongSelf.present(alert, animated: true, completion: nil)
                return
            }
            
            if let currentUser = Auth.auth().currentUser {
                if currentUser.isEmailVerified {
                    strongSelf.saveData.set(true, forKey: "isLaunched")
                    strongSelf.performSegue(withIdentifier: "toHome", sender: self) // Segueで画面遷移
                } else {
                    let alert = UIAlertController(title: "メールアドレスが認証されていません．", message: "送信されたメールを確認してください．", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(defaultAction)
                    strongSelf.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toHome" {
            // ここで遷移先のViewControllerにデータを渡すなどの処理を行う
            if let destinationVC = segue.destination as? HomeViewController {
                // 必要に応じてデータを渡す処理
                // destinationVC.someProperty = someValue
            }
        }
    }
}
