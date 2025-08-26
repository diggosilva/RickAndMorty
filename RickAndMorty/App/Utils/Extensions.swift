//
//  Extensions.swift
//  RickAndMorty
//
//  Created by Diggo Silva on 23/08/25.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
    
    func applyShadow(view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 5, height: 5)
        view.layer.shadowOpacity = 0.35
        view.layer.shadowRadius = 5.0
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray.cgColor
    }
}

extension UIViewController {
    func showCustomAlert(title: String, message: String, buttonTitle: String, handler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: .default) { _ in
            handler?()
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
