//
//  UIImage+Extension.swift
//  TryWeatherAppV2
//
//  Created by Алина on 14.05.2024.
//

import Foundation
import UIKit

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
