import UIKit
import FirebaseAuth
import FirebaseFirestore

class MessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let db = Firestore.firestore()
    private var messageList = [Message]()
    private let refreshControl = UIRefreshControl() // リフレッシュコントロールを追加
    
    @IBOutlet var messageTextView: UITextView!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // リフレッシュコントロールの設定
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshMessages), for: .valueChanged)
        
        fetchMessage()
    }
    
    // リフレッシュアクション
    @objc func refreshMessages() {
        fetchMessage()
    }
    
    func fetchMessage() {
        // 送信者のidを取得
        guard let userId = Auth.auth().currentUser?.displayName else {
            // displayNameが取得できない場合の処理
            return
        }
        // Firestoreクエリにフィルタを追加
        db.collection("messages").whereField("userId", isEqualTo: userId).getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                self.messageList.removeAll()

                for document in querySnapshot!.documents {
                    let data = document.data()
                    do {
                        guard let idString = data["id"] as? String else {
                            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "id が String 型ではありません"])
                        }
                        
                        guard let id = UUID(uuidString: idString) else {
                            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "UUID の生成に失敗しました"])
                        }
                        
                        guard let text = data["text"] as? String else {
                            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "text が String 型ではありません"])
                        }
                        
                        guard let timestamp = data["createdAt"] as? Timestamp else {
                            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "createdAt が Timestamp 型ではありません"])
                        }
                        
                        let createdAt = timestamp.dateValue()
                        
                        self.messageList.append(Message(id: id, text: text, userId: userId, createdAt: createdAt))
                        
                    } catch let error as NSError {
                        print("Error processing document: \(error.localizedDescription)")
                    }
                }
                
                if self.messageList.count > 0 {
                    self.messageList.sort {
                        $0.getCreatedAt() < $1.getCreatedAt()
                    }
                }
                self.tableView.reloadData()
                self.refreshControl.endRefreshing() // リフレッシュを終了
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = messageList[indexPath.row].getText()
        return cell
    }
    
    @IBAction func sendMessage() {
        Task {
            do {
                try await uploadMessage(text: messageTextView.text)
                fetchMessage() // メッセージ送信後にメッセージを再取得
            } catch {
                print(error)
            }
        }
    }
    
    /**
     メッセージデータの保存
     */
    func uploadMessage(text: String) async throws {
        // メッセージID生成
        let id = UUID()
        // 送信者のidを取得
        guard let userId = Auth.auth().currentUser?.displayName else {
            // displayNameが取得できない場合の処理
            return
        }
        // 現在時刻を取得
        let currentDate = Date()
        
        // ユーザー情報の保存
        self.db.collection("messages").document(id.uuidString).setData([
            "id": id.uuidString,
            "text": text,
            "userId": userId,
            "createdAt": currentDate,
        ]) { error in
            if let error = error {
                print("ドキュメントの書き込みに失敗しました:", error)
            } else {
                print("ドキュメントの書き込みに成功しました")
            }
        }
        // 入力されたテキストをクリア
        messageTextView.text = ""
    }
}
