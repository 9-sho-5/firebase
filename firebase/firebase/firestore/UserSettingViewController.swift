import UIKit
import FirebaseStorage

class UserSettingViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var imageSelectButton: UIButton!
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userInfoTableView: UITableView!
    
    let userInfoTitle = ["DisplayName", "E-mail", "Bio"]
    
    private var saveData: UserDefaults = UserDefaults.standard
    let storage = Storage.storage(url:"gs://fir-app-859f2.appspot.com")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userInfoTableView.delegate = self
        userInfoTableView.dataSource = self
        
        userImageView.layer.cornerRadius = 20
        imageSelectButton.layer.cornerRadius = 20
        loadUserInfo()
    }
    
    @IBAction func openAlbum() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            present(picker, animated: true)
        }
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        userImageView.image = info[.editedImage] as? UIImage
        dismiss(animated: true)
    }
    
    func uploadImage(userName: String) async -> String {
        var imageURL = ""
        
        let storageRef = self.storage.reference().child("img_\(userName)")
        
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        
        guard let userImage = self.userImageView.image,
              let userImageData = userImage.jpegData(compressionQuality: 1.0) else {
            return ""
        }
        
        let uploadTask = storageRef.putData(userImageData, metadata: meta) { (metadata, error) in
            guard let metadata = metadata else {
                print(error?.localizedDescription)
                return
            }
            storageRef.downloadURL { (url, error) in
                guard let url = url else {
                    print(error?.localizedDescription)
                    return
                }
                imageURL = url.absoluteString
            }
        }
        
        uploadTask.observe(.success) { snapshot in
            print("upload succeeded")
        }
        
        return imageURL
    }
    
    func loadUserInfo() {
        guard let user = saveData.object(forKey: "user") as? [String: String] else { return }
        
        var userImage: UIImage!
        if user["imageURL"]?.isEmpty ?? true {
            userImage = UIImage(systemName: "person.circle.fill")
        } else {
            if let url = URL(string: user["imageURL"]!), let data = try? Data(contentsOf: url) {
                userImage = UIImage(data: data)
            }
        }
        userImageView.image = userImage
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userInfoTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        var content = cell?.defaultContentConfiguration()
        content?.text = userInfoTitle[indexPath.row]
        cell?.contentConfiguration = content
        return cell!
    }
}
