//
//  UIFont+Extension.swift
//  Ithaca map
//
//  Created by Qiandao Liu on 11/17/23.
//

import Foundation
import UIKit

extension UIFont {

    var rounded: UIFont {
        guard let desc = self.fontDescriptor.withDesign(.rounded) else { return self }
        return UIFont(descriptor: desc, size: self.pointSize)
    }

}
