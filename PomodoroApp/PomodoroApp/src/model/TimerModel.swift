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
    
    private (set) internal var minutes: Int = 0
    private (set) internal var seconds: Int = 0
    private (set) internal var limit = 1
    private (set) internal var restLimit = 1
    private (set) internal var longRestLimit = 1
    private (set) internal var whileLongRestLimit = 2
    private (set) internal var countPomodoroTime = 0
    internal var isPomodoroTime = true
    
    // タイマーセット
    func setUpTimer() {
        if isPomodoroTime {
            minutes = limit
        } else if whileLongRestLimit == countPomodoroTime && !isPomodoroTime {
            minutes = longRestLimit
        } else {
            minutes = restLimit
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
            // ポモドーロタイマー終了時、countPomodoroTimeを+1する
            if isPomodoroTime {
                countPomodoroTime += 1
            }
            isPomodoroTime = !isPomodoroTime
        }
    }
    
    // 長いタイマーカウントリセット
    func countPomodoroTimeReset() {
        countPomodoroTime = 0
    }
}
