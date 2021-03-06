//
//  CreateAlarmVC.swift
//  Wooly
//
//  Created by 이예슬 on 2021/07/28.
//

import SnapKit
import Then
import UIKit
import AudioToolbox

let screenBounds = UIScreen.main.bounds
let defaultWidth = 375

class AddAlarmVC: UIViewController {
    var lastScrollViewOffset = CGPoint.zero
    var feedbackGenerator: UISelectionFeedbackGenerator?
    let weekdayList = ["일","월","화","수","목","금","토"]
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout().then {
            $0.itemSize = CGSize(width: 33, height: 33)
        $0.sectionInset = UIEdgeInsets(top: 22*screenBounds.width/CGFloat(defaultWidth), left: 21*screenBounds.width/CGFloat(defaultWidth), bottom: 21*screenBounds.width/CGFloat(defaultWidth), right: 21*screenBounds.width/CGFloat(defaultWidth))
        $0.minimumInteritemSpacing = 9
    }
    let alarmModel = Alarms.shared
    var alarm = Alarm() {
        didSet {
            setAlarmOptionsView()
        }
    }
    var existingAlarm: Alarm?
    //MARK: - UIComponent
    let weekdayLine = GrayLine()
    let bellTypeLine = GrayLine()
    let bellSettingLine = GrayLine()
    let alarmMemoLine = GrayLine()
    let alarmMissionTitleLabel = TableTitleLabel(text: "알람 미션")
    let weekdayTitleLabel = TableTitleLabel(text: "요일 선택")
    let bellTypeTitleLabel = TableTitleLabel(text: "타입")
    let bellSettingTitleLabel = TableTitleLabel(text: "벨소리")
    let alarmMemoTitleLabel = TableTitleLabel(text: "알람 메모")
    let alarmMissionOptionLabel = UILabel().then {
        $0.text = "기본"
        $0.frame = CGRect(x: 0, y: 0, width: 24, height: 18)
        $0.font = .spoqaSans(size: 12, family: .Regular)
        $0.textColor = .gray4
    }
    let alarmMissionButton = UIButton().then{
        $0.setTitle("", for: .normal)
        $0.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
        $0.setImage(UIImage(named:"icon_makealarm_arrow"), for: .normal)
        $0.contentMode = .scaleAspectFill
        $0.addTarget(self, action: #selector(missionButtonDidTap(sender:)), for: .touchUpInside)
    }

    let weekdayCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout()).then {
        $0.frame = CGRect(x: 0, y: 0, width: 327*Int(screenBounds.width)/defaultWidth, height: 76*Int(screenBounds.width)/defaultWidth)
        $0.backgroundColor = UIColor.greyBg
        $0.makeRounded(cornerRadius: 5)
        $0.allowsMultipleSelection = true
    }
    let holidayExceptionView = UIView().then {
        $0.frame = CGRect(x: 0, y: 0, width: 159*Int(screenBounds.width)/defaultWidth, height: 40*Int(screenBounds.width)/defaultWidth)
        $0.backgroundColor = UIColor.greyBg
        $0.isHidden = true
    }
    let holidayExceptionLabel = UILabel().then {
        $0.frame = CGRect(x: 0, y: 0, width: 70, height: 21)
        $0.text = "공휴일 제외"
        $0.font = .spoqaSans(size: 14, family: .Regular)
        $0.textColor = UIColor(white: 0.74, alpha: 1)
    }
    let holidayExceptionCheckImageView = UIImageView().then {
        $0.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
        $0.image = UIImage(named:"icon_makealarm_check_gray")
        
    }
    let specificExceptionView = UIView().then {
        $0.frame = CGRect(x: 0, y: 0, width: 159*Int(screenBounds.width)/defaultWidth, height: 40*Int(screenBounds.width)/defaultWidth)
        $0.backgroundColor = UIColor.greyBg
        $0.isHidden = true
    }
    let specificExceptionLabel = UILabel().then {
        $0.frame = CGRect(x: 0, y: 0, width: 70, height: 21)
        $0.text = "특정일 제외"
        $0.font = .spoqaSans(size: 14, family: .Regular)
        $0.textColor = UIColor(white: 0.74, alpha: 1)
    }
    let specificExceptionCheckImageView = UIImageView().then {
        $0.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
        $0.image = UIImage(named:"icon_makealarm_check_gray")
        
    }
    let bellTypeSoundButton = UIButton().then {
        $0.frame = CGRect.init()
        $0.setImage(UIImage(named:"btn_makealarm_sound_off") ?? UIImage(), for: .normal)
        $0.setImage(UIImage(named:"btn_makealarm_sound_on") ?? UIImage(), for: .selected)
//        $0.isSelected = alarm.volume > 0
        $0.addTarget(self, action: #selector(bellTypeSoundButtonDidTap(sender:)), for: .touchUpInside)
        
    }
    let bellTypeVibButton = UIButton().then {
        $0.frame = CGRect.init()
        $0.setImage(UIImage(named:"btn_makealarm_vib_off") ?? UIImage(), for: .normal)
        $0.setImage(UIImage(named:"btn_makealarm_vib_on") ?? UIImage(), for: .selected)
        $0.isSelected = true
        $0.addTarget(self, action: #selector(bellTypeVibButtonDidTap(sender:)), for: .touchUpInside)
    }
    let bellSettingSoundNameButton = UIButton().then {
        $0.titleLabel?.font = .spoqaSans(size: 12, family: .Regular)
        $0.setTitleColor(.gray4, for: .normal)
        $0.setTitle("벨소리이름길게길게", for: .normal)
        $0.titleLabel?.lineBreakMode = .byTruncatingTail
    }
    let bellSettingSoundSelectButton = UIButton().then {
        $0.setImage(UIImage(named:"icon_makealarm_arrow") ?? UIImage(), for: .normal)
        $0.setTitle("", for: .normal)
    }
    let bellSettingSlider = UISlider().then {
        $0.maximumTrackTintColor = .lineGray
//        $0.thumbTintColor = .mainPur
        $0.setThumbImage(UIImage(named: "thumb_purple"), for: .normal)
        $0.setThumbImage(UIImage(named: "thumb_purple"), for: .highlighted)
        $0.minimumValue = 0.0
        $0.maximumValue = 1.0
        $0.setValue($0.maximumValue, animated: false)
        $0.minimumTrackTintColor = .mainPur
        $0.addTarget(self, action: #selector(sliderValueChanged(sender:)), for: .valueChanged)
        
    }
    let bellSettingImageView = UIImageView().then {
        $0.image = UIImage(named:"iconMakealarmBellOn")
    }
    let alarmMemoBoxView = UIView().then {
        $0.backgroundColor = .paleGrey
        $0.setBorder(borderColor: .lineGray, borderWidth: 1)
        $0.layer.cornerRadius = 3
    }
    let alarmMemoTextField = UITextField().then {
        $0.backgroundColor = .clear
        $0.textColor = .gray1
        $0.font = .spoqaSans(size: 15, family: .Regular)
        $0.returnKeyType = .done
    }
    
    let addAlarmButton = UIButton().then {
        $0.backgroundColor = .mainColor
        $0.layer.cornerRadius = 22
        $0.setTitle("알람 추가", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .spoqaSans(size: 16, family: .Bold)
        $0.titleEdgeInsets = UIEdgeInsets(top: 3, left: 0, bottom: 0, right: 0)
        $0.addTarget(self, action: #selector(addAlarm(sender:)), for: .touchUpInside)
    }
    //MARK: - IBOutlets
    
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
        setFeedbackGenerator()
        setStyle()
        initPicker()
        setLayout()
        alarmMemoTextField.delegate = self
        weekdayCollectionView.delegate = self
        weekdayCollectionView.dataSource = self
        weekdayCollectionView.collectionViewLayout = layout
        weekdayCollectionView.register(WeekdayCVC.self,forCellWithReuseIdentifier: WeekdayCVC.identifier)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let existing = existingAlarm {
            alarm = existing
        }
        setAlarmOptionsView()
    }
    func setFeedbackGenerator() {
        feedbackGenerator = UISelectionFeedbackGenerator()
        feedbackGenerator?.prepare()
    }
    func setStyle(){
        titleLabel.font = UIFont.spoqaSans(size: 22, family: .Bold)
        titleLabel.textColor = .gray1
        
        subtitleLabel.font = UIFont.spoqaSans(size: 16, family: .Light)
        subtitleLabel.textColor = .gray3
        
        pickerBackgroundView.layer.cornerRadius = 15
        pickerBackgroundView.dropShadow(color: UIColor(red: 0.19, green: 0.25, blue: 0.29, alpha: 0.1), offSet: CGSize(width: 0, height: 0), opacity: 1, radius: 15)
        
        pickerDashedView.setRoundedDashedBorder(strokeColor: UIColor.mainPur.cgColor, fillColor: UIColor.clear.cgColor, cornerRadius: 15, lineDashPattern: [8,8], lineWidth: 1, lineCap: .round)
        
        purpleRoundView.backgroundColor = .mainPur
        purpleRoundView.layer.cornerRadius = 50
        purpleRoundView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        
        nextAlarmMessageView.layer.cornerRadius = 5
        nextAlarmMessageView.backgroundColor = .white.withAlphaComponent(0.15)
        nextAlarmMessageLabel.font = .spoqaSans(size: 12, family: .Bold)
        nextAlarmMessageLabel.textColor = .white
    }
    func initPicker(){
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.calendar = Calendar.current
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.tintColor = .mainPur
        datePicker.addTarget(self, action: #selector(pickerValueChanged(sender:)), for: .valueChanged)
    
    }
    func setPickerDate() {
        datePicker.date = alarm.date
    }
    func setAlarmMissionOptionLabel() {
        alarmMissionOptionLabel.text = alarm.mission.rawValue
    }
    func setWeekday() {
        for weekday in alarm.repeatWeekdays {
            weekdayCollectionView.selectItem(at: [0,weekday-1], animated: false, scrollPosition: .left)
        }
    }
    func setBellTypeButton() {
        bellTypeSoundButton.isSelected = alarm.volume > 0
        bellTypeVibButton.isSelected = alarm.vibration
    }
    func setBellSettingSlider() {
        bellSettingSlider.value = alarm.volume
        if bellSettingSlider.value == 0 {
            bellSettingSlider.setThumbImage(UIImage(named: "thumb_gray"), for: .normal)
            bellSettingSlider.setThumbImage(UIImage(named: "thumb_gray"), for: .highlighted)
        }
        else {
            bellSettingSlider.setThumbImage(UIImage(named: "thumb_purple"), for: .normal)
            bellSettingSlider.setThumbImage(UIImage(named: "thumb_purple"), for: .highlighted)
        }
    }
    func setBellSettingImageView() {
        if bellSettingSlider.value == 0 {
            bellSettingImageView.image = UIImage(named:"iconMakealarmBellOff")
        }
        else {
            bellSettingImageView.image = UIImage(named:"iconMakealarmBellOn")
        }
    }
    func setMemo() {
        alarmMemoTextField.text = alarm.memo
    }
    func setAlarmOptionsView(){
        setPickerDate()
        setNextAlarmMessage()
        setAlarmMissionOptionLabel()
        setWeekday()
        setBellTypeButton()
        setBellSettingSlider()
        setBellSettingImageView()
        setMemo()
    }
    func setNextAlarmMessage(){
        let time = alarm.remainingMinute
        let day = time / 1440
        let hour = (time % 1440) / 60
        let minute = (time % 1440) % 60
        var dayString = ""
        var hourString = ""
        var minuteString = ""
        if day != 0 {
            dayString = "\(day)일 "
        }
        if hour != 0 {
            hourString = "\(hour)시간 "
        }
        if minute != 0 {
            minuteString = "\(minute)분 "
        }
        let messageString = dayString + hourString + minuteString + "후에 알람이 울립니다"
        nextAlarmMessageLabel.text = messageString
        
    }
    func setLayout(){
        //MARK: - Add Components
        //line
        self.scrollView.addSubview(weekdayLine)
        self.scrollView.addSubview(bellTypeLine)
        self.scrollView.addSubview(bellSettingLine)
        self.scrollView.addSubview(alarmMemoLine)
        //title
        self.scrollView.addSubview(alarmMissionTitleLabel)
        self.scrollView.addSubview(weekdayTitleLabel)
        self.scrollView.addSubview(bellTypeTitleLabel)
        self.scrollView.addSubview(bellSettingTitleLabel)
        self.scrollView.addSubview(alarmMemoTitleLabel)
        
        self.scrollView.addSubview(alarmMissionOptionLabel)
        self.scrollView.addSubview(alarmMissionButton)
        
        self.scrollView.addSubview(weekdayCollectionView)
        self.scrollView.addSubview(holidayExceptionView)
        self.holidayExceptionView.addSubview(holidayExceptionLabel)
        self.holidayExceptionView.addSubview(holidayExceptionCheckImageView)
        self.scrollView.addSubview(specificExceptionView)
        self.specificExceptionView.addSubview(specificExceptionLabel)
        self.specificExceptionView.addSubview(specificExceptionCheckImageView)
    
        self.scrollView.addSubview(bellTypeSoundButton)
        self.scrollView.addSubview(bellTypeVibButton)
        
        self.scrollView.addSubview(bellSettingSoundNameButton)
        self.scrollView.addSubview(bellSettingSoundSelectButton)
        self.scrollView.addSubview(bellSettingSlider)
        self.scrollView.addSubview(bellSettingImageView)
        
        self.scrollView.addSubview(alarmMemoBoxView)
        self.scrollView.addSubview(alarmMemoTextField)
        self.scrollView.addSubview(addAlarmButton)
        
        //MARK: - Add Layouts
        alarmMissionTitleLabel.snp.makeConstraints {
            $0.top.equalTo(purpleRoundView.snp.bottom).offset(19)
            $0.leading.equalTo(weekdayLine.snp.leading).offset(8)
        }
        alarmMissionButton.snp.makeConstraints {
            $0.trailing.equalTo(weekdayLine.snp.trailing).offset(-4)
            $0.top.equalTo(purpleRoundView.snp.bottom).offset(21)
            $0.width.equalTo(16)
            $0.height.equalTo(16)
        }
        alarmMissionOptionLabel.snp.makeConstraints {
            $0.centerY.equalTo(alarmMissionButton.snp.centerY)
            $0.trailing.equalTo(alarmMissionButton.snp.leading).offset(-6)
        }
        
        weekdayLine.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(alarmMissionButton.snp.bottom).offset(19)
        }
        weekdayTitleLabel.snp.makeConstraints {
            $0.top.equalTo(weekdayLine.snp.bottom).offset(16)
            $0.leading.equalTo(weekdayLine.snp.leading).offset(8)
        }
        weekdayCollectionView.snp.makeConstraints {
            $0.top.equalTo(weekdayTitleLabel.snp.bottom).offset(14)
            $0.width.equalTo(327)
            $0.height.equalTo(76)
            $0.centerX.equalToSuperview()
            $0.leading.equalTo(bellTypeLine)
            $0.trailing.equalTo(bellTypeLine)
        }
        holidayExceptionView.snp.makeConstraints {
//            $0.top.equalTo(weekdayCollectionView.snp.bottom).offset(9)
            $0.top.equalTo(weekdayCollectionView.snp.bottom).offset(0)
            $0.leading.equalTo(weekdayCollectionView.snp.leading)
            $0.width.equalTo(159*Int(screenBounds.width)/defaultWidth)
//            $0.height.equalTo(40*Int(screenBounds.width)/defaultWidth)
        }
        holidayExceptionLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(12)
            $0.width.equalTo(68)
            $0.height.equalTo(21)
        }
        holidayExceptionCheckImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(-12)
            $0.width.equalTo(16)
            $0.height.equalTo(16)
        }
        specificExceptionView.snp.makeConstraints {
            $0.top.equalTo(holidayExceptionView)
            $0.trailing.equalTo(weekdayCollectionView.snp.trailing)
            $0.width.equalTo(159*Int(screenBounds.width)/defaultWidth)
//            $0.height.equalTo(40*Int(screenBounds.width)/defaultWidth)
        }
        specificExceptionLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(12)
            $0.width.equalTo(68)
            $0.height.equalTo(21)
        }
        specificExceptionCheckImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(-12)
            $0.width.equalTo(16)
            $0.height.equalTo(16)
        }
        
        bellTypeLine.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(holidayExceptionView.snp.bottom).offset(16)
            $0.height.equalTo(1)
        }
        bellTypeTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(bellTypeLine.snp.leading).offset(8)
            $0.top.equalTo(bellTypeLine.snp.bottom).offset(16)
            $0.height.equalTo(24)
        }
        bellTypeVibButton.snp.makeConstraints {
            $0.trailing.equalTo(bellTypeLine.snp.trailing)
            $0.top.equalTo(bellTypeLine.snp.bottom).offset(14)
            $0.width.equalTo(30)
            $0.height.equalTo(30)
        }
        bellTypeSoundButton.snp.makeConstraints {
            $0.trailing.equalTo(bellTypeVibButton.snp.leading).offset(-11)
            $0.top.bottom.width.height.equalTo(bellTypeVibButton)
            
        }
        
        bellSettingLine.snp.makeConstraints {
            $0.top.equalTo(bellTypeTitleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(bellTypeLine)
            
        }
        bellSettingTitleLabel.snp.makeConstraints {
            $0.top.equalTo(bellSettingLine).offset(16)
            $0.height.equalTo(24)
            $0.leading.equalTo(bellSettingLine).offset(8)
        }
        bellSettingSoundSelectButton.snp.makeConstraints {
            $0.top.equalTo(bellSettingLine.snp.bottom).offset(21)
            $0.height.equalTo(16)
            $0.width.equalTo(16)
            $0.trailing.equalTo(bellSettingLine).offset(-4)
        }
        bellSettingSoundNameButton.snp.makeConstraints {
            $0.top.equalTo(bellSettingLine.snp.bottom).offset(21)
            $0.height.equalTo(18)
            $0.width.equalTo(99)
            $0.trailing.equalTo(bellSettingSoundSelectButton.snp.leading).offset(-6)
        }
        bellSettingSlider.snp.makeConstraints {
            $0.top.equalTo(bellSettingTitleLabel.snp.bottom).offset(16)
            $0.leading.equalTo(bellSettingTitleLabel)
            $0.trailing.equalTo(bellSettingImageView.snp.leading).offset(-12)
        }
        bellSettingImageView.snp.makeConstraints{
            $0.top.equalTo(bellSettingSlider)
            $0.trailing.equalTo(bellSettingLine).offset(-4)
            $0.width.equalTo(24)
            $0.height.equalTo(24)
        }
        
        alarmMemoLine.snp.makeConstraints{
            $0.top.equalTo(bellSettingSlider.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(bellSettingLine)
        }
        alarmMemoTitleLabel.snp.makeConstraints{
            $0.top.equalTo(alarmMemoLine.snp.bottom).offset(16)
            $0.leading.equalTo(alarmMemoLine).offset(8)
            $0.width.equalTo(65)
            $0.height.equalTo(24)
        }
        alarmMemoBoxView.snp.makeConstraints{
            $0.top.equalTo(alarmMemoTitleLabel.snp.bottom).offset(14)
            $0.leading.equalTo(alarmMemoLine).offset(6)
            $0.trailing.equalTo(alarmMemoLine).offset(-6)
            $0.height.equalTo(38)
        }
        alarmMemoTextField.snp.makeConstraints{
            $0.top.leading.equalTo(alarmMemoBoxView).offset(8)
            $0.trailing.bottom.equalTo(alarmMemoBoxView).offset(-8)
        }
        
        addAlarmButton.snp.makeConstraints{
            $0.top.equalTo(alarmMemoBoxView.snp.bottom).offset(16)
            $0.width.equalTo(158)
            $0.height.equalTo(44)
            $0.bottom.equalToSuperview().offset(-20)
            $0.centerX.equalToSuperview()
        }
        
        
    }
    
    //MARK: - IBActions
    @IBAction func closeButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Objc functions
    
    @objc func holidayExceptionViewDidTap(sender: UIView) {
        
    }
    @objc func bellTypeSoundButtonDidTap(sender: UIButton) {
        feedbackGenerator?.selectionChanged()
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            alarm.volume = 1.0
        }
        else {
            alarm.volume = 0.0
        }
    }
    @objc func bellTypeVibButtonDidTap(sender: UIButton) {
        feedbackGenerator?.selectionChanged()
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            alarm.vibration = true
        }
        else {
            alarm.vibration = false
        }
    }
    @objc func pickerValueChanged(sender: UIDatePicker) {
        alarm.date = sender.date
    }
    @objc func sliderValueChanged(sender: UISlider) {
        alarm.volume = sender.value
    }
    @objc func addAlarm(sender: UIButton) {
        alarmMemoTextField.resignFirstResponder()
        alarm.enabled = true
        if let existing = existingAlarm {
            for i in 0..<alarmModel.alarms.count {
                if alarmModel.alarms[i].uuid == existing.uuid {
                    alarmModel.alarms[i] = alarm
                }
            }
        }
        else{
            alarmModel.alarms.append(alarm)
        }
        self.dismiss(animated: true, completion: nil)
    }
    @objc func missionButtonDidTap(sender: UIButton) {
        let missionOptionsVC = storyboard?.instantiateViewController(withIdentifier: "MissionOptionsVC") as! MissionOptionsVC
        missionOptionsVC.mission = alarm.mission
        navigationController?.pushViewController(missionOptionsVC, animated: true)
        
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
        
    }
    
    init (text: String){
        super.init(frame: CGRect.zero)
        self.frame = CGRect(x: 0, y: 0, width: 65, height: 24)
        self.font = .spoqaSans(size: 16, family: .Regular)
        self.baselineAdjustment = .alignBaselines
        self.textColor = .gray1
        self.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension AddAlarmVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weekdayList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeekdayCVC.identifier, for: indexPath) as? WeekdayCVC else { return UICollectionViewCell() }
        cell.alarmInfo = alarm
        cell.setLabel(text: weekdayList[indexPath.item])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        feedbackGenerator?.selectionChanged()
        alarm.repeatWeekdays.append(indexPath.item + 1)
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        feedbackGenerator?.selectionChanged()
        alarm.repeatWeekdays.remove(at: alarm.repeatWeekdays.firstIndex(of: indexPath.item + 1)!)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 33, height: 33)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 22*screenBounds.width/CGFloat(defaultWidth), left: 21*screenBounds.width/CGFloat(defaultWidth), bottom: 21*screenBounds.width/CGFloat(defaultWidth), right: 21*screenBounds.width/CGFloat(defaultWidth))
