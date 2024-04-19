//
//  StatusViewController.swift
//  BipClone
//
//  Created by Yunus Emre ÖZŞAHİN on 19.04.2024.
//

import UIKit

class StatusViewController: UIViewController {

    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var statusView: StatusView!
    @IBOutlet weak var headerView: HeaderView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let model = HeaderModel(header: "Durum")
        headerView.setup(model: model)
        let model2 = MessageModel(sender: "Durumum", message: "Durum Güncellemesi ekle",senderImageName: "person.fill.badge.plus")
        statusView.setup(model: model2)
    }
    

  

}
