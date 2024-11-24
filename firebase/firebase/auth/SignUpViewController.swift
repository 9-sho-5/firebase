import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class SignUpViewController: UIViewController {
    
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var emailTextFielad: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    
    let db = Firestore.firestore()
    private var saveData: UserDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpButton.layer.cornerRadius = 15
    }
    
    @IBAction func back() {
        dismiss(animated: true)
    }
    
    @IBAction func signUp() {
        guard let email = emailTextFielad.text, let password = passwordTextField.text, let name = nameTextField.text else {
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if authResult != nil && error == nil {
                print("register succeeded")
                
                self.updateUserProfile(name: name)
                self.sendEmailVerificationLink(email, password)
                
                self.nameTextField.text = ""
                self.emailTextFielad.text = ""
                self.passwordTextField.text = ""
                
                self.uploadUserData(name: name, email: email, imageURL: "")
                
            } else {
                print("register failed")
                print(error?.localizedDescription ?? "Error")
                
                let alert = UIAlertController(title: "エラーが発生しました．", message: "もう一度やり直してください．", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(defaultAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func updateUserProfile(name: String) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        changeRequest?.commitChanges { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
        }
    }
    
    func sendEmailVerificationLink(_ email: String, _ password: String) {
        if let user = Auth.auth().currentUser {
            user.sendEmailVerification { error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                let alert = UIAlertController(title: "確認メールを送信しました．", message: "メールを確認してください．", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .default) { _ in
                    self.navigationController?.popViewController(animated: true)
                }
                alert.addAction(defaultAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func uploadUserData(name: String, email: String, imageURL: String) {
        self.db.collection("users").document(name).setData([
            "name": name,
            "email": email,
            "imageUrl": imageURL
        ]) { error in
            if let error = error {
                print("ドキュメントの書き込みに失敗しました:", error)
            } else {
                print("ドキュメントの書き込みに成功しました")
            }
        }
        
        let user = ["displayName": name, "email": email, "imageURL": imageURL]
        saveData.set(user, forKey: "user")
    }
}
