//
//  AlarmViewModel.swift
//  Wooly
//
//  Created by 이예슬 on 2021/08/29.
//

import Foundation

class AlarmViewModel {
    var alarmList: Array<Alarm>
    init(){
        self.alarmList = Array<Alarm>()
    }
    init(_ alarmList: Array<Alarm>) {
        self.alarmList = alarmList
    }
    var fastestAlarm: Int {
        return alarmList.count
    }
    var remainigMinToNextAlarm: Int {
        return 0
    }
    
    
}
