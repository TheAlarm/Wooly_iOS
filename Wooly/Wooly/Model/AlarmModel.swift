//
//  AlarmModel.swift
//  Wooly
//
//  Created by 이예슬 on 2021/06/06.
//

import Foundation
import MediaPlayer

struct Alarm{
    var date: Date = Date()
    var enabled: Bool = false
    var snoozeEnabled: Bool = false
    var repeatWeekdays: [Int] = []
    var uuid: String = ""
    var mediaID: String = ""
    var mediaLabel: String = "bell"
    var label: String = "Alarm"
    var mission: MissionModel
    var holidayExcepted: Bool = false
    var specificDayExcepted: Bool = false
    var ringType: RingType
    var memo: String
    
}

enum RingType{
    case bell
    case vibration
}
