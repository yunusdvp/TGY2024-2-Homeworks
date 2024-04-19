//
//  MessagesViewCell.swift
//  BipClone
//
//  Created by Yunus Emre ÖZŞAHİN on 19.04.2024.
//

import UIKit

class MessageViewCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var senderNameLabel: UILabel!
    @IBOutlet weak var messageImage: UIImageView!
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupCell(model: MessageModel) {
        messageLabel.text = model.message
        print(model)
        messageImage.image = UIImage(named: model.senderImageName ?? "default")
        senderNameLabel.text = model.sender
    }

}
