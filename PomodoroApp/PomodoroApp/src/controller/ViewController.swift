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
    
    internal var timer = Timer()
    internal var seconds: Int = 0
    internal var minutes: Int = 0
    internal var limit = 1
    internal var restLimit = 1
    internal let pomodoroTimerColor = "FE6348"
    internal let restTimerColor = "1BD1AE"
    internal var isPomodoroTime = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pomodoroTimerAppearance()
        // Do any additional setup after loading the view.
    }
    
    // ポモドーロタイマーの画面の外観
    func pomodoroTimerAppearance() {
        // 画面の外観
        func timerScreenAppearance() {
            self.view.backgroundColor = UIColor(hex: pomodoroTimerColor)
        }
        
        // タイマーの分数表示
        func minutesDisplay() {
            minutesLabel.text = String(limit)
        }
        
        // 円形プログレスバーの外観
        func timerCircleAppearance() {
            timerCircle.backgroundColor = UIColor(hex: pomodoroTimerColor)
            timerCircle.progressColor = UIColor(hex: pomodoroTimerColor)
            timerCircle.progressStrokeColor = UIColor(hex: pomodoroTimerColor)
        }
        
        // スタートボタンの外観
        func startButtonAppearance() {
            operationTimerButton.setTitle("開始", for: .normal)
            operationTimerButton.setTitleColor(UIColor(hex: pomodoroTimerColor), for: .normal)
        }
        
        // キャンセルボタンの外観
        func cancelButtonAppearance() {
            cancelTimerButton.setTitle("キャンセル", for: .normal)
            cancelTimerButton.setTitleColor(UIColor(hex: pomodoroTimerColor, alpha: 0.75), for: .normal)
            cancelTimerButton.backgroundColor = UIColor(hex: "FFFFFF", alpha: 0.75)
            cancelTimerButton.isEnabled = false
        }
        
        timerScreenAppearance()
        minutesDisplay()
        timerCircleAppearance()
        startButtonAppearance()
        cancelButtonAppearance()
    }
    
    // 休憩時間の画面の外観
    func restTimerAppearance() {
        // 画面の外観
        func timerScreenAppearance() {
            self.view.backgroundColor = UIColor(hex: restTimerColor)
        }
        
        // タイマーの分数表示
        func minutesDisplay() {
            minutesLabel.text = String(restLimit)
        }
        
        // 円形プログレスバーの外観
        func timerCircleAppearance() {
            timerCircle.backgroundColor = UIColor(hex: restTimerColor)
            timerCircle.progressColor = UIColor(hex: restTimerColor)
            timerCircle.progressStrokeColor = UIColor(hex: restTimerColor)
        }
        
        // スタートボタンの外観
        func startButtonAppearance() {
            operationTimerButton.setTitle("休憩する", for: .normal)
            operationTimerButton.setTitleColor(UIColor(hex: restTimerColor), for: .normal)
        }
        
        // キャンセルボタンの外観
        func cancelButtonAppearance() {
            cancelTimerButton.setTitle("休憩終了", for: .normal)
            cancelTimerButton.setTitleColor(UIColor(hex: restTimerColor, alpha: 0.75), for: .normal)
            cancelTimerButton.backgroundColor = UIColor(hex: "FFFFFF", alpha: 0.75)
            cancelTimerButton.isEnabled = false
        }
        
        timerScreenAppearance()
        minutesDisplay()
        timerCircleAppearance()
        startButtonAppearance()
        cancelButtonAppearance()
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
        pomodoroTimerAppearance()
        switchTimer()
        switchCancelButtonEnabled()
    }
    
}
