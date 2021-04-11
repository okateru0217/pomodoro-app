//
//  TimerModel.swift
//  PomodoroApp
//
//  Created by 岡澤輝明 on 2021/04/06.
//

import UIKit
import Foundation

final class TimerModel {
    public static let timerModel = TimerModel()
    private init() {}
    
    enum TimerStatus: Int {
        case pomodoroTimer = 1
        case restTimer = 0
        case longRestTimer = 10
    }
    
    private (set) internal var minutes: Int = 0
    private (set) internal var seconds: Int = 0
    private (set) internal var limit = 1
    private (set) internal var restLimit = 1
    private (set) internal var longRestLimit = 2
    private (set) internal var whileLongRestLimit = 2
    private (set) internal var countPomodoroTime = 0
    private (set) internal var timerStatusDiscriminant = 1
    
    // タイマーセット
    @objc func setUpTimer() {
        switch TimerStatus(rawValue: timerStatusDiscriminant) {
        case .pomodoroTimer:
            minutes = limit
        case .restTimer:
            minutes = restLimit
        case .longRestTimer:
            minutes = longRestLimit
        default: break
        }
    seconds = 0
    }
    
    // タイマーを動かす処理
    func updateTimer() {
        seconds -= 1
        // 秒数が-1以下の時、59に戻す
        if seconds <= -1 {
            minutes -= 1
            seconds = 59
        }
        // タイマー終了時の処理
        if minutes == 0 && seconds == 0 {
            switch TimerStatus(rawValue: timerStatusDiscriminant) {
            case .pomodoroTimer:
                countPomodoroTime += 1
                // 短い休憩か長い休憩か判断する
                let isLongRestLimit = whileLongRestLimit == countPomodoroTime
                timerStatusDiscriminant = isLongRestLimit ? 10 : 0
            case .restTimer:
                timerStatusDiscriminant = 1
            case .longRestTimer:
                timerStatusDiscriminant = 1
                countPomodoroTime = 0
            default: break
            }
        }
    }
    
    // ポモドーロの時間を変更
    func changeTimerLimit(time: String, timerType: String) {
        var changeTime = time
        if timerType == "pomodoroTime" {
            if let removeQuantifier = changeTime.range(of: "分間") {
                changeTime.removeSubrange(removeQuantifier)
            }
            limit = Int(changeTime)!
        } else if timerType == "restTime" {
            if let removeQuantifier = changeTime.range(of: "分間") {
                changeTime.removeSubrange(removeQuantifier)
            }
            restLimit = Int(changeTime)!
        } else if timerType == "longRestTime" {
            if let removeQuantifier = changeTime.range(of: "分間") {
                changeTime.removeSubrange(removeQuantifier)
            }
            longRestLimit = Int(changeTime)!
        } else if timerType == "longRestTimeInterval" {
            if let removeQuantifier = changeTime.range(of: "ポモドーロ") {
                changeTime.removeSubrange(removeQuantifier)
            }
            whileLongRestLimit = Int(changeTime)!
        }
    }
    
    // キャンセルボタン押下した時に、ポモドーロタイマーに戻す
    func revertPomodoroTimer() {
        if timerStatusDiscriminant == 1 {
            countPomodoroTime = 0
        }
        timerStatusDiscriminant = 1
    }
}
