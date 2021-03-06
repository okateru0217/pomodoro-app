//
//  ViewController.swift
//  PomodoroApp
//
//  Created by 岡澤輝明 on 2021/03/31.
//

import UIKit
import MBCircularProgressBar
import Instructions

final class ViewController: UIViewController {
    public static let viewController = ViewController()
    
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var secondsLabel: UILabel!
    @IBOutlet weak var timerCircle: MBCircularProgressBarView!
    @IBOutlet weak var operationTimerButton: UIButton!
    @IBOutlet weak var cancelTimerButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    private var timer = Timer()
    private let pomodoroTimerColor = "FE6348"
    private let restTimerColor = "1BD1AE"
    private let longRestTimerColor = "4C6CB3"
    private var isFirstLaunch = false
    let userDefaults = UserDefaults.standard
    
    private let coachMarksController = CoachMarksController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TimerModel.timerModel.setTimerUserDefaults()
        AlarmSoundModel.alarmSoundModel.setAlarmUserDefaults()
        timerAppearance()
        SceneDelegate.sceneDelegate.setUpMovingTimer()
        GraphDataModel.graphDataModel.addSecondsData()
        coachMarksControllerDelegate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        timerAppearance()
        cancelTimer((Any).self)
        tutorialExecution()
    }
    
    @IBAction func transitionSetting(_ sender: Any) {
        self.performSegue(withIdentifier: "toSetting", sender: nil)
    }
    
    @IBAction func transitionRecord(_ sender: Any) {
        self.performSegue(withIdentifier: "toRecord", sender: nil)
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
        timer.invalidate()
        setUpTimerLabel()
        TimerModel.timerModel.revertPomodoroTimer()
        timerCircle.value = 0
        timerAppearance()
        switchCancelButtonEnabled()
        SceneDelegate.sceneDelegate.setUpMovingTimer()
    }
}

// タイマーの見た目に関する処理
private extension ViewController {
    func timerAppearance() {
        switch TimerModel.TimerStatus(rawValue: TimerModel.timerModel.timerStatusDiscriminant) {
        case .pomodoroTimer:
            timerScreenAppearance(timerColor: pomodoroTimerColor)
            timerMinutesDisplay(setLimit: TimerModel.timerModel.limit)
            timerCircleAppearance(timerColor: pomodoroTimerColor)
            timerStartButtonAppearance(setStartTitle: "開始", timerColor: pomodoroTimerColor)
            timerCancelButtonAppearance(setCancelTitle: "キャンセル", timerColor: pomodoroTimerColor)
        case .restTimer:
            timerScreenAppearance(timerColor: restTimerColor)
            timerMinutesDisplay(setLimit: TimerModel.timerModel.restLimit)
            timerCircleAppearance(timerColor: restTimerColor)
            timerStartButtonAppearance(setStartTitle: "休憩する", timerColor: restTimerColor)
            timerCancelButtonAppearance(setCancelTitle: "休憩終了", timerColor: restTimerColor)
        case .longRestTimer:
            timerScreenAppearance(timerColor: longRestTimerColor)
            timerMinutesDisplay(setLimit: TimerModel.timerModel.longRestLimit)
            timerCircleAppearance(timerColor: longRestTimerColor)
            timerStartButtonAppearance(setStartTitle: "休憩する", timerColor: longRestTimerColor)
            timerCancelButtonAppearance(setCancelTitle: "休憩終了", timerColor: longRestTimerColor)
        default: break
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
        switch TimerModel.TimerStatus(rawValue: TimerModel.timerModel.timerStatusDiscriminant) {
        case .pomodoroTimer:
            cancelTimerButton.setTitle(setCancelTitle, for: .normal)
            cancelTimerButton.setTitleColor(UIColor(hex: timerColor, alpha: 0.75), for: .normal)
            cancelTimerButton.backgroundColor = UIColor(hex: "FFFFFF", alpha: 0.75)
            cancelTimerButton.isEnabled = false
        case .restTimer, .longRestTimer:
            cancelTimerButton.setTitle(setCancelTitle, for: .normal)
            cancelTimerButton.setTitleColor(UIColor(hex: timerColor), for: .normal)
            cancelTimerButton.backgroundColor = UIColor(hex: "FFFFFF")
            cancelTimerButton.isEnabled = true
        default: break
        }
    }
}

// ボタンの表示によって処理を変える
extension ViewController {
    func switchOperationTimerButtonStatus() {
        switch OperationTimerButtonStatus(rawValue: operationTimerButton.currentTitle!) {
        case .start, .rest:
            SceneDelegate.sceneDelegate.judgeMovingTimer(timerStatus: operationTimerButton.currentTitle!)
            TimerModel.timerModel.setUpTimer()
            minutesLabel.text = String(TimerModel.timerModel.minutes)
            secondsLabel.text = String("0\(TimerModel.timerModel.seconds)")
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.updateDisplayTimer), userInfo: nil, repeats: true)
            operationTimerButton.setTitle("一時停止", for: .normal)
        case .restart:
            SceneDelegate.sceneDelegate.judgeMovingTimer(timerStatus: operationTimerButton.currentTitle!)
            timer.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.updateDisplayTimer), userInfo: nil, repeats: true)
            operationTimerButton.setTitle("一時停止", for: .normal)
        case .suspend:
            SceneDelegate.sceneDelegate.judgeMovingTimer(timerStatus: operationTimerButton.currentTitle!)
            timer.invalidate()
            operationTimerButton.setTitle("再開", for: .normal)
        default: break
        }
    }
    
    // タイマー操作ボタンの表示によってキャンセルボタンの見た目を変更する
    func switchCancelButtonEnabled() {
        let operationStatus = OperationTimerButtonStatus(rawValue: operationTimerButton.currentTitle!)
        switch TimerModel.TimerStatus(rawValue: TimerModel.timerModel.timerStatusDiscriminant) {
        case .pomodoroTimer:
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
        case .restTimer:
            cancelTimerButton.isEnabled = true
            cancelTimerButton.setTitleColor(UIColor(hex: restTimerColor), for: .normal)
            cancelTimerButton.backgroundColor = UIColor(hex: "FFFFFF")
        case .longRestTimer:
            cancelTimerButton.isEnabled = true
            cancelTimerButton.setTitleColor(UIColor(hex: longRestTimerColor), for: .normal)
            cancelTimerButton.backgroundColor = UIColor(hex: "FFFFFF")
        default: break
        }
    }
}
    
