//
//  AlarmCardCVC.swift
//  Wooly
//
//  Created by 이예슬 on 2021/05/16.
//

import UIKit

class AlarmCardCVC: UICollectionViewCell {
    
    var alarmModel = Alarms.shared
    var alarmInfo: Alarm? = nil
    let alarmOnImage = UIImage(named: "iconMainMissionAlarm")
    let promiseOnImage = UIImage(named: "iconMainMissionPromise")
    let alarmOffImage = UIImage(named: "iconMainMissionAlarmOff")
    let promiseOffImage = UIImage(named: "iconMainMissionPromiseOff")

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var ampmLabel: UILabel!
    @IBOutlet weak var onoffSwitch: UISwitch!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var memoLabel: UILabel!
    @IBOutlet weak var cardBotttomView: UIView!
    @IBOutlet weak var weekdayLabel: UILabel!
    @IBOutlet weak var missionImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setStyle()
    }
    func setStyle() {
        cardView.layer.cornerRadius = 15
        cardView.dropShadow(color: UIColor(red: 49/255, green: 64/255, blue: 73/255, alpha: 0.1), offSet: .init(width: 0, height: 0), opacity: 1, radius: 15)
        
        ampmLabel.font = UIFont.spoqaSans(size: 18, family: .Light)
        ampmLabel.textColor = .gray1
        
        timeLabel.font = UIFont.spoqaSans(size: 33, family: .Bold)
        timeLabel.textColor = .gray1
        
        memoLabel.font = UIFont.spoqaSans(size: 12, family: .Regular)
        memoLabel.textColor = .gray1
        
        onoffSwitch.transform = CGAffineTransform.init(scaleX: 0.784, y: 0.784)
        onoffSwitch.onTintColor = .mainPur
        
        cardBotttomView.layer.cornerRadius = 15
        cardBotttomView.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner]
        cardBotttomView.backgroundColor = .paleGrey
        
        weekdayLabel.font = UIFont.spoqaSans(size: 12, family: .Regular)
        weekdayLabel.textColor = .gray1
    }
    func setAlarmCardData() {
        let weekdayString = getWeekdayString()
        weekdayLabel.text = weekdayString
        setTimeLabels()
        setMemoLabel()
        setMissionImage()
        setSwitch()
        setOnOff(enabled: alarmInfo!.enabled)
    }
    func getWeekdayString() -> String {
        let weekdays = ["일","월","화","수","목","금","토"]
        var weekdayString = ""
        for i in 1..<8 {
            if alarmInfo!.repeatWeekdays.contains(i) {
                weekdayString += "\(weekdays[i-1]) "
            }
        }
        return weekdayString
    }
    func setTimeLabels(){
        let ampmFormatter = DateFormatter()
        let timeFormatter = DateFormatter()
        ampmFormatter.dateFormat = "a"
        ampmFormatter.locale = Locale(identifier: "en-US")
        timeFormatter.dateFormat = "hh:mm"
        let ampmString = ampmFormatter.string(from: alarmInfo!.date)
        let timeString = timeFormatter.string(from: alarmInfo!.date)
        ampmLabel.text = ampmString
        timeLabel.text = timeString
    }
    func setMemoLabel(){
        let memoString = alarmInfo!.memo
        memoLabel.text = memoString
    }
    func setMissionImage(){
        let mission = alarmInfo!.mission
        switch mission {
            case .none:
                missionImageView.image = alarmOnImage
            case .promise:
                missionImageView.image = promiseOnImage
        }
    }
    func setSwitch(){
        let enabled = alarmInfo!.enabled
        onoffSwitch.isOn = enabled
    }
    func setOnOff(enabled: Bool){
        if enabled {
            UIView.animate(withDuration: 0.15){
                self.cardView.backgroundColor = .white
                self.cardBotttomView.backgroundColor = .paleGrey
            }
            UIView.transition(with: self.missionImageView, duration: 0.15, options: .transitionCrossDissolve, animations: {
                switch self.alarmInfo!.mission {
                    case .none:
                        self.missionImageView.image = self.alarmOnImage
                    case .promise:
                        self.missionImageView.image = self.promiseOnImage
                }
            })
        }
        else {
            UIView.animate(withDuration: 0.15){
                self.cardView.backgroundColor = UIColor(red: 224/255, green: 228/255, blue: 236/255, alpha: 1)
                self.cardBotttomView.backgroundColor = UIColor(red: 0.87, green: 0.88, blue: 0.92, alpha: 1)
            }
            UIView.transition(with: self.missionImageView, duration: 0.15, options: .transitionCrossDissolve, animations: {
                switch self.alarmInfo!.mission {
                    case .none:
                        self.missionImageView.image = self.alarmOffImage
                    case .promise:
                        self.missionImageView.image = self.promiseOffImage
                }
            })
        }
    }
    @IBAction func alarmSwitchDidTap(_ sender: UISwitch) {
        alarmInfo!.enabled = sender.isOn
        
        setOnOff(enabled: sender.isOn)
        
        for i in 0..<alarmModel.count {
            if Alarms.shared.alarms[i].uuid == alarmInfo!.uuid {
                Alarms.shared.alarms[i] = alarmInfo!
                break
            }
        }
//        alarmModel.updateAlarmUserDefaults()
    }
}
