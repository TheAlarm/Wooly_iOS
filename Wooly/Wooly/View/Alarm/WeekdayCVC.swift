//
//  WeekdayTVC.swift
//  Wooly
//
//  Created by 이예슬 on 2021/07/29.
//

import SnapKit
import Then
import UIKit

class WeekdayCVC: UICollectionViewCell {
    static let identifier = "WeekdayCVC"
    
    let weekdayCircleView = UIView().then {
        $0.frame = CGRect(x: 0, y: 0, width: 33, height: 33)
        $0.layer.cornerRadius = 16.5
        $0.setBorder(borderColor: .mainColor, borderWidth: 1)
    }
    let weekdayLabel = UILabel().then {
        $0.textColor = .textGrayblue
        $0.font = .notoSans(size: 16, family: .Regular)
        $0.textAlignment = .center
    }
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.contentView.addSubview(weekdayCircleView)
        self.weekdayCircleView.addSubview(weekdayLabel)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func setLabel(text: String){
        weekdayLabel.text = text
    }
    
    func setLayout(){
        weekdayCircleView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(33)
            $0.height.equalTo(33)
        }
        weekdayLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(33)
            $0.height.equalTo(33)
        }
    }
    
}
