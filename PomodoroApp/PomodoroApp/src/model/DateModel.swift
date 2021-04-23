//
//  DateModel.swift
//  PomodoroApp
//
//  Created by 岡澤輝明 on 2021/04/20.
//

import UIKit
import Foundation

final class DateModel {
    public static let dateModel = DateModel()
    private init() {}
    
    private (set) internal var currentMonthEmptyData: [[String:String]] = []
    
    func monthDateAssignment() {
        for i in 1...lastDate() {
            currentMonthEmptyData.append(["date": "\(currentMonth())/\(i)", "time": "0"])
        }
    }
    
    // 今日の年月日を取得
    func todayFullDate() -> String {
        let date = DateFormatter()
        date.setLocalizedDateFormatFromTemplate("yyyyMd")
        date.locale = Locale(identifier: "ja_JP")
        let today = Date()
        return date.string(from: today)
    }
    
    // 今日の日付を取得
    func todayMonthDate() -> String {
        let date = DateFormatter()
        date.setLocalizedDateFormatFromTemplate("Md")
        date.locale = Locale(identifier: "ja_JP")
        let today = Date()
        return date.string(from: today)
    }
    
    // 今日の日にちを取得
    func todayDate() -> String {
        let date = DateFormatter()
        date.setLocalizedDateFormatFromTemplate("d")
        date.locale = Locale(identifier: "ja_JP")
        let today = Date()
        return date.string(from: today)
    }
    
    // 今月は何月かを取得
    func currentMonth() -> String {
        let date = DateFormatter()
        date.setLocalizedDateFormatFromTemplate("M")
        date.locale = Locale(identifier: "ja_JP")
        let today = Date()
        return date.string(from: today)
    }
    
    // 今月の末日は何日かを取得
    func lastDate() -> Int {
        let date = Date()
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.year = Calendar.current.component(.year, from: date)
        components.month = Calendar.current.component(.month, from: date) + 1
        components.day = 0
        let dateCount = calendar.date(from: components)!
        let lastDay = calendar.component(.day, from: dateCount)
        return lastDay
    }
}
