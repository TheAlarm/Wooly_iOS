//
//  AlarmMainVC.swift
//  Wooly
//
//  Created by 이예슬 on 2021/05/09.
//

import UIKit

class AlarmMainVC: UIViewController {
    let userDefaults = UserDefaults.standard
    //MARK: - Custom Properties
    let screenBounds = UIScreen.main.bounds
    let defaultViewWidth: CGFloat = 375
    let nextAlarmMessageViewHeight: CGFloat = 198
    let nextAlarmMessageEmptyString: String = "등록된 알람이 없어요."
    let nextAlarmMessageString: String = ""
    let alarmCardNib = UINib(nibName: "AlarmCardCVC", bundle: nil)
    var nextAlarmTime: Date? = nil {
        didSet{
            let hasNext = nextAlarmTime != nil
            nextAlarmMessageSmallLabel.isHidden = !hasNext
            nextAlarmMessageBigLabel.isHidden = !hasNext
            nextAlarmMessageEmptyLabel.isHidden = hasNext
            setNextAlarmMessage(time: nextAlarmTime)
        }
        
    }
    var nextAlarmState: NextAlarm = .empty
    var alarmList = ["10:30","12:58","10:30","12:58","10:30","12:58","10:30","12:58","10:30","12:58"]
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var dongdongBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var purpleBackgroundView: UIView!
    @IBOutlet weak var nextAlarmMessageView: UIView!
    @IBOutlet weak var nextAlarmDashedView: UIView!
    @IBOutlet weak var nextAlarmMessageEmptyLabel: UILabel!
    @IBOutlet weak var nextAlarmMessageSmallLabel: UILabel!
    @IBOutlet weak var nextAlarmMessageBigLabel: UILabel!
    @IBOutlet weak var alarmCardCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
//        print("load")
        alarmCardCollectionView.delegate = self 
        alarmCardCollectionView.dataSource = self
        setStyle()
        setNextAlarmMessage(time: nil)
        alarmCardCollectionView.register(alarmCardNib, forCellWithReuseIdentifier: "AlarmCardCVC")
        var date = DateComponents()
        date.second = 20
        let calendar = Calendar.current
        let tenSeconds = calendar.date(byAdding: date, to: Date())
//        var alarmList = Array<Alarm>()
//        alarmList.append(Alarm(date: Date(), enabled: true, snoozeEnabled: true, repeatWeekdays: [0,1,2], uuid: UUID().uuidString, mediaID: "", mediaLabel: "", label: "", mission: .none, holidayExcepted: nil, specificDayExcepted: nil, ringType: .bell, memo: ""))
//        alarmList.append(Alarm(date: Date(), enabled: true, snoozeEnabled: true, repeatWeekdays: [0,1,2], uuid: UUID().uuidString, mediaID: "", mediaLabel: "", label: "", mission: .none, holidayExcepted: nil, specificDayExcepted: nil, ringType: .bell, memo: ""))
//
//        userDefaults.setObjectList(alarmList, forKey: "AlarmList")
//        let l = userDefaults.getObjectList(Alarm.self, forKey: "AlarmList")
//        print(l,type(of: l))
//        Scheduler.shared.setUserNotification(memo: "이예슬최고😍", time: "저녁뭐먹지", triggerDateComponents: date, triggerRepeats: false, alarmIdentifier: "Alarm1")
//        Scheduler.shared.setUserNotification(memo: "이예슬최고😍", time: "저녁뭐먹지2", triggerDateComponents: date, triggerRepeats: false, alarmIdentifier: "Alarm2")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        nextAlarmTime = Date()
        
    }
    func setStyle(){
        purpleBackgroundView.backgroundColor = .mainPur
        purpleBackgroundView.clipsToBounds = true
        purpleBackgroundView.layer.cornerRadius = purpleBackgroundView.frame.height/231*50
        purpleBackgroundView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        
        nextAlarmMessageView.layer.cornerRadius = 30
        nextAlarmMessageView.backgroundColor = .lightPeriwinkle
        nextAlarmDashedView.backgroundColor = .none
        nextAlarmDashedView.layer.cornerRadius = 25
        nextAlarmDashedView.setRoundedDashedBorder(strokeColor: UIColor.paleLilac.cgColor, fillColor: nil, cornerRadius: 25, lineDashPattern: [5,10], lineWidth: 2, lineCap: .round)
        
        nextAlarmMessageEmptyLabel.font = UIFont.spoqaSans(size: 18, family: .Regular)
        nextAlarmMessageEmptyLabel.textColor = .gray1
        let attributedString = NSMutableAttributedString(string: nextAlarmMessageEmptyString)
        attributedString.addAttribute(.font, value: UIFont.spoqaSans(size: 18, family: .Bold), range: NSString(string: nextAlarmMessageEmptyString).range(of: "등록된 알람"))
        nextAlarmMessageEmptyLabel.attributedText = attributedString
        
        
        nextAlarmMessageSmallLabel.font = UIFont.spoqaSans(size: 18, family: .Light)
        nextAlarmMessageSmallLabel.textColor = .gray1
        
        nextAlarmMessageBigLabel.font = UIFont.spoqaSans(size: 24, family: .Bold)
        nextAlarmMessageBigLabel.textColor = .gray1
        

    }
    func setNextAlarmMessage(time: Date?){
        if time != nil{
            let timeString = time!.getTimeString()
            let attributedString = NSMutableAttributedString(string: "\(timeString) 남았어요")
            attributedString.addAttribute(.font, value: UIFont.spoqaSans(size: 24, family: .Light), range: attributedString.mutableString.range(of: "남았어요"))
            nextAlarmMessageBigLabel.attributedText = attributedString
        }
    }
}

extension AlarmMainVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: screenBounds.width/defaultViewWidth*nextAlarmMessageViewHeight, left: 16, bottom: 0, right: 16)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (screenBounds.width-32-15)/2, height: (screenBounds.width-32-15)/2/164*218)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
        if y >= 0{
            dongdongBottomConstraint.constant = y
        }
        else{
            dongdongBottomConstraint.constant = 0
        }
        
    }
    
}

extension AlarmMainVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return alarmList.count
    }

    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlarmCardCVC", for: indexPath)
        return cell
    }
    
}

enum NextAlarm{
    case empty
    case next
}
