//
//  StatusViewController.swift
//  BipClone
//
//  Created by Yunus Emre ÖZŞAHİN on 19.04.2024.
//

import UIKit

class StatusViewController: UIViewController {

    @IBOutlet weak var headerView: HeaderView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let model = HeaderModel(header: "Durum")
        headerView.setup(model: model)
    }
    

  

}
