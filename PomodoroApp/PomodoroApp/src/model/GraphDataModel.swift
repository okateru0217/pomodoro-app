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
    // 先月分のタイマーデータ
    private (set) internal var currentMonthData = [
        ["date": "2021年4月18日 月曜日", "time": "1240"],
    ]
    private var lastMonthData: [Int] = []
    
    
    // 秒数データを管理する配列の操作
    func addSecondsData() {
        let date = DateFormatter()
        date.dateStyle = .full
        date.locale = Locale(identifier: "ja_JP")
        let today = Date()
        // 配列に今日の日付分のデータが既に存在する場合
        if date.string(from: today) == currentMonthData[currentMonthData.count - 1]["date"]! {
            currentMonthData[currentMonthData.count - 1]["time"] = String(TimerModel.timerModel.timerMoved)
        // 配列に今日の日付分のデータが存在しない場合
        } else {
            currentMonthData.append(["date": date.string(from: today), "time": String(TimerModel.timerModel.timerMoved)])
        }
    }
}
