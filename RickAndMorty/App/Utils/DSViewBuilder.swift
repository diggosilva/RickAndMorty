//
//  DSViewBuilder.swift
//  RickAndMorty
//
//  Created by Diggo Silva on 09/09/25.
//

import UIKit

final class DSViewBuilder {
    
    static func buildLabel(text: String = "", textColor: UIColor = .label, textAlignment: NSTextAlignment = .left, font: UIFont = .preferredFont(forTextStyle: .extraLargeTitle), numberOfLines: Int = 1) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.textColor = textColor
        label.textAlignment = textAlignment
        label.font = font
        label.numberOfLines = numberOfLines
        return label
    }
    
    static func buildDivider() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray4
        return view
    }
}
