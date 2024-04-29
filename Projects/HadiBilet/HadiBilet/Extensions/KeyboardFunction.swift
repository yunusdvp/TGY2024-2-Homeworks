//
//  addDismissKeyboard.swift
//  HadiBilet
//
//  Created by Yunus Emre ÖZŞAHİN on 29.04.2024.
//

import UIKit
extension UIViewController {
    func addDismissKeyboardTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissInputViews))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissInputViews() {
        view.endEditing(true)
    }
    func addKeyboardObservers() {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
        
        func removeKeyboardObservers() {
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        }

        @objc private func keyboardWillShow(notification: NSNotification) {
            guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
            if view.frame.origin.y == 0 {
                view.frame.origin.y -= keyboardSize.height / 2
            }
        }

        @objc private func keyboardWillHide(notification: NSNotification) {
            if view.frame.origin.y != 0 {
                view.frame.origin.y = 0
            }
        }
    
}
