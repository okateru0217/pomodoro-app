//
//  TimerController.swift
//  PomodoroApp
//
//  Created by 岡澤輝明 on 2021/04/02.
//

import UIKit
import Foundation

// タイマー表示関連
extension ViewController {
    // タイマーに分数, 秒数をセットする
    func setUpTimer() {
        minutes = isPomodoroTime ? limit : restLimit
        seconds = 0
        minutesLabel.text = String(minutes)
        secondsLabel.text = String("0\(seconds)")
    }
    
    // 一時停止時のタイムを秒数ラベルへ反映
    func suspendSetUpTimer() {
        let suspendMinutes = minutes
        let suspendSeconds = seconds
        let isSuspendSecondsMoreTen = suspendSeconds < 10
        minutesLabel.text = String(suspendMinutes)
        secondsLabel.text = isSuspendSecondsMoreTen ? String("0\(suspendSeconds)") : String(suspendSeconds)
    }
        
    // タイマーの時間に応じて、プログレスバーの表示を変更する
    func progressTimerCircle() {
        let oneMinutesSeconds = 60
        timerCircle.maxValue = CGFloat(limit * oneMinutesSeconds)
        timerCircle.value = CGFloat(timerCircle.maxValue - CGFloat((minutes * oneMinutesSeconds) + seconds))
    }
    
}


// タイマー処理関連
extension ViewController {
    // タイマーを動かす処理
    @objc func updateTimer() {
        seconds -= 1
        // 秒数が-1以下の時、59に戻す
        if seconds <= -1 {
            minutes -= 1
            seconds = 59
        }
        // タイマー終了時の処理
        if minutes == 0 && seconds == 0 {
            isPomodoroTime = !isPomodoroTime
            switchTimer()
            switchCancelButtonEnabled()
        }
        // 秒数が10未満の表示を2桁の0埋めにする
        let isSecondsMoreTen = seconds < 10
        minutesLabel.text = String(minutes)
        secondsLabel.text = isSecondsMoreTen ? String("0\(seconds)") : String(seconds)
        progressTimerCircle()
    }
    
    // タイマーが0になった時に呼び出される処理
    func switchTimer() {
        timer.invalidate()
        setUpTimer()
        timerCircle.value = 0
        isPomodoroTime ? pomodoroTimerAppearance() : restTimerAppearance()
    }
    
    // operationTimerButtonのテキストに応じて、タイマーの処理を変更する
    func switchTimerProcess() {
        if operationTimerButton.currentTitle == "開始" || operationTimerButton.currentTitle == "休憩する" {
            setUpTimer()
            timer.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.updateTimer), userInfo: nil, repeats: true)
            operationTimerButton.setTitle("一時停止", for: .normal)
        } else if operationTimerButton.currentTitle == "一時停止" {
            suspendSetUpTimer()
            timer.invalidate()
            operationTimerButton.setTitle("再開", for: .normal)
        } else if operationTimerButton.currentTitle == "再開" {
            timer.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.updateTimer), userInfo: nil, repeats: true)
            operationTimerButton.setTitle("一時停止", for: .normal)
        }
    }
}


// キャンセルボタン関連
extension ViewController {
    // キャンセルボタンの押下可否判定
    func switchCancelButtonEnabled() {
        isPomodoroTime ? pomodoroCancelButtonAppearance() : restCancelButtonAppearance()
    }
    
    // ポモドーロタイマーのキャンセルボタン押下可否判定
    func pomodoroCancelButtonAppearance() {
        if operationTimerButton.currentTitle == "開始" {
            cancelTimerButton.isEnabled = false
            cancelTimerButton.setTitleColor(UIColor(hex: pomodoroTimerColor, alpha: 0.75), for: .normal)
            cancelTimerButton.backgroundColor = UIColor(hex: "FFFFFF", alpha: 0.75)
        } else {
            cancelTimerButton.isEnabled = true
            cancelTimerButton.setTitleColor(UIColor(hex: pomodoroTimerColor), for: .normal)
            cancelTimerButton.backgroundColor = UIColor(hex: "FFFFFF")
        }
    }
    
    // 休憩終了ボタンの外観
    func restCancelButtonAppearance() {
        cancelTimerButton.isEnabled = true
        cancelTimerButton.setTitleColor(UIColor(hex: restTimerColor), for: .normal)
        cancelTimerButton.backgroundColor = UIColor(hex: "FFFFFF")
    }
}
