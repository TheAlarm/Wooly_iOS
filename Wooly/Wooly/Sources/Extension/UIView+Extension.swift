//
//  UIView+Extension.swift
//  Wooly
//
//  Created by 이예슬 on 2021/04/15.
//

import UIKit

// UIView Extension
extension UIView {
    
    /// Set Rounded View
    func makeRounded(cornerRadius : CGFloat?){
        
        // UIView 의 모서리가 둥근 정도를 설정
        if let cornerRadius_ = cornerRadius {
            self.layer.cornerRadius = cornerRadius_
        }  else {
            // cornerRadius 가 nil 일 경우의 default
            self.layer.cornerRadius = self.layer.frame.height / 2
        }
        
        self.layer.masksToBounds = true
    }
    
    /// Set UIView's Shadow
    func dropShadow(color: UIColor, offSet: CGSize, opacity: Float, radius: CGFloat) {
        
        // 그림자 색상 설정
        layer.shadowColor = color.cgColor
        // 그림자 크기 설정
        layer.shadowOffset = offSet
        // 그림자 투명도 설정
        layer.shadowOpacity = opacity
        // 그림자의 blur 설정
        layer.shadowRadius = radius
        // 구글링 해보세요!
        layer.masksToBounds = false
        
        // 그림자 캐시
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    /// Set UIView's Border
    func setBorder(borderColor : UIColor?, borderWidth : CGFloat?) {
        
        // UIView 의 테두리 색상 설정
        if let borderColor_ = borderColor {
            self.layer.borderColor = borderColor_.cgColor
        } else {
            // borderColor 변수가 nil 일 경우의 default
            self.layer.borderColor = UIColor(red: 205/255, green: 209/255, blue: 208/255, alpha: 1.0).cgColor
        }
        
        // UIView 의 테두리 두께 설정
        if let borderWidth_ = borderWidth {
            self.layer.borderWidth = borderWidth_
        } else {
            // borderWidth 변수가 nil 일 경우의 default
            self.layer.borderWidth = 1.0
        }
    }
    
 /**
     set rounded border with dashed line
    - parameters:
        - strokeColor: 테두리색
        - fillColor: 채우기색
        - cornerRadius: radius for corner sections
        - lineDashPattern: [lineLength, lineGap]
        - lineWidth: dashline 두께
        - lineCap: dashline 끝 모양
     */
    func setRoundedDashedBorder(strokeColor: CGColor,fillColor:CGColor?, cornerRadius: CGFloat,lineDashPattern: [NSNumber],lineWidth: CGFloat, lineCap: CAShapeLayerLineCap){
        let dashedLayer = CAShapeLayer()
        dashedLayer.strokeColor = strokeColor
        dashedLayer.fillColor = fillColor
        dashedLayer.lineDashPattern = lineDashPattern
        dashedLayer.lineWidth = lineWidth
        dashedLayer.lineCap = lineCap
        dashedLayer.frame = self.bounds
        let path = CGMutablePath()
        path.addRoundedRect(in: self.bounds, cornerWidth: cornerRadius, cornerHeight: cornerRadius)
        dashedLayer.path = path
        self.layer.addSublayer(dashedLayer)
        
    }
}
