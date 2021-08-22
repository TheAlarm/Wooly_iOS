//
//  AlarmCardCVC.swift
//  Wooly
//
//  Created by 이예슬 on 2021/05/16.
//

import UIKit

class AlarmCardCVC: UICollectionViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var ampmLabel: UILabel!
    @IBOutlet weak var onoffSwitch: UISwitch!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var cardBotttomView: UIView!
    @IBOutlet weak var weekdayLabel: UILabel!
    @IBOutlet weak var missionImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        cardView.layer.cornerRadius = 15
        cardView.dropShadow(color: UIColor(red: 49/255, green: 64/255, blue: 73/255, alpha: 0.1), offSet: .init(width: 0, height: 0), opacity: 1, radius: 15)
        
        ampmLabel.font = UIFont.spoqaSans(size: 18, family: .Light)
        ampmLabel.textColor = .gray1
        
        timeLabel.font = UIFont.spoqaSans(size: 33, family: .Bold)
        timeLabel.textColor = .gray1
        
        descLabel.font = UIFont.spoqaSans(size: 12, family: .Regular)
        descLabel.textColor = .gray1
        
        onoffSwitch.transform = CGAffineTransform.init(scaleX: 0.784, y: 0.784)
        onoffSwitch.onTintColor = .mainPur
        
        cardBotttomView.layer.cornerRadius = 15
        cardBotttomView.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner]
        cardBotttomView.backgroundColor = .paleGrey
        
        weekdayLabel.font = UIFont.spoqaSans(size: 12, family: .Regular)
        weekdayLabel.textColor = .gray1
    }

}
