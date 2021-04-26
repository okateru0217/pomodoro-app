//
//  DetailRecordDataModel.swift
//  PomodoroApp
//
//  Created by 岡澤輝明 on 2021/04/21.
//

import UIKit
import Foundation

final class DetailRecordDataModel {
    public static let detailRecordDataModel = DetailRecordDataModel()
    private init() {}
    
    private var addingMultipleData: Int = 0
    private let oneHourSeconds: Int = 3600
    
    // 累計のポモドーロ時間
    func totalTimeRecord() -> Double {
        let convertSecondsIntoHour = round(Double(TimerModel.timerModel.totalPomodoroTime) / Double(oneHourSeconds) * 10) / 10
        return convertSecondsIntoHour
    }
    
    // 本日のポモドーロ時間
    func todayTimeRecord() -> Double {
        let convertSecondsIntoHour = round(Double(TimerModel.timerModel.timerMoved) / Double(oneHourSeconds) * 10) / 10
        return convertSecondsIntoHour
    }
    
    // 最近7日間のポモドーロ時間
    func recentlySevenDaysTimeRecord() -> Double {
        addingMultipleData = 0
        for i in 1...7 {
            addingMultipleData +=  Int(GraphDataModel.graphDataModel.currentMonthData[Int(DateModel.dateModel.todayDate())! - i]["time"]!)!
        }
        let convertSecondsIntoHour = round(Double(addingMultipleData) / Double(oneHourSeconds) * 10) / 10
        return convertSecondsIntoHour
    }
    
    // 今月のポモドーロ時間
    func currentTimeRecord() -> Double {
        addingMultipleData = 0
        for i in 0...GraphDataModel.graphDataModel.currentMonthData.count - 1 {
            addingMultipleData += Int(GraphDataModel.graphDataModel.currentMonthData[i]["time"]!)!
        }
        let convertSecondsIntoHour = round(Double(addingMultipleData) / Double(oneHourSeconds) * 10) / 10
        return convertSecondsIntoHour
    }
    
    // 1日のポモドーロ時間の平均
    func dailyTimeAverageRecord() -> Double {
        addingMultipleData = 0
        for i in 0...Int(DateModel.dateModel.todayDate())! - 1 {
            addingMultipleData += Int(GraphDataModel.graphDataModel.currentMonthData[i]["time"]!)!
        }
        let calcDailyTimeAverageRecord = addingMultipleData / Int(DateModel.dateModel.todayDate())!
        let convertSecondsIntoHour = round(Double(calcDailyTimeAverageRecord) / Double(oneHourSeconds) * 10) / 10
        return convertSecondsIntoHour
    }
    
    // 最近3日間のポモドーロ時間の平均
    func recentlyThreeDaysTimeAverageRecord() -> Double {
        addingMultipleData = 0
        let threeDays = 3
        for i in 1...3 {
            addingMultipleData +=  Int(GraphDataModel.graphDataModel.currentMonthData[Int(DateModel.dateModel.todayDate())! - i]["time"]!)!
        }
        let calcDailyTimeAverageRecord = addingMultipleData / threeDays
        let convertSecondsIntoHour = round(Double(calcDailyTimeAverageRecord) / Double(oneHourSeconds) * 10) / 10
        return convertSecondsIntoHour
    }
    
    // 最近7日間のポモドーロ時間の平均
    func recentlySevenDaysTimeAverageRecord() -> Double {
        addingMultipleData = 0
        let sevenDays = 7
        for i in 1...7 {
            addingMultipleData +=  Int(GraphDataModel.graphDataModel.currentMonthData[Int(DateModel.dateModel.todayDate())! - i]["time"]!)!
        }
        let calcDailyTimeAverageRecord = addingMultipleData / sevenDays
        let convertSecondsIntoHour = round(Double(calcDailyTimeAverageRecord) / Double(oneHourSeconds) * 10) / 10
        return convertSecondsIntoHour
    }
}
