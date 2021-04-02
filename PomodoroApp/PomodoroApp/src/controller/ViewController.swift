//
//  ViewController.swift
//  PomodoroApp
//
//  Created by 岡澤輝明 on 2021/03/31.
//

import UIKit
import MBCircularProgressBar

class ViewController: UIViewController {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timerCircle: MBCircularProgressBarView!
    @IBOutlet weak var startButtonLabel: UIButton!
    @IBOutlet weak var cancelButtonLabel: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timerScreenAppearance()
        timerCircleAppearance()
        startButtonAppearance()
        cancelButtonAppearance()
        // Do any additional setup after loading the view.
    }
    private let pomodoroTimerColor = "FE6348"
    
    // 画面の外観
    func timerScreenAppearance() {
        self.view.backgroundColor = UIColor(hex: pomodoroTimerColor)
    }
    
    // 円形プログレスバーの外観
    func timerCircleAppearance() {
        timerCircle.backgroundColor = UIColor(hex: pomodoroTimerColor)
        timerCircle.progressColor = UIColor(hex: pomodoroTimerColor)
        timerCircle.progressStrokeColor = UIColor(hex: pomodoroTimerColor)
    }
    
    // スタートボタンの外観
    func startButtonAppearance() {
        startButtonLabel.setTitleColor(UIColor(hex: pomodoroTimerColor), for: .normal)
    }
    
    // キャンセルボタンの外観
    func cancelButtonAppearance() {
        cancelButtonLabel.setTitleColor(UIColor(hex: pomodoroTimerColor), for: .normal)
    }
}
