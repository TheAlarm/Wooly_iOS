//
//  Date+Extension.swift
//  Wooly
//
//  Created by 이예슬 on 2021/05/17.
//

import Foundation

extension Date{
    func getTimeString() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H시 m분"
        return dateFormatter.string(from: self)
    }
}
