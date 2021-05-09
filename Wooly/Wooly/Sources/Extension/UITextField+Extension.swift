//
//  UITextField+Extension.swift
//  Wooly
//
//  Created by 이예슬 on 2021/04/15.
//

import UIKit

extension UITextField{
    
    /// 텍스트필드 왼쪽 여백 뷰를 생성합니다.
    func addLeftPadding(left: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: left, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
    
    /// 텍스트필드의 글자수를 제한합니다. 중간에 추가되는 글자를 막기 위해서 UITextFieldDelegate를 채택해 추가 작업이 필요합니다.
    /// - parameter maxCount: 최대 글자 수
    func limitTextCount(maxCount: Int){
        if let text = self.text{
            if text.count > maxCount{
                let endIndex = text.index(text.startIndex,offsetBy: maxCount)
                let newText = text[text.startIndex..<endIndex]
                self.text = String(newText)
            }
        }
        
    }
}
