//
//  GraphDataModel.swift
//  PomodoroApp
//
//  Created by 岡澤輝明 on 2021/04/19.
//

import UIKit
import Foundation

final class GraphDataModel {
    public static let graphDataModel = GraphDataModel()
    private init() {}
    
    // 今月分のタイマーデータ
    private (set) internal var currentMonthData: [[String:String]] = [
//        ["date": "4/1", "time": "1800"],
//        ["date": "4/2", "time": "1240"],
//        ["date": "4/3", "time": "780"],
//        ["date": "4/4", "time": "1800"],
//        ["date": "4/5", "time": "1240"],
//        ["date": "4/6", "time": "780"],
//        ["date": "4/7", "time": "1800"],
//        ["date": "4/8", "time": "1240"],
//        ["date": "4/9", "time": "780"],
//        ["date": "4/10", "time": "1800"],
//        ["date": "4/11", "time": "1240"],
//        ["date": "4/12", "time": "780"],
//        ["date": "4/13", "time": "1800"],
//        ["date": "4/14", "time": "1240"],
//        ["date": "4/15", "time": "780"],
//        ["date": "4/16", "time": "1800"],
//        ["date": "4/17", "time": "1240"],
//        ["date": "4/18", "time": "1800"],
//        ["date": "4/19", "time": "1240"],
//        ["date": "4/20", "time": "780"],
//        ["date": "4/21", "time": "1800"],
//        ["date": "4/22", "time": "1240"],
//        ["date": "4/23", "time": "780"],
//        ["date": "4/24", "time": "1800"],
//        ["date": "4/25", "time": "1240"],
//        ["date": "4/26", "time": "1800"],
//        ["date": "4/27", "time": "1240"],
//        ["date": "4/28", "time": "780"],
//        ["date": "4/29", "time": "1800"],
//        ["date": "4/30", "time": "1240"],
    ]

    // 秒数データを管理する配列の操作
    func addSecondsData() {
        var particularItem = 0
        particularItem = Int(DateModel.dateModel.lastDate()) - Int(todayDate())!
        
        // その月初めて利用する場合、currentMonthData(配列)にtimeが0のデータを入れる
        if currentMonthData.count < DateModel.dateModel.lastDate() {
            DateModel.dateModel.monthDateAssignment(currentMonthLastDay: DateModel.dateModel.lastDate())
            currentMonthData = DateModel.dateModel.currentMonthEmptyData
        }
        // 配列に今日の日付分のデータが既に存在する場合
        if todayMonthDate() == currentMonthData[currentMonthData.count - particularItem - 1]["date"]! {
            currentMonthData[currentMonthData.count - particularItem - 1]["time"] = String(TimerModel.timerModel.timerMoved)
        }
        print(currentMonthData)
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
}
