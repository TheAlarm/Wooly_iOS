//
//  UITextField+Extension.swift
//  Wooly
//
//  Created by 이예슬 on 2021/04/15.
//

import UIKit

extension UITextField{
    func addLeftPadding(left: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: left, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
}
