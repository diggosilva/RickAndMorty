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
