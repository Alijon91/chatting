//
//  ChatViewController.swift
//  fireChat
//
//  Created by Alijon Jumayev on 4/8/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController {
    
    let database = Firestore.firestore()
    var messages: [Message] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        let backgroundImage = UIImage(named: "9")
        let imageView = UIImageView(image: backgroundImage)
        tableView.backgroundView = imageView
        return tableView
    }()
    
    private let sendButton: UIButton = {
        let btn = UIButton()
        let image = UIImage(systemName: "paperplane.fill")
        btn.setBackgroundImage(image, for: .normal)
        btn.tintColor = .systemPink
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }()
    
    private let textfield: UITextField = {
        let textField = UITextField()
        textField.borderStyle       = .roundedRect
        textField.textColor         = .black
        textField.backgroundColor   = .white
        textField.font              = UIFont.systemFont(ofSize: 20)
        textField.textAlignment     = .left
        let attributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor: UIColor.systemGray,
                    .font: UIFont.systemFont(ofSize: 18)
                ]
        textField.attributedPlaceholder = NSAttributedString(string: "Write a messages...", attributes: attributes)
        return textField
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadMessageFromFB()
        
        tableView.register(UINib(nibName: "MessageTableViewCell", bundle: nil), forCellReuseIdentifier: "messageCell")
        tableView.dataSource = self
        
        navigationItem.setHidesBackButton(true, animated: true)
        setupNavImage()
        
        tableView.separatorStyle = .none
        
        navigationItem.title = "Chatting"
      
        [textfield,sendButton,tableView] .forEach {view.addSubview($0)}
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(LoginOutButton))
        
        sendButton.addTarget(self, action: #selector(setSendButton), for: .touchUpInside)
        
        

 //MARK: - textfield layout
        
        textfield.anchor(top: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: view.leadingAnchor, trailing: sendButton.leadingAnchor,padding: .init(top: 0, left: 10, bottom: 20, right: 10),size: .init(width: 0, height: 50))
 //MARK: - send button layout
        
        sendButton.anchor(top: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 20, right: 10),size: .init(width: 50, height: 50))
        
 //MARK: - tableView layout
        
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: textfield.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor,padding: .init(top: 0, left: 0, bottom: 10, right: 0))
    }
    @objc private func setSendButton() {
        let messagebody = textfield.text
        let sender = Auth.auth().currentUser?.email
        
        if let messagebody = messagebody, let sender = sender {
            database.collection("message").addDocument(data: ["body" : messagebody, "sender": sender, "date": Date().timeIntervalSince1970]) { error in
                self.messages = []
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    self.textfield.text = ""
                    print("SAVED!!!")
                }
                
            }
        }
        
    }
    private func setupNavImage() {
        let imageView = UIImageView(image: UIImage(systemName: "text.bubble.fill"))
        
        imageView.contentMode = .scaleAspectFit
        imageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 113).isActive = true
        self.navigationItem.titleView = imageView
    }
    
    func loadMessageFromFB() {
        database.collection("message").order(by: "date").addSnapshotListener {snapshot, error in
            if error != nil {
                print("Error occured when receiving data from FB \(error?.localizedDescription)")
            } else {
                if let snapshotDoc = snapshot?.documents {
                    snapshotDoc.forEach {doc in
                        let data = doc.data()
                        
                        if let sender = data["sender"] as? String, let body = data["body"] as? String {
                            let message = Message(sender: sender, message: body)
                            self.messages.append(message)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc func LoginOutButton() {
        
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    

}

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageTableViewCell
        cell.configure(message: messages[indexPath.row])
        return cell
    }
    
    
}
