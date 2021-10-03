//
//  AlarmModel.swift
//  Wooly
//
//  Created by 이예슬 on 2021/06/06.
//

import Foundation
import UIKit
//import MediaPlayer

struct Alarm: Codable{
    var date: Date = Date().addingTimeInterval(60)
    var enabled: Bool = true
    var snoozeEnabled: Bool = false
    var nextWeekday: Int {
        get {
            return getNextWeekday(weekdays: repeatWeekdays)
        }
    }
    var repeatWeekdays: [Int] = []
    var uuid: String = UUID().uuidString
    var mediaID: String = ""
    var mediaLabel: String = "bell"
    var label: String = "Alarm"
    var volume: Float = 1.0
    var mission: MissionType = .none
    var holidayExcepted: Bool? = false
    var specificDayExcepted: Bool? = false
    var ringType: [RingType] = [.bell, .vibration]
    var vibration: Bool = true
    var memo: String = ""
    var remainingMinute: Int {
        get {
            return calculateRemainingMinute(nextWeekday, date)
        }
    }
    
    func getNextWeekday(weekdays: [Int]) -> Int{
        if weekdays.count == 0 {
            let nowDateComponents = Calendar.current.dateComponents([.weekday,.hour,.minute], from: Date())
            let nowWeekday = nowDateComponents.weekday ?? 1
            let nowHour = nowDateComponents.hour ?? 0
            let nowMinute = nowDateComponents.minute ?? 0
            let alarmDateComponents = Calendar.current.dateComponents([.hour,.minute], from: date)
            let alarmHour = alarmDateComponents.hour ?? 0
            let alarmMinute = alarmDateComponents.minute ?? 0
            var alarmWeekday = 0
            if nowHour < alarmHour {
                alarmWeekday = nowWeekday
            }
            else if nowHour == alarmHour {
                if nowMinute < alarmMinute {
                    alarmWeekday = nowWeekday
                }
                else {
                    alarmWeekday = nowWeekday % 7 + 1
                }
            }
            else {
                alarmWeekday = nowWeekday % 7 + 1
            }
            return alarmWeekday
        }
        else {
            var minMinute = 987654321
            var minWeekday = 0
            for weekday in repeatWeekdays {
                let minute = calculateRemainingMinute(weekday, self.date)
                if minute < minMinute {
                    minMinute = minute
                    minWeekday = weekday
                }
            }
            return minWeekday
        }
    }
    func calculateRemainingMinute(_ alarmWeekday: Int, _ alarmDate: Date) -> Int {
        let alarmDateComponents = Calendar.current.dateComponents([.hour,.minute], from: alarmDate)
        let nowDateComponents = Calendar.current.dateComponents([.weekday,.hour,.minute], from: Date())
        let nowWeekday = nowDateComponents.weekday ?? 1
        let nowHour = nowDateComponents.hour ?? 0
        let nowMinute = nowDateComponents.minute ?? 0
        let alarmHour = alarmDateComponents.hour ?? 0
        let alarmMinute = alarmDateComponents.minute ?? 0
        var remainingMinute = 0
        func calculateAlarmAfterNow() -> Int{
            let nowRemaining = 60 - nowMinute + (24 - (nowHour + 1)) * 60
            let daysGap = (alarmWeekday - nowWeekday - 1) * 24 * 60
            let alarmRemaining = alarmHour * 60 + alarmMinute
            return nowRemaining + daysGap + alarmRemaining
        }
        func calculateAlarmBeforeNow() -> Int{
            let nowRemaining = 60 - nowMinute + (24 - (nowHour + 1)) * 60
            let toSaturday = (7 - nowWeekday) * 60 * 24
            let fromSunday = (alarmWeekday - 1) * 24 * 60
            let daysGap = toSaturday + fromSunday
            let alarmRemaining = alarmHour * 60 + alarmMinute
            return nowRemaining + daysGap + alarmRemaining
        }
        remainingMinute = calculateAlarmAfterNow()
        if nowWeekday < alarmWeekday {
            remainingMinute = calculateAlarmAfterNow()
        }
        else if nowWeekday == alarmWeekday {
            if nowHour < alarmHour {
                remainingMinute = calculateAlarmAfterNow()
            }
            else if nowHour == alarmHour {
                if nowMinute < alarmMinute {
                    remainingMinute = calculateAlarmAfterNow()
                }
                else {
                    remainingMinute = calculateAlarmBeforeNow()
                }
            }
            else {
                remainingMinute = calculateAlarmBeforeNow()
            }
        }
        else {
            remainingMinute = calculateAlarmBeforeNow()
        }
        return remainingMinute
    }
}

enum RingType: String,Codable{
    case bell
    case vibration
}

enum MissionType: String,Codable{
    case none = "기본"
    case promise = "다짐 작성"
}

class Alarms {
    static let shared = Alarms()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let userDefaults = UserDefaults.standard
    var alarmsChangedClosure: (()->())?
    var alarms: Array<Alarm> = []{
        didSet {
            print("alarms didSet")
            updateAlarmUserDefaults()
            setNextAlarmPushNotification()
            alarmsChangedClosure?()
        }
        
    }
    var remainingTime: Int? = nil
    var nextAlarm: Alarm? {
        get {
            return getNextAlarm()
        }
    }
    var nextWeekday: Int? {
        get {
            if nextAlarm == nil {
                return nil
            }
            else {
                return nextAlarm!.nextWeekday
            }
        }
    }
    
    private init() {
        alarms = getAlarmUserDefaults()
    }
    var count: Int {
        get {
            alarms.count
        }
    }
    func updateAlarmUserDefaults(){
        userDefaults.setObjectList(alarms, forKey: "AlarmList")
    }
    func getAlarmUserDefaults() -> [Alarm]{
        guard let array =  userDefaults.getObjectList(Alarm.self, forKey: "AlarmList") else {
            return Array<Alarm>()
            
        }
        return array
    }
    
    func getNextAlarm() -> Alarm? {
        var minRemainingMinute = 987654321
        var minAlarm = Alarm()
        if alarms.count == 0 {
            return nil
        }
        for alarm in alarms {
            if alarm.enabled == false{
                continue
            }
            if alarm.remainingMinute < minRemainingMinute {
                minRemainingMinute = alarm.remainingMinute
                minAlarm = alarm
            }
        }
        if minRemainingMinute == 987654321 {
            return nil
        }
        return minAlarm
    }
    func setNextAlarmPushNotification(){
        Scheduler.shared.center.removeAllPendingNotificationRequests()
        if let next = nextAlarm {
            let nowDateComponents = Calendar.current.dateComponents([.second], from: Date())
            let timeInterval = 60 - nowDateComponents.second! + (next.remainingMinute - 1) * 60
            let triggerDate = Date() + TimeInterval(timeInterval)
            let triggerDateComponents = Calendar.current.dateComponents([.month,.day,.hour,.minute], from: triggerDate)
            
            Scheduler.shared.setUserNotification(memo: next.memo, time: nextAlarm!.date.getTimeString(), triggerDateComponents: triggerDateComponents, triggerRepeats: false, alarmIdentifier: nextAlarm!.uuid)
        }
    }
}

enum Weekday : Int {
    case Sunday = 1
    case Monday = 2
    case Tuesday = 3
    case Wednesday = 4
    case Thursday = 5
    case Friday = 6
    case Saturday = 7
}
