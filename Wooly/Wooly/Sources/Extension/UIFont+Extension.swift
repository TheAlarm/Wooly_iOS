//
//  UIFont+Extension.swift
//  Wooly
//
//  Created by 이예슬 on 2021/04/15.
//

import Foundation
import UIKit

extension UIFont {
    
    enum Family: String{
        case Bold, Regular, Light
    }
    static func notoSans(size: CGFloat = 10, family: Family = .Regular) -> UIFont {
        return UIFont(name:"SpoqaHanSansNeo-\(family)", size: size)!
    }
    
}
