//
//  ViewController.swift
//  Homeworks-6
//
//  Created by Yunus Emre ÖZŞAHİN on 27.03.2024.
//

import UIKit

class SenderVC: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    var messageClosure: ((String?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    @IBAction func enterButton(_ sender: UIButton) {
        guard let text = nameTextField.text else { return }
        
        let listenerVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ListenerVC") as! ListenerVC
        listenerVC.message = text
        present(listenerVC, animated: true)
        nameTextField.text = ""
    }
}
