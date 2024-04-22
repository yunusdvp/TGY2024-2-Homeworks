//
//  MessagesViewController.swift
//  BipClone
//
//  Created by Yunus Emre ÖZŞAHİN on 19.04.2024.
//

import UIKit

class MessagesViewController: UIViewController {

    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var headerView: HeaderView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var messages = [MessageModel]()
    
    override func viewDidLoad() {
        let model = HeaderModel(header: "Mesajlar")
        headerView.setup(model: model)
        messages.append(MessageModel(sender: "Geleceği Yazanlar", message: "Merhabalar", senderImageName: "image3"))
        messages.append(MessageModel(sender: "905734380000", message: "İyi Akşamlar", senderImageName: "image4"))
        messages.append(MessageModel(sender: "905734387033", message: "Görüşmek üzere", senderImageName: "image5"))
        super.viewDidLoad()
        //let model = HeaderModel(header: "Mesajlar")
       // headerView.setup(model: model)
        messagesTableView.register(UINib(nibName: "MessageViewCell", bundle: nil), forCellReuseIdentifier: "messageCell")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func segmentedAction(_ sender: UISegmentedControl) {
    }
    
}
extension MessagesViewController: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageViewCell
        cell.setupCell(model: messages[indexPath.row])
    
        return cell
    }
    
    
}
