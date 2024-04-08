//
//  MessageTableViewCell.swift
//  fireChat
//
//  Created by Alijon Jumayev on 4/8/24.
//

import UIKit
import FirebaseAuth

class MessageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var messageBubble: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var leftImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        messageBubble.layer.cornerRadius            = messageBubble.frame.size.height / 5
        messageBubble.layer.shadowColor             = UIColor.white.cgColor
        messageBubble.layer.shadowOffset            = CGSize(width: 0, height: 4)
        messageBubble.layer.shadowOpacity           = 0.5
        messageBubble.layer.shadowRadius            = 3.0
        
    }
    
    func configure(message: Message) {
        if Auth.auth().currentUser?.email == message.sender {
            leftImage.isHidden = true
            rightImage.isHidden = false
        } else {
            leftImage.isHidden = false
            rightImage.isHidden = true
        }
        label.text = message.message
    }

}
