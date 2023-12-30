//
//  UIButton.swift
//  firebase
//
//  Created by ほしょ on 2023/12/29.
//

import Foundation
import UIKit

extension UIButton {
    public func setBorder(color: CGColor, width: CGFloat) {
        self.layer.borderWidth = width // 枠線の幅
        self.layer.borderColor = color // 枠線の色
    }
}
