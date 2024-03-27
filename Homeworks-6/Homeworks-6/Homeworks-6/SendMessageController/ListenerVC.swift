//
//  ListenerVC.swift
//  Homeworks-6
//
//  Created by Yunus Emre ÖZŞAHİN on 27.03.2024.
//

import UIKit

class ListenerVC: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    var message: String?
    override func viewDidLoad() {
            super.viewDidLoad()
        nameLabel.text = "Hoşgeldin \(message ?? "")"
                
            }
        }

