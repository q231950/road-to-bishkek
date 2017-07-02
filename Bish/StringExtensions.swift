//
//  StringExtensions.swift
//  Bish
//
//  Created by Martin Kim Dung-Pham on 31.05.17.
//  Copyright © 2017 elbedev.com. All rights reserved.
//

import UIKit

enum FontSize: CGFloat {
    case big = 60
    case small = 32
}

enum FontName: String {
    case bold = "Menlo-Bold"
    case regular = "Menlo"
}

extension String {
    
    func attributedBigText() -> NSAttributedString {
        return NSAttributedString(string: self, attributes: bigTextAttributes())
    }
    
    func attributedSmallText() -> NSAttributedString {
        return NSAttributedString(string: self, attributes: smallTextAttributes())
    }
    
    private func bigTextAttributes() -> [NSAttributedStringKey: Any] {
        return  [NSAttributedStringKey.font: UIFont.init(name: FontName.bold.rawValue, size: FontSize.big.rawValue)!,
                 NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    
    private func smallTextAttributes() -> [NSAttributedStringKey: Any] {
        return [NSAttributedStringKey.font: UIFont.init(name: FontName.regular.rawValue, size: FontSize.small.rawValue)!,
                NSAttributedStringKey.foregroundColor: UIColor.white]
    }
}
