//
//  AlarmModel.swift
//  Wooly
//
//  Created by 이예슬 on 2021/06/06.
//

import Foundation
//import MediaPlayer

struct Alarm: Codable{
    var date: Date = Date()
    var enabled: Bool = false
    var snoozeEnabled: Bool = false
    var repeatWeekdays: [Int] = []
    var uuid: String = ""
    var mediaID: String = ""
    var mediaLabel: String = "bell"
    var label: String = "Alarm"
    var mission: MissionType
    var holidayExcepted: Bool? = false
    var specificDayExcepted: Bool? = false
    var ringType: RingType
    var memo: String
    
}

enum RingType: String,Codable{
    case bell
    case vibration
}

enum MissionType: String,Codable{
    case none
    case promise
}
