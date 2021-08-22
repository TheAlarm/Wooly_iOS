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
    override var isSelected: Bool {
        willSet {
            if newValue {
                weekdayCircleView.setBorder(borderColor: .mainColor, borderWidth: 1)
                weekdayCircleView.backgroundColor = .white
                weekdayLabel.textColor = .mainColor
            }
            else {
                weekdayCircleView.setBorder(borderColor: .clear, borderWidth: 0)
                weekdayCircleView.backgroundColor = .clear
                weekdayLabel.textColor = .textGrayblue
            }
        }
    }
    let weekdayCircleView = UIView().then {
        $0.frame = CGRect(x: 0, y: 0, width: 33, height: 33)
        $0.layer.cornerRadius = 16.5
        
    }
    let weekdayLabel = UILabel().then {
        $0.textColor = .textGrayblue
        $0.font = .spoqaSans(size: 16, family: .Regular)
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
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(1)
            $0.width.equalTo(33)
            $0.height.equalTo(33)
        }
    }
    
}
