//
//  SettingViewController.swift
//  PomodoroApp
//
//  Created by 岡澤輝明 on 2021/04/09.
//

import UIKit
import Eureka

class SettingViewController: FormViewController {
    
    var backTimerScreenButton: UIBarButtonItem!
    
    // アラームの種類
    private (set) internal var alarmItem = ["なし", "ベル", "束の間の休息", "ほっとひといき", "エレガント", "タイトルコール", "ビリヤード", "肩の力をぬいて", "オルゴール", "おもちゃ", "朝", "夜", "会議所", "陽気なあさひ", "サンセットと黄昏", "学生", "水色の光", "草原", "百花繚乱"]
    private var appendCharacter: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarStopButton()
        timerSection()
        finishedTimerSection()
    }
    
    @objc func backTimerScreen (_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }

    // ナビゲーションボタンの生成
    func navigationBarStopButton() {
        backTimerScreenButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(backTimerScreen(_:)))
        self.navigationItem.leftBarButtonItems = [backTimerScreenButton]
    }
}

// 設定項目
extension SettingViewController {
    // タイマーセクション
    func timerSection() {
        form +++ Section("時間設定")
        // ポモドーロの時間
        <<< PickerInlineRow<String>("pomodoroTime"){
        $0.title = "ポモドーロの時間"
        $0.options = []
            for i in 1...300 {
                $0.options.append("\(i)分間")
            }
        $0.value = "\(String(TimerModel.timerModel.limit))分間"
        }
        .cellSetup({cell, row in
            self.tableView.separatorStyle = .none
        })
        .onChange({ pick in
            TimerModel.timerModel.changeTimerLimit(time: pick.value!, timerType: pick.tag!)
        })
        // 短い休憩の時間
        <<< PickerInlineRow<String>("restTime"){
        $0.title = "短い休憩の時間"
        $0.options = []
            for i in 1...300 {
                $0.options.append("\(i)分間")
            }
        $0.value = "\(String(TimerModel.timerModel.restLimit))分間"
        }
        .onChange({ pick in
            TimerModel.timerModel.changeTimerLimit(time: pick.value!, timerType: pick.tag!)
        })
        // 長い休憩の時間
        <<< PickerInlineRow<String>("longRestTime"){
        $0.title = "長い休憩の時間"
        $0.options = []
            for i in 1...300 {
                $0.options.append("\(i)分間")
            }
        $0.value = "\(String(TimerModel.timerModel.longRestLimit))分間"
        }
        .onChange({ pick in
            TimerModel.timerModel.changeTimerLimit(time: pick.value!, timerType: pick.tag!)
        })
        // 長い休憩の間隔
        <<< PickerInlineRow<String>("longRestTimeInterval"){
        $0.title = "長い休憩の間隔"
        $0.options = []
            for i in 1...100 {
                $0.options.append("\(i)ポモドーロ")
            }
        $0.value = "\(String(TimerModel.timerModel.whileLongRestLimit))ポモドーロ"
        }
        .onChange({ pick in
            TimerModel.timerModel.changeTimerLimit(time: pick.value!, timerType: pick.tag!)
        })
    }
    
    // タイマー終了時セクション
    func finishedTimerSection() {
        form +++ Section("タイマー終了時")
        // ポモドーロ終了時
        <<< PushRow<String>("finishedPomodoroTimer") {
            $0.title = "ポモドーロ終了時"
            $0.options = alarmItem
            $0.value = AlarmSoundModel.alarmSoundModel.selectPomodoroTimerSound
            $0.presentationMode = PresentationMode.show(controllerProvider: ControllerProvider.callback{return SelectorViewController(){_ in}}, onDismiss: nil)
        }
        .onPresent { form, selectorController in
                 selectorController.enableDeselection = false
        }
        .onChange({ alarm in
            AlarmSoundModel.alarmSoundModel.setFinishedTimerSound(alarmSoundType: alarm.value!, timerType: "pomodoro")
        })
        // 休憩終了時
        <<< PushRow<String>("finishedRestTimer") {
            $0.title = "休憩終了時"
            $0.options = alarmItem
            $0.value = AlarmSoundModel.alarmSoundModel.selectRestTimerSound
            $0.presentationMode = PresentationMode.show(controllerProvider: ControllerProvider.callback{return SelectorViewController(){_ in}}, onDismiss: nil)
        }
        .onPresent { form, selectorController in
                 selectorController.enableDeselection = false
        }
        .onChange({ alarm in
            AlarmSoundModel.alarmSoundModel.setFinishedTimerSound(alarmSoundType: alarm.value!, timerType: "rest")
        })
        // バイブレーション
        <<< SwitchRow("vibration") {
            $0.title = "バイブレーション"
            $0.baseValue = AlarmSoundModel.alarmSoundModel.isVibration ? true : false
        }
        .onChange({ pick in
            AlarmSoundModel.alarmSoundModel.useVibration()
        })
        <<< SwitchRow("skipRestTimer") {
            $0.title = "休憩をスキップする"
            if TimerModel.timerModel.skipRestTimer {
                $0.baseValue = true
            }
        }
        .onChange({ pick in
            TimerModel.timerModel.changeTimerAutomatically()
        })
    }
}
