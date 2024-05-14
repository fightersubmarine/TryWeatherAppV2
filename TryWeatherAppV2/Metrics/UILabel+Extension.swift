//
//  UILabel+Extension.swift
//  TryWeatherAppV2
//
//  Created by Алина on 08.05.2024.
//

import UIKit

typealias labelForeCell = UILabel

private extension CGFloat {
    static let cornerRadius = 8.0
    static let borderWidth = 2.0
    static let fontSize = 25
    static let fontSizeLabelCell = 20
}

extension UILabel {
    static func customLabel(text: String) -> UILabel {
        let label = UILabel()
        label.backgroundColor = .clear
        label.text = text
        label.layer.borderColor = UIColor.borderColor.cgColor
        label.layer.borderWidth = CGFloat.borderWidth
        label.layer.cornerRadius = CGFloat.cornerRadius
        label.font = UIFont.systemFont(ofSize: CGFloat(CGFloat.fontSize))
        label.textAlignment = .center
        label.textColor = .black
        return label
    }
}

extension labelForeCell {
    static func customLabelForCell(text: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: CGFloat(CGFloat.fontSizeLabelCell))
        label.backgroundColor = .clear
        label.text = text
        label.textAlignment = .center
        label.textColor = .black
        return label
    }
}
