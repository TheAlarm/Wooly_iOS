//
//  CreateAlarmVC.swift
//  Wooly
//
//  Created by 이예슬 on 2021/07/28.
//

import UIKit

class CreateAlarmVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var pickerBackgroundView: UIView!
    @IBOutlet weak var pickerDashedView: UIView!
    @IBOutlet weak var purpleRoundView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var nextAlarmMessageView: UIView!
    @IBOutlet weak var nextAlarmMessageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStyle()
        setPicker()

    }
    func setStyle(){
        titleLabel.font = UIFont.notoSans(size: 22, family: .Bold)
        titleLabel.textColor = .gray1
        
        subtitleLabel.font = UIFont.notoSans(size: 16, family: .Light)
        subtitleLabel.textColor = .gray3
        
        pickerBackgroundView.layer.cornerRadius = 15
        pickerBackgroundView.dropShadow(color: UIColor(red: 0.19, green: 0.25, blue: 0.29, alpha: 0.1), offSet: CGSize(width: 0, height: 0), opacity: 1, radius: 15)
        
        pickerDashedView.setRoundedDashedBorder(strokeColor: UIColor.mainPur.cgColor, fillColor: UIColor.clear.cgColor, cornerRadius: 15, lineDashPattern: [8,8], lineWidth: 1, lineCap: .round)
        
        purpleRoundView.backgroundColor = .mainPur
        purpleRoundView.layer.cornerRadius = 50
        purpleRoundView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        
        nextAlarmMessageView.layer.cornerRadius = 5
        nextAlarmMessageView.backgroundColor = .white.withAlphaComponent(0.15)
        nextAlarmMessageLabel.font = .notoSans(size: 12, family: .Bold)
        nextAlarmMessageLabel.textColor = .white
    }
    func setPicker(){
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.calendar = Calendar.current
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.tintColor = .mainPur
//       datePicker.subviews[0].subviews[1].backgroundColor = .clear
//        datePicker.subviews[0].subviews[1].layer.borderColor = UIColor.mainPur.cgColor
//        datePicker.subviews[0].subviews[1].layer.borderWidth = 1
    
        }
}
