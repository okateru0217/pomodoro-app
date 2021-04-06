//
//  ViewController.swift
//  PomodoroApp
//
//  Created by 岡澤輝明 on 2021/03/31.
//

import UIKit
import MBCircularProgressBar

final class ViewController: UIViewController {
    public static let viewController = ViewController()
    
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var secondsLabel: UILabel!
    @IBOutlet weak var timerCircle: MBCircularProgressBarView!
    @IBOutlet weak var operationTimerButton: UIButton!
    @IBOutlet weak var cancelTimerButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    
    private var timer = Timer()
    private let pomodoroTimerColor = "FE6348"
    private let restTimerColor = "1BD1AE"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timerAppearance()
        // Do any additional setup after loading the view.
    }
    
    enum OperationTimerButtonStatus: String {
        case start = "開始"
        case restart = "再開"
        case suspend = "一時停止"
        case rest = "休憩する"
    }
    @IBAction func operationTimer(_ sender: Any) {
        switchOperationTimerButtonStatus()
        switchCancelButtonEnabled()
    }
    
    @IBAction func cancelTimer(_ sender: Any) {
        TimerModel.timerModel.isPomodoroTime = true
        timer.invalidate()
        setUpTimerLabel()
        timerCircle.value = 0
        timerAppearance()
        switchTimer()
        switchCancelButtonEnabled()
    }
}

// タイマーの見た目に関する処理
private extension ViewController {
    func timerAppearance() {
        // ポモドーロタイマーの画面の外観
        if TimerModel.timerModel.isPomodoroTime {
            timerScreenAppearance(timerColor: pomodoroTimerColor)
            timerMinutesDisplay(setLimit: TimerModel.timerModel.limit)
            timerCircleAppearance(timerColor: pomodoroTimerColor)
            timerStartButtonAppearance(setStartTitle: "開始", timerColor: pomodoroTimerColor)
            timerCancelButtonAppearance(setCancelTitle: "キャンセル", timerColor: pomodoroTimerColor)
        // 休憩タイマーの外観
        } else {
            timerScreenAppearance(timerColor: restTimerColor)
            timerMinutesDisplay(setLimit: TimerModel.timerModel.restLimit)
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
        if TimerModel.timerModel.isPomodoroTime {
            cancelTimerButton.setTitle(setCancelTitle, for: .normal)
            cancelTimerButton.setTitleColor(UIColor(hex: timerColor, alpha: 0.75), for: .normal)
            cancelTimerButton.backgroundColor = UIColor(hex: "FFFFFF", alpha: 0.75)
            cancelTimerButton.isEnabled = false
        } else {
            cancelTimerButton.setTitle(setCancelTitle, for: .normal)
            cancelTimerButton.setTitleColor(UIColor(hex: timerColor), for: .normal)
            cancelTimerButton.backgroundColor = UIColor(hex: "FFFFFF")
            cancelTimerButton.isEnabled = true
        }
    }
}

// ボタンの表示によって処理を変える
extension ViewController {
    // タイマー操作ボタンの表示によって処理を変える
    func switchOperationTimerButtonStatus() {
        let operationStatus = OperationTimerButtonStatus(rawValue: operationTimerButton.currentTitle!)
        switch operationStatus {
        case .start, .rest:
            setUpTimerLabel()
            timer.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.updateTimer), userInfo: nil, repeats: true)
            operationTimerButton.setTitle("一時停止", for: .normal)
        case .restart:
            timer.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.updateTimer), userInfo: nil, repeats: true)
            operationTimerButton.setTitle("一時停止", for: .normal)
        case .suspend:
            suspendSetUpTimer()
            timer.invalidate()
            operationTimerButton.setTitle("再開", for: .normal)
        default: break
        }
    }
    // タイマー操作ボタンの表示によってキャンセルボタンの見た目を変更する
    func switchCancelButtonEnabled() {
        let operationStatus = OperationTimerButtonStatus(rawValue: operationTimerButton.currentTitle!)
        if TimerModel.timerModel.isPomodoroTime {
            switch operationStatus {
            case .start:
                cancelTimerButton.isEnabled = false
                cancelTimerButton.setTitleColor(UIColor(hex: pomodoroTimerColor, alpha: 0.75), for: .normal)
                cancelTimerButton.backgroundColor = UIColor(hex: "FFFFFF", alpha: 0.75)
            case .restart, .suspend:
                cancelTimerButton.isEnabled = true
                cancelTimerButton.setTitleColor(UIColor(hex: pomodoroTimerColor), for: .normal)
                cancelTimerButton.backgroundColor = UIColor(hex: "FFFFFF")
            default: break
            }
        } else {
            cancelTimerButton.isEnabled = true
            cancelTimerButton.setTitleColor(UIColor(hex: restTimerColor), for: .normal)
            cancelTimerButton.backgroundColor = UIColor(hex: "FFFFFF")
        }
    }
}

// タイマー表示関連
extension ViewController {
    // タイマーに分数, 秒数をセットする
    func setUpTimerLabel() {
        TimerModel.timerModel.setUpTimer()
        minutesLabel.text = String(TimerModel.timerModel.minutes)
        secondsLabel.text = String("0\(TimerModel.timerModel.seconds)")
    }
    // 一時停止時のタイムを秒数ラベルへ反映
    func suspendSetUpTimer() {
        let suspendMinutes = TimerModel.timerModel.minutes
        let suspendSeconds = TimerModel.timerModel.seconds
        let isSuspendSecondsMoreTen = suspendSeconds < 10
        minutesLabel.text = String(suspendMinutes)
        secondsLabel.text = isSuspendSecondsMoreTen ? String("0\(suspendSeconds)") : String(suspendSeconds)
    }
    
    // タイマーの時間に応じて、プログレスバーの表示を変更する
    func progressTimerCircle() {
        let oneMinutesSeconds = 60
        timerCircle.maxValue = CGFloat(TimerModel.timerModel.limit * oneMinutesSeconds)
        timerCircle.value = CGFloat(timerCircle.maxValue - CGFloat((TimerModel.timerModel.minutes * oneMinutesSeconds) + TimerModel.timerModel.seconds))
    }
    // タイマーを動かす処理
    @objc func updateTimer() {
        TimerModel.timerModel.updateTimer()
        if TimerModel.timerModel.minutes == 0 && TimerModel.timerModel.seconds == 0 {
            switchCancelButtonEnabled()
            switchTimer()
        }
        // 秒数が10未満の表示を2桁の0埋めにする
        let isSecondsMoreTen = TimerModel.timerModel.seconds < 10
        minutesLabel.text = String(TimerModel.timerModel.minutes)
        secondsLabel.text = isSecondsMoreTen ? String("0\(TimerModel.timerModel.seconds)") : String(TimerModel.timerModel.seconds)
        progressTimerCircle()
    }
    // タイマーが0になった時に呼び出される処理
    func switchTimer() {
        timer.invalidate()
        setUpTimerLabel()
        timerCircle.value = 0
        timerAppearance()
    }
}
