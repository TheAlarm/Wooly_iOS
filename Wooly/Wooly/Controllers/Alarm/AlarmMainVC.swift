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
    let alarms = Alarms.shared
    var nextAlarmTimer: Timer?
    
    var nextAlarmMinute: Int? = nil {
        didSet{
            let hasNext = nextAlarmMinute != nil
            nextAlarmMessageSmallLabel.isHidden = !hasNext
            nextAlarmMessageBigLabel.isHidden = !hasNext
            nextAlarmMessageEmptyLabel.isHidden = hasNext
            setNextAlarmMessage(time: nextAlarmMinute)
            if hasNext {
                startTimer()
            } else {
                stopTimer()
            }
        }
        
    }
    let appdelegate = UIApplication.shared.delegate
    
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
        alarmCardCollectionView.delegate = self
        alarmCardCollectionView.dataSource = self
        setStyle()
        setNextAlarmMessage(time: nil)
        alarmCardCollectionView.register(alarmCardNib, forCellWithReuseIdentifier: "AlarmCardCVC")
        Alarms.shared.alarmsChangedClosure = {
            self.updateNextAlarmRemainingMinute()
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateNextAlarmRemainingMinute()
        alarmCardCollectionView.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        stopTimer()
    }
    
    func startTimer() -> Bool{
        if nextAlarmMinute == nil {
            return false
        }
        if nextAlarmTimer != nil && nextAlarmTimer!.isValid {
            nextAlarmTimer!.invalidate()
        }
        nextAlarmTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true){ _ in
            print("timer")
            self.updateNextAlarmRemainingMinute()
        }
        return true
    }
    func stopTimer(){
        if nextAlarmTimer != nil {
            nextAlarmTimer!.invalidate()
            nextAlarmTimer = nil
        }
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
    func setNextAlarmMessage(time: Int?){
        if let time = time{
            var hourString = ""
            var minuteString = ""
            let hour = time / 60
            let minute = time % 60
            if hour != 0 {
                hourString = "\(hour)시간 "
            }
            if minute != 0 {
                minuteString = "\(minute)분 "
            }
            let attributedString = NSMutableAttributedString(string: "\(hourString)\(minuteString)남았어요")
            attributedString.addAttribute(.font, value: UIFont.spoqaSans(size: 24, family: .Light), range: attributedString.mutableString.range(of: "남았어요"))
            nextAlarmMessageBigLabel.attributedText = attributedString
        }
    }
    func updateNextAlarmRemainingMinute() {
        self.nextAlarmMinute = Alarms.shared.nextAlarm?.remainingMinute
    }
    
    @IBAction func addAlarmButtonDidTap(_ sender: Any) {
        let addAlarmSB = UIStoryboard(name: "AddAlarm", bundle: nil)
        let addAlarmVC = addAlarmSB.instantiateViewController(withIdentifier: "AddAlarmVC")
        let nc = AddAlarmNC(rootViewController: addAlarmVC)
        self.present(nc,animated: true)
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? AlarmCardCVC
        let alarm = cell?.alarmInfo
        let addAlarmSB = UIStoryboard(name: "AddAlarm", bundle: nil)
        let addAlarmVC = addAlarmSB.instantiateViewController(withIdentifier: "AddAlarmVC") as! AddAlarmVC
        addAlarmVC.existingAlarm = alarm
        let nc = AddAlarmNC(rootViewController: addAlarmVC)
        self.present(nc, animated: true)
    }
    
}

extension AlarmMainVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Alarms.shared.alarms.count
    }

    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlarmCardCVC", for: indexPath) as? AlarmCardCVC else { return UICollectionViewCell() }
        cell.alarmInfo = Alarms.shared.alarms[indexPath.item]
        cell.setAlarmCardData()
        return cell
    }
    
}

enum NextAlarm{
    case empty
    case next
}
