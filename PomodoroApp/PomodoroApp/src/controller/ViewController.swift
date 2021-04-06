//
//  ViewController.swift
//  PomodoroApp
//
//  Created by 岡澤輝明 on 2021/03/31.
//

import UIKit
import MBCircularProgressBar

class ViewController: UIViewController {
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var secondsLabel: UILabel!
    @IBOutlet weak var timerCircle: MBCircularProgressBarView!
    @IBOutlet weak var operationTimerButton: UIButton!
    @IBOutlet weak var cancelTimerButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    
    private var timer = Timer()
    private var seconds: Int = 0
    private var minutes: Int = 0
    private var limit = 1
    private var restLimit = 1
    private let pomodoroTimerColor = "FE6348"
    private let restTimerColor = "1BD1AE"
    private var isPomodoroTime = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timerAppearance()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func operationTimer(_ sender: Any) {
        switchTimerProcess()
        switchCancelButtonEnabled()
    }
    
    @IBAction func cancelTimer(_ sender: Any) {
        isPomodoroTime = true
        timer.invalidate()
        setUpTimer()
        timerCircle.value = 0
        timerAppearance()
        switchTimer()
        switchCancelButtonEnabled()
    }
}

// タイマーの見た目に関する処理
private extension ViewController {
    // ポモドーロタイマーの画面の外観
    func timerAppearance() {
        if isPomodoroTime {
            timerScreenAppearance(timerColor: pomodoroTimerColor)
            timerMinutesDisplay(setLimit: limit)
            timerCircleAppearance(timerColor: pomodoroTimerColor)
            timerStartButtonAppearance(setStartTitle: "開始", timerColor: pomodoroTimerColor)
            timerCancelButtonAppearance(setCancelTitle: "キャンセル", timerColor: pomodoroTimerColor)
        } else {
            timerScreenAppearance(timerColor: restTimerColor)
            timerMinutesDisplay(setLimit: restLimit)
            timerCircleAppearance(timerColor: restTimerColor)
            timerStartButtonAppearance(setStartTitle: "休憩する", timerColor: restTimerColor)
            timerCancelButtonAppearance(setCancelTitle: "休憩終了", timerColor: restTimerColor)
        }
    }
    // 画面の外観
    func timerScreenAppearance(timerColor: String) {
        self.view.backgroundColor = UIColor(hex: timerColor)
    }
    // タイマーの分数表示
    func timerMinutesDisplay(setLimit: Int) {
        minutesLabel.text = String(setLimit)
    }
    // 円形プログレスバーの外観
    func timerCircleAppearance(timerColor: String) {
        timerCircle.backgroundColor = UIColor(hex: timerColor)
        timerCircle.progressColor = UIColor(hex: timerColor)
        timerCircle.progressStrokeColor = UIColor(hex: timerColor)
    }
    // スタートボタンの外観
    func timerStartButtonAppearance(setStartTitle: String, timerColor: String) {
        operationTimerButton.setTitle(setStartTitle, for: .normal)
        operationTimerButton.setTitleColor(UIColor(hex: timerColor), for: .normal)
    }
    // キャンセルボタンの外観
    func timerCancelButtonAppearance(setCancelTitle: String, timerColor: String) {
        cancelTimerButton.setTitle(setCancelTitle, for: .normal)
        cancelTimerButton.setTitleColor(UIColor(hex: timerColor, alpha: 0.75), for: .normal)
        cancelTimerButton.backgroundColor = UIColor(hex: "FFFFFF", alpha: 0.75)
        cancelTimerButton.isEnabled = false
    }
}

// タイマー表示関連
private extension ViewController {
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
private extension ViewController {
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
        timerAppearance()
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
private extension ViewController {
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
