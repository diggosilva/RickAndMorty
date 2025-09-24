//
//  DSViewBuilder.swift
//  RickAndMorty
//
//  Created by Diggo Silva on 09/09/25.
//

import UIKit

final class DSViewBuilder {
    
    static func buildLabel(text: String = "", textColor: UIColor = .label, textAlignment: NSTextAlignment = .left, font: UIFont = .preferredFont(forTextStyle: .extraLargeTitle), numberOfLines: Int = 1, minimumScaleFactor: CGFloat = 1) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.textColor = textColor
        label.textAlignment = textAlignment
        label.font = font
        label.numberOfLines = numberOfLines
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = minimumScaleFactor
        return label
    }
    
    static func buildDivider() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray4
        return view
    }
    
    static func buildContainerViewToLocationCell() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }
    
    static func buildSpinner() -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = .label
        return spinner
    }
}
