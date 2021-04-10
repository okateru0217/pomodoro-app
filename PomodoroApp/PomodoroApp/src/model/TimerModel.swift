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
    private (set) internal var whileLongRestLimit = 1
    internal var isPomodoroTime = true
    
    // タイマーセット
    func setUpTimer() {
        minutes = isPomodoroTime ? limit : restLimit
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
            isPomodoroTime = !isPomodoroTime
        }
    }
}