// タイマー動作関連
extension ViewController {
    // タイマーを動かす処理
    @objc func updateDisplayTimer() {
        TimerModel.timerModel.updateTimer()
        if TimerModel.timerModel.minutes == 0 && TimerModel.timerModel.seconds == 0 || TimerModel.timerModel.minutes < 0 {
            SceneDelegate.sceneDelegate.judgeMovingTimer(timerStatus: operationTimerButton.currentTitle!)
            switchCancelButtonEnabled()
            timer.invalidate()
            if TimerModel.timerModel.skipRestTimer {
                TimerModel.timerModel.revertPomodoroTimer()
            }
            setUpTimerLabel()
            timerCircle.value = 0
            timerAppearance()
        }
        // 秒数が10未満の表示を2桁の0埋めにする
        let isSecondsMoreTen = TimerModel.timerModel.seconds < 10
        minutesLabel.text = String(TimerModel.timerModel.minutes)
        secondsLabel.text = isSecondsMoreTen ? String("0\(TimerModel.timerModel.seconds)") : String(TimerModel.timerModel.seconds)
        progressTimerCircle()
    }
    
    // タイマーに分数, 秒数をセットする
    func setUpTimerLabel() {
        TimerModel.timerModel.setUpTimer()
        minutesLabel.text = String(TimerModel.timerModel.minutes)
        secondsLabel.text = String("0\(TimerModel.timerModel.seconds)")
    }
    
    // タイマーの種類に応じて、プログレスバーの表示を変更する
    func progressTimerCircle() {
        switch TimerModel.TimerStatus(rawValue: TimerModel.timerModel.timerStatusDiscriminant) {
        case .pomodoroTimer:
            progressTimerCircleTurn(timerLimitStatus: TimerModel.timerModel.limit)
        case .restTimer:
            progressTimerCircleTurn(timerLimitStatus: TimerModel.timerModel.restLimit)
        case .longRestTimer:
            progressTimerCircleTurn(timerLimitStatus: TimerModel.timerModel.longRestLimit)
        default: break
        }
    }
    
    // プログレスバーの動き
    func progressTimerCircleTurn(timerLimitStatus: Int) {
        let oneMinutesSeconds = 60
        timerCircle.maxValue = CGFloat(timerLimitStatus * oneMinutesSeconds)
        timerCircle.value = CGFloat(timerCircle.maxValue - CGFloat((TimerModel.timerModel.minutes * oneMinutesSeconds) + TimerModel.timerModel.seconds))
    }
}

extension ViewController: CoachMarksControllerDataSource, CoachMarksControllerDelegate {
    func tutorialExecution() {
        isFirstLaunch = userDefaults.bool(forKey: "isFirstLaunch")
        if isFirstLaunch {
            isFirstLaunch = userDefaults.bool(forKey: "isFirstLaunch")
        }
        if !isFirstLaunch {
            isFirstLaunch = !isFirstLaunch
            userDefaults.set(isFirstLaunch, forKey: "isFirstLaunch")
            self.coachMarksController.start(in: .currentWindow(of: self))
        }
    }
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: (UIView & CoachMarkBodyView), arrowView: (UIView & CoachMarkArrowView)?) {
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(
            withArrow: true,
            arrowOrientation: coachMark.arrowOrientation
        )
        switch index {
            case 0:
                coachViews.bodyView.hintLabel.text = "開始ボタンからすぐにタイマーをスタートすることができます"
                coachViews.bodyView.nextLabel.text = "OK!"
            case 1:
                coachViews.bodyView.hintLabel.text = "記録画面です\nあなたの頑張りを見ることができます"
                coachViews.bodyView.nextLabel.text = "OK!"
            case 2:
                coachViews.bodyView.hintLabel.text = "設定画面です\nタイマーやアラームの設定ができます\nアラームを鳴らすにはユーザー通知の許可が必要です"
                coachViews.bodyView.nextLabel.text = "OK!"
        case 3:
            coachViews.bodyView.hintLabel.text = "こちらのボタンを押して、ユーザー通知の許可を完了しましょう！"
            coachViews.bodyView.nextLabel.text = "OK!"
            default:break
        }
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
        let highlightViews: Array<UIView> = [operationTimerButton, recordButton, settingButton, settingButton]
        return coachMarksController.helper.makeCoachMark(for: highlightViews[index])
    }
    
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 4
    }
    
    func coachMarksControllerDelegate() {
        self.coachMarksController.dataSource = self
    }
}
