//
//  CreateAlarmVC.swift
//  Wooly
//
//  Created by 이예슬 on 2021/07/28.
//

import SnapKit
import Then
import UIKit

let screenBounds = UIScreen.main.bounds
let defaultWidth = 375

class CreateAlarmVC: UIViewController {
    
    let weekdayList = ["일","월","화","수","목","금","토"]
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout().then {
            $0.itemSize = CGSize(width: 33, height: 33)
        $0.sectionInset = UIEdgeInsets(top: 22*screenBounds.width/CGFloat(defaultWidth), left: 21*screenBounds.width/CGFloat(defaultWidth), bottom: 21*screenBounds.width/CGFloat(defaultWidth), right: 21*screenBounds.width/CGFloat(defaultWidth))
        $0.minimumInteritemSpacing = 9
    }
    //MARK: - UIComponent
    let line1 = GrayLine()
    let line2 = GrayLine()
    let line3 = GrayLine()
    let line4 = GrayLine()
    let alarmMissionTitleLabel = TableTitleLabel(text: "알람 미션")
    let alarmMissionOptionLabel = UILabel().then {
        $0.text = "기본"
        $0.frame = CGRect(x: 0, y: 0, width: 24, height: 18)
        $0.font = .notoSans(size: 12, family: .Regular)
        $0.textColor = .gray4
    }
    let alarmMissionButton = UIButton().then{
        $0.setTitle("", for: .normal)
        $0.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
        $0.setImage(UIImage(named:"icon_makealarm_arrow"), for: .normal)
        $0.contentMode = .scaleAspectFill
    }
    let weekdayTitleLabel = TableTitleLabel(text: "요일 선택")
    let bellTypeTitleLabel = TableTitleLabel(text: "타입")
    let bellSettingTitleLabel = TableTitleLabel(text: "벨소리")
    let alarmMemoTitleLabel = TableTitleLabel(text: "알람 메모")
    let weekdayCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout()).then {
        $0.frame = CGRect(x: 0, y: 0, width: 327*Int(screenBounds.width)/defaultWidth, height: 76*Int(screenBounds.width)/defaultWidth)
        $0.backgroundColor = UIColor.init(red: 0.97, green: 0.98, blue: 0.99, alpha: 1)
        $0.makeRounded(cornerRadius: 5)
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
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
        setLayout()
        weekdayCollectionView.delegate = self
        weekdayCollectionView.dataSource = self
        weekdayCollectionView.collectionViewLayout = layout
        weekdayCollectionView.register(WeekdayCVC.self,forCellWithReuseIdentifier: WeekdayCVC.identifier)
        

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
    
    }
    func setLayout(){
        self.scrollView.addSubview(line1)
        self.scrollView.addSubview(line2)
        self.scrollView.addSubview(line3)
        self.scrollView.addSubview(line4)
        self.scrollView.addSubview(alarmMissionTitleLabel)
        self.scrollView.addSubview(alarmMissionOptionLabel)
        self.scrollView.addSubview(alarmMissionButton)
        self.scrollView.addSubview(weekdayTitleLabel)
        self.scrollView.addSubview(bellTypeTitleLabel)
        self.scrollView.addSubview(bellSettingTitleLabel)
        self.scrollView.addSubview(alarmMemoTitleLabel)
        self.scrollView.addSubview(weekdayCollectionView)
        line1.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(alarmMissionTitleLabel.snp.bottom).offset(16)
        }
        alarmMissionTitleLabel.snp.makeConstraints {
            $0.top.equalTo(purpleRoundView.snp.bottom).offset(16)
            $0.leading.equalTo(line1.snp.leading).offset(8)
        }
        
        alarmMissionButton.snp.makeConstraints {
            $0.trailing.equalTo(line1.snp.trailing).offset(-4)
            $0.top.equalTo(purpleRoundView.snp.bottom).offset(21)
            $0.width.equalTo(16)
            $0.height.equalTo(16)
        }
        alarmMissionOptionLabel.snp.makeConstraints {
            $0.centerY.equalTo(alarmMissionButton.snp.centerY)
            $0.trailing.equalTo(alarmMissionButton.snp.leading).offset(-6)
        }
        weekdayTitleLabel.snp.makeConstraints {
            $0.top.equalTo(line1.snp.bottom).offset(16)
            $0.leading.equalTo(line2.snp.leading).offset(8)
        }
        line2.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(weekdayTitleLabel.snp.bottom).offset(155)
        }
        weekdayCollectionView.snp.makeConstraints {
            $0.top.equalTo(weekdayTitleLabel.snp.bottom).offset(14)
            $0.width.equalTo(327)
            $0.height.equalTo(76)
            $0.centerX.equalToSuperview()
            $0.leading.equalTo(line2)
            $0.trailing.equalTo(line2)
        }
    }
}

class GrayLine: UIView {
    override init (frame: CGRect){
        super.init(frame: frame)
        setLayout()
        self.backgroundColor = .lineGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout(){
        self.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.width.equalTo(Int(screenBounds.width)/defaultWidth*327)
        }
    }
}
class TableTitleLabel: UILabel {
    override init (frame: CGRect){
        super.init(frame: frame)
        self.frame = CGRect(x: 0, y: 0, width: 65, height: 24)
        self.font = .notoSans(size: 16, family: .Regular)
        self.baselineAdjustment = .alignBaselines
        self.textColor = .gray1
    }
    
    init (text: String){
        super.init(frame: CGRect.zero)
        self.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CreateAlarmVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weekdayList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeekdayCVC.identifier, for: indexPath) as? WeekdayCVC else { return UICollectionViewCell() }
        cell.setLabel(text: weekdayList[indexPath.item])
//        cell.contentView.backgroundColor = .blue
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 33, height: 33)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 22*screenBounds.width/CGFloat(defaultWidth), left: 21*screenBounds.width/CGFloat(defaultWidth), bottom: 21*screenBounds.width/CGFloat(defaultWidth), right: 21*screenBounds.width/CGFloat(defaultWidth))
//    }
    
    
}

