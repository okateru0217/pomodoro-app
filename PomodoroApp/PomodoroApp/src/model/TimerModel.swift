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
    
    // タイマー画面にセットする用
    private (set) internal var minutes: Int = 0
    private (set) internal var seconds: Int = 0
    // ポモドーロ, 短い休憩, 長い休憩時間のminutes
    private (set) internal var limit = 25
    private (set) internal var restLimit = 5
    private (set) internal var longRestLimit = 20
    // 長い休憩に入るまでに必要なポモドーロの回数
    // ポモドーロの回数を数えるカウント
    // タイマーの種類を判断するための変数
    // 休憩をスキップする
    private (set) internal var whileLongRestLimit = 3
    private (set) internal var countPomodoroTime = 0
    private (set) internal var timerStatusDiscriminant = 1
    private (set) internal var skipRestTimer = false
    // 1秒毎に秒数を数える
    private (set) internal var timerMoved: Int = 0
    private (set) internal var todayDate: String?
    private (set) internal var lastLoginDate: String?
    // 累計のポモドーロタイム
    private (set) internal var totalPomodoroTime: Int = 0
    
    let userDefaults = UserDefaults.standard
    
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
        countSeconds()
        // タイマー終了時の処理
        if minutes == 0 && seconds == 0 {
            AlarmSoundModel.alarmSoundModel.soundAlarm()
            switch TimerStatus(rawValue: timerStatusDiscriminant) {
            case .pomodoroTimer:
                if skipRestTimer { return }
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
        // バックグラウンドでタイマーが0:00になった時の処理
        } else if minutes < 0 {
            switch TimerStatus(rawValue: timerStatusDiscriminant) {
            case .pomodoroTimer:
                if skipRestTimer { return }
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
    
    // 1秒毎に秒数の記録をとる
    func countSeconds() {
        switch TimerModel.TimerStatus(rawValue: TimerModel.timerModel.timerStatusDiscriminant) {
        case .pomodoroTimer:
            timerMoved += 1
            userDefaults.set(TimerModel.timerModel.timerMoved, forKey: "timerMoved")
            totalPomodoroTime += 1
            userDefaults.set(TimerModel.timerModel.totalPomodoroTime, forKey: "totalPomodoroTime")
        default: break
        }
    }
    
    // バックグラウンド時の1秒毎の秒数の記録をとる
    func backgroundCountSeconds(backgroundTime: Int) {
        let timeLag = 3
        let setLimit = TimerModel.timerModel.limit * 60 + timeLag
        switch TimerModel.TimerStatus(rawValue: TimerModel.timerModel.timerStatusDiscriminant) {
        case .pomodoroTimer:
            if setLimit < backgroundTime {
                let beforeBackgroundMinutes = TimerModel.timerModel.minutes * 60
                let beforeBackgroundSeconds = beforeBackgroundMinutes + TimerModel.timerModel.seconds
                timerMoved += beforeBackgroundSeconds
                userDefaults.set(TimerModel.timerModel.timerMoved, forKey: "timerMoved")
                totalPomodoroTime += beforeBackgroundSeconds
                userDefaults.set(TimerModel.timerModel.totalPomodoroTime, forKey: "totalPomodoroTime")
            } else {
                timerMoved += backgroundTime
                userDefaults.set(TimerModel.timerModel.timerMoved, forKey: "timerMoved")
                totalPomodoroTime +=  backgroundTime
                userDefaults.set(TimerModel.timerModel.totalPomodoroTime, forKey: "totalPomodoroTime")
            }
        default: break
        }
    }
    
    // キャンセルボタン押下した時に、ポモドーロタイマーに戻す
    func revertPomodoroTimer() {
        if timerStatusDiscriminant != 0 {
            countPomodoroTime = 0
        }
        timerStatusDiscriminant = 1
    }
    
    // バックグラウンドでもタイマーが動くようにする
    func moveTimerBackground(backgroundTime: Int) {
        var backgroundMinutes = 0
        var backgroundSeconds = 0
        let timeLag = 3
        switch backgroundTime {
        case 60...:
            let divideInSixty = backgroundTime / 60
            let sixtyMultiple = divideInSixty * 60
            backgroundMinutes = backgroundTime / sixtyMultiple
            backgroundSeconds = backgroundTime % sixtyMultiple
            if backgroundSeconds > seconds {
                minutes -= backgroundMinutes
                let backgroundDiff = backgroundSeconds - seconds
                seconds = 60 - backgroundDiff
                minutes -= 1
            } else {
                minutes -= backgroundMinutes
                if backgroundSeconds > timeLag {
                    seconds -= backgroundSeconds - timeLag
                }
            }
        default:
            backgroundSeconds = backgroundTime
            if backgroundSeconds > seconds {
                minutes -= 1
                let backgroundDiff = backgroundSeconds - seconds
                seconds = 60 - backgroundDiff
            } else {
                if backgroundSeconds > timeLag {
                    seconds -= backgroundSeconds - timeLag
                }
            }
        }
    }
    
    // ポモドーロの時間を変更
    func changeTimerLimit(time: String, timerType: String) {
        var changeTime = time
        switch timerType {
        case "pomodoroTime", "restTime", "longRestTime":
            if let removeQuantifier = changeTime.range(of: "分間") {
                changeTime.removeSubrange(removeQuantifier)
            }
            switch timerType {
            case "pomodoroTime":
                limit = Int(changeTime)!
                self.userDefaults.set(limit, forKey: "limit")
            case "restTime":
                restLimit = Int(changeTime)!
                self.userDefaults.set(restLimit, forKey: "restLimit")
            case "longRestTime":
                longRestLimit = Int(changeTime)!
                self.userDefaults.set(longRestLimit, forKey: "longRestLimit")
            default: break
            }
        case "longRestTimeInterval":
            if let removeQuantifier = changeTime.range(of: "ポモドーロ") {
                changeTime.removeSubrange(removeQuantifier)
            }
            whileLongRestLimit = Int(changeTime)!
            self.userDefaults.set(whileLongRestLimit, forKey: "whileLongRestLimit")
        default: break
        }
    }
    
    // 設定のタイマースタートセクションの変更を感知する
    func changeTimerAutomatically() {
        skipRestTimer = !skipRestTimer
        userDefaults.set(skipRestTimer, forKey: "skipRestTimer")
    }
    
    // 日付を跨いだ時に、timerMovedをリセットする
    func resetTimerMoved() {
        todayDate = DateModel.dateModel.todayFullDate()
        if todayDate != lastLoginDate {
            timerMoved = 0
            self.userDefaults.set(timerMoved, forKey: "timerMoved")
            lastLoginDate = DateModel.dateModel.todayFullDate()
            self.userDefaults.set(lastLoginDate, forKey: "lastLoginDate")
        }
    }
    
    // userDefaults呼び出し
    func setTimerUserDefaults() {
        limit = userDefaults.integer(forKey: "limit")
        restLimit = userDefaults.integer(forKey: "restLimit")
        longRestLimit = userDefaults.integer(forKey: "longRestLimit")
        whileLongRestLimit = userDefaults.integer(forKey: "whileLongRestLimit")
        skipRestTimer = userDefaults.bool(forKey: "skipRestTimer")
        timerMoved = userDefaults.integer(forKey: "timerMoved")
        totalPomodoroTime = userDefaults.integer(forKey: "totalPomodoroTime")
        lastLoginDate = userDefaults.string(forKey: "lastLoginDate")
        // 初回起動時の値
        if limit == 0 {
            limit = 25
        }
        if restLimit == 0 {
            restLimit = 5
        }
        if longRestLimit == 0 {
            longRestLimit = 20
        }
        if whileLongRestLimit == 0 {
            whileLongRestLimit = 3
        }
    }
}