//    }
    
    
}

extension AddAlarmVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        lastScrollViewOffset = scrollView.contentOffset
        scrollView.setContentOffset(CGPoint(x: 0, y: Int(alarmMemoTextField.frame.origin.y) - 413 * Int(screenBounds.width) / defaultWidth), animated: true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        scrollView.setContentOffset(lastScrollViewOffset, animated: true)
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        alarm.memo = textField.text ?? ""
    }
}
//
//class AlarmOptionsView: UIView {
//    let weekdayLine = GrayLine()
//    let bellTypeLine = GrayLine()
//    let bellSettingLine = GrayLine()
//    let alarmMemoLine = GrayLine()
//    let alarmMissionTitleLabel = TableTitleLabel(text: "알람 미션")
//    let weekdayTitleLabel = TableTitleLabel(text: "요일 선택")
//    let bellTypeTitleLabel = TableTitleLabel(text: "타입")
//    let bellSettingTitleLabel = TableTitleLabel(text: "벨소리")
//    let alarmMemoTitleLabel = TableTitleLabel(text: "알람 메모")
//    let alarmMissionOptionLabel = UILabel().then {
//        $0.text = "기본"
//        $0.frame = CGRect(x: 0, y: 0, width: 24, height: 18)
//        $0.font = .spoqaSans(size: 12, family: .Regular)
//        $0.textColor = .gray4
//    }
//    let alarmMissionButton = UIButton().then{
//        $0.setTitle("", for: .normal)
//        $0.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
//        $0.setImage(UIImage(named:"icon_makealarm_arrow"), for: .normal)
//        $0.contentMode = .scaleAspectFill
//    }
//
//    let weekdayCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout()).then {
//        $0.frame = CGRect(x: 0, y: 0, width: 327*Int(screenBounds.width)/defaultWidth, height: 76*Int(screenBounds.width)/defaultWidth)
//        $0.backgroundColor = UIColor.greyBg
//        $0.makeRounded(cornerRadius: 5)
//        $0.allowsMultipleSelection = true
//    }
//    let holidayExceptionView = UIView().then {
//        $0.frame = CGRect(x: 0, y: 0, width: 159*Int(screenBounds.width)/defaultWidth, height: 40*Int(screenBounds.width)/defaultWidth)
//        $0.backgroundColor = UIColor.greyBg
//        $0.isHidden = true
//    }
//    let holidayExceptionLabel = UILabel().then {
//        $0.frame = CGRect(x: 0, y: 0, width: 70, height: 21)
//        $0.text = "공휴일 제외"
//        $0.font = .spoqaSans(size: 14, family: .Regular)
//        $0.textColor = UIColor(white: 0.74, alpha: 1)
//    }
//    let holidayExceptionCheckImageView = UIImageView().then {
//        $0.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
//        $0.image = UIImage(named:"icon_makealarm_check_gray")
//
//    }
//    let specificExceptionView = UIView().then {
//        $0.frame = CGRect(x: 0, y: 0, width: 159*Int(screenBounds.width)/defaultWidth, height: 40*Int(screenBounds.width)/defaultWidth)
//        $0.backgroundColor = UIColor.greyBg
//        $0.isHidden = true
//    }
//    let specificExceptionLabel = UILabel().then {
//        $0.frame = CGRect(x: 0, y: 0, width: 70, height: 21)
//        $0.text = "특정일 제외"
//        $0.font = .spoqaSans(size: 14, family: .Regular)
//        $0.textColor = UIColor(white: 0.74, alpha: 1)
//    }
//    let specificExceptionCheckImageView = UIImageView().then {
//        $0.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
//        $0.image = UIImage(named:"icon_makealarm_check_gray")
//
//    }
//    let bellTypeSoundButton = UIButton().then {
//        $0.frame = CGRect.init()
//        $0.setImage(UIImage(named:"btn_makealarm_sound_off") ?? UIImage(), for: .normal)
//        $0.setImage(UIImage(named:"btn_makealarm_sound_on") ?? UIImage(), for: .selected)
////        $0.isSelected = alarm.volume > 0
////        $0.addTarget(self, action: #selector(bellTypeSoundButtonDidTap(sender:)), for: .touchUpInside)
//
//    }
//    let bellTypeVibButton = UIButton().then {
//        $0.frame = CGRect.init()
//        $0.setImage(UIImage(named:"btn_makealarm_vib_off") ?? UIImage(), for: .normal)
//        $0.setImage(UIImage(named:"btn_makealarm_vib_on") ?? UIImage(), for: .selected)
//        $0.isSelected = true
////        $0.addTarget(self, action: #selector(bellTypeVibButtonDidTap(sender:)), for: .touchUpInside)
//    }
//    let bellSettingSoundNameButton = UIButton().then {
//        $0.titleLabel?.font = .spoqaSans(size: 12, family: .Regular)
//        $0.setTitleColor(.gray4, for: .normal)
//        $0.setTitle("벨소리이름길게길게", for: .normal)
//        $0.titleLabel?.lineBreakMode = .byTruncatingTail
//    }
//    let bellSettingSoundSelectButton = UIButton().then {
//        $0.setImage(UIImage(named:"icon_makealarm_arrow") ?? UIImage(), for: .normal)
//        $0.setTitle("", for: .normal)
//    }
//    let bellSettingSlider = UISlider().then {
//        $0.maximumTrackTintColor = .lineGray
////        $0.thumbTintColor = .mainPur
//        $0.setThumbImage(UIImage(named: "thumb_purple"), for: .normal)
//        $0.setThumbImage(UIImage(named: "thumb_purple"), for: .highlighted)
//        $0.minimumValue = 0.0
//        $0.maximumValue = 1.0
//        $0.setValue($0.maximumValue, animated: false)
//        $0.minimumTrackTintColor = .mainPur
////        $0.addTarget(self, action: #selector(sliderValueChanged(sender:)), for: .valueChanged)
//
//    }
//    let bellSettingImageView = UIImageView().then {
//        $0.image = UIImage(named:"iconMakealarmBellOn")
//    }
//    let alarmMemoBoxView = UIView().then {
//        $0.backgroundColor = .paleGrey
//        $0.setBorder(borderColor: .lineGray, borderWidth: 1)
//        $0.layer.cornerRadius = 3
//    }
//    let alarmMemoTextField = UITextField().then {
//        $0.backgroundColor = .clear
//        $0.textColor = .gray1
//        $0.font = .spoqaSans(size: 15, family: .Regular)
//        $0.returnKeyType = .done
//    }
//
//    let addAlarmButton = UIButton().then {
//        $0.backgroundColor = .mainColor
//        $0.layer.cornerRadius = 22
//        $0.setTitle("알람 추가", for: .normal)
//        $0.setTitleColor(.white, for: .normal)
//        $0.titleLabel?.font = .spoqaSans(size: 16, family: .Bold)
//        $0.titleEdgeInsets = UIEdgeInsets(top: 3, left: 0, bottom: 0, right: 0)
////        $0.addTarget(self, action: #selector(addAlarm(sender:)), for: .touchUpInside)
//    }
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        addSubview(<#T##view: UIView##UIView#>)
//    }
//}
