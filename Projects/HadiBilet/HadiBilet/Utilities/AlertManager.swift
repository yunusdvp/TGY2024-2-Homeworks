//
//  AlertManager.swift
//  HadiBilet
//
//  Created by Yunus Emre ÖZŞAHİN on 29.04.2024.
//

import UIKit

class AlertManager {
    static let shared = AlertManager()

    private init() {}

    func showAlert(title: String, message: String, on viewController: UIViewController, actions: [UIAlertAction] = [UIAlertAction(title: "OK", style: .default, handler: nil)], style: UIAlertController.Style = .alert) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: style)
            actions.forEach { alert.addAction($0) }
            DispatchQueue.main.async {
                viewController.present(alert, animated: true, completion: nil)
            }
        }
    
    func showActionSheet(title: String, message: String, on viewController: UIViewController, actions: [UIAlertAction]) {
        let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        actions.forEach { actionSheet.addAction($0) }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        DispatchQueue.main.async {
            viewController.present(actionSheet, animated: true, completion: nil)
        }
    }
}

