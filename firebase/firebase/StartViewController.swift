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
            do {
                try auth.signOut()
            } catch let error {
                print(error.localizedDescription)
            }
        } else {
            handle = auth.addStateDidChangeListener { auth, user in
                if user != nil {
                    self.performSegue(withIdentifier: "toHome", sender: self)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toHome" {
            // ここで遷移先のViewControllerにデータを渡すなどの処理を行う
            
        }
    }
}
