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
    
    private var secondsTotalTime = 0
    
    var calcData: [Double] = []
    
    // 今月分のタイマーデータ
    private (set) internal var currentMonthData: [[String:String]] = [
        ["date": "4/1", "time": "1800"],
        ["date": "4/2", "time": "1240"],
        ["date": "4/3", "time": "780"],
        ["date": "4/4", "time": "1800"],
        ["date": "4/5", "time": "1240"],
        ["date": "4/6", "time": "7800"],
        ["date": "4/7", "time": "1800"],
        ["date": "4/8", "time": "1240"],
        ["date": "4/9", "time": "7800"],
        ["date": "4/10", "time": "1800"],
        ["date": "4/11", "time": "1240"],
        ["date": "4/12", "time": "7800"],
        ["date": "4/13", "time": "1800"],
        ["date": "4/14", "time": "1240"],
        ["date": "4/15", "time": "7800"],
        ["date": "4/16", "time": "1800"],
        ["date": "4/17", "time": "1240"],
        ["date": "4/18", "time": "1800"],
        ["date": "4/19", "time": "1240"],
        ["date": "4/20", "time": "7800"],
        ["date": "4/21", "time": "6000"],
        ["date": "4/22", "time": "0"],
        ["date": "4/23", "time": "0"],
        ["date": "4/24", "time": "0"],
        ["date": "4/25", "time": "0"],
        ["date": "4/26", "time": "0"],
        ["date": "4/27", "time": "0"],
        ["date": "4/28", "time": "0"],
        ["date": "4/29", "time": "0"],
        ["date": "4/30", "time": "0"]
    ]

    // 秒数データを管理する配列の操作
    func addSecondsData() {
        let particularItem = Int(DateModel.dateModel.lastDate()) - Int(DateModel.dateModel.todayDate())!
        // 月が変わった場合、currentMonthData(配列)にtimeが0のデータを入れる
        let monthLastDay = currentMonthData[currentMonthData.count - 1]["date"]
        let currentMonthLastDay = "\(DateModel.dateModel.currentMonth())/\(DateModel.dateModel.lastDate())"
        if monthLastDay != currentMonthLastDay {
            DateModel.dateModel.monthDateAssignment()
            currentMonthData = DateModel.dateModel.currentMonthEmptyData
        }
        // その月初めて利用する場合、currentMonthData(配列)にtimeが0のデータを入れる
        if currentMonthData.count < DateModel.dateModel.lastDate() {
            DateModel.dateModel.monthDateAssignment()
            currentMonthData = DateModel.dateModel.currentMonthEmptyData
        }
        // 配列に今日の日付分のデータが既に存在する場合
        if DateModel.dateModel.todayMonthDate() == currentMonthData[currentMonthData.count - particularItem - 1]["date"]! {
            currentMonthData[currentMonthData.count - particularItem - 1]["time"] = String(TimerModel.timerModel.timerMoved)
        }
    }
    
    // グラフのタイマー時間の総数ラベル
    func graphTimeLabel(segmentIndex: Int, referenceType: Int) -> Double {
        let oneHourSeconds: Int = 3600
        var convertSecondsIntoHour: Double?
        switch segmentIndex {
        case 0:
            let particularItem = Int(DateModel.dateModel.lastDate()) - Int(DateModel.dateModel.todayDate())!
            let particularTime = GraphDataModel.graphDataModel.currentMonthData.count - particularItem - referenceType
            let targetTime = GraphDataModel.graphDataModel.currentMonthData[particularTime]["time"]
            // 小数第二位で繰り上げる
            convertSecondsIntoHour = round(Double(targetTime!)! / Double(oneHourSeconds) * 10) / 10
        case 1:
            if referenceType == 1 {
                secondsTotalTime = 0
                for i in 0...9 {
                    convertSecondsIntoHour = totalTime(date: i)
                }
            } else if referenceType == 0 {
                secondsTotalTime = 0
                for i in 10...19 {
                    convertSecondsIntoHour = totalTime(date: i)
                }
            } else if referenceType == -1 {
                secondsTotalTime = 0
                for i in 20...GraphDataModel.graphDataModel.currentMonthData.count - 1 {
                    convertSecondsIntoHour = totalTime(date: i)
                }
            }
        case 2:
            secondsTotalTime = 0
            for i in 0...GraphDataModel.graphDataModel.currentMonthData.count - 1 {
                convertSecondsIntoHour = totalTime(date: i)
            }
        default: break
        }
        return convertSecondsIntoHour!
    }
    
    // セグメントの「10日」「月」表示の時に合計時間を計算する
    func totalTime(date: Int) -> Double {
        let secondsTime = GraphDataModel.graphDataModel.currentMonthData[date]["time"]
        secondsTotalTime += Int(secondsTime!)!
        let oneHourSeconds: Int = 3600
        return round(Double(secondsTotalTime) / Double(oneHourSeconds) * 10) / 10
    }
    
    // グラフの日付ラベル
    func graphDateLabel(segmentIndex: Int, referenceType: Int) -> String {
        var targetDate: String?
        switch segmentIndex {
        case 0:
            let particularItem = Int(DateModel.dateModel.lastDate()) - Int(DateModel.dateModel.todayDate())!
            let particularTime = GraphDataModel.graphDataModel.currentMonthData.count - particularItem - referenceType
            targetDate = GraphDataModel.graphDataModel.currentMonthData[particularTime]["date"]!
        default: break
        }
        return targetDate!
    }
    
    // セグメントに合わせて、グラフの表示を切り替える
    func graphTimeCalc(segmentIndex: Int, referenceType: Int) {
        calcData = []
        switch segmentIndex {
        case 0:
            let particularItem = Int(DateModel.dateModel.lastDate()) - Int(DateModel.dateModel.todayDate())!
            let particularTime = GraphDataModel.graphDataModel.currentMonthData.count - particularItem - referenceType
            convertSecondsIntoTime(target: particularTime)
        case 1:
            if referenceType == 1 {
                for i in 0...9 {
                    convertSecondsIntoTime(target: i)
                }
            } else if referenceType == 0 {
                for i in 10...19 {
                    convertSecondsIntoTime(target: i)
                }
            } else if referenceType == -1 {
                for i in 20...GraphDataModel.graphDataModel.currentMonthData.count - 1 {
                    convertSecondsIntoTime(target: i)
                }
            }
        case 2:
            for i in 0...GraphDataModel.graphDataModel.currentMonthData.count - 1 {
                convertSecondsIntoTime(target: i)
            }
        default: break
        }
    }
    
    // グラフに表示するために、単位を秒数→時間に変換する
    func convertSecondsIntoTime(target: Int) {
        let oneHourSeconds: Int = 3600
        let targetTime = GraphDataModel.graphDataModel.currentMonthData[target]["time"]
        let convertSecondsIntoHour = round(Double(targetTime!)! / Double(oneHourSeconds) * 10) / 10
        calcData.append(convertSecondsIntoHour)
    }
}
