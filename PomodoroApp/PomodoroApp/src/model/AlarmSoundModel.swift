//
//  AlarmSoundModel.swift
//  PomodoroApp
//
//  Created by 岡澤輝明 on 2021/04/11.
//

import Foundation
import AudioToolbox

final class AlarmSoundModel {
    public static let alarmSoundModel = AlarmSoundModel()
    
    private (set) internal var selectPomodoroTimerSound = "チン音"
    private (set) internal var selectRestTimerSound = "チン音"
    private (set) internal var finishedPomodoroTimerSound: SystemSoundID = 1054
    private (set) internal var finishedRestTimerSound: SystemSoundID = 1054
    private (set) internal var isVibration = true
    
    // 設定画面でアラーム音選択時、音を鳴らす
    func setFinishedTimerSound(alarmSoundType: String, timerType: String) {
        var pomodoroTimerAlarm: SystemSoundID = 0
        switch alarmSoundType {
        case "チン音":
            pomodoroTimerAlarm = 1054
        case "ベル音":
            pomodoroTimerAlarm = 1402
        case "ガラス":
            pomodoroTimerAlarm = 1009
        case "警告":
            pomodoroTimerAlarm = 1005
        case "ホルン":
            pomodoroTimerAlarm = 1010
        case "エレクトロニック":
            pomodoroTimerAlarm = 1014
        case "機関車":
            pomodoroTimerAlarm = 1023
        case "はしご":
            pomodoroTimerAlarm = 1026
        case "ノアール":
            pomodoroTimerAlarm = 1029
        case "シャーウッドの森":
            pomodoroTimerAlarm = 1030
        case "つま先":
            pomodoroTimerAlarm = 1034
        case "タイプライター":
            pomodoroTimerAlarm = 1035
        default: break
        }
        if let soundUrl = CFBundleCopyResourceURL(CFBundleGetMainBundle(), nil, nil, nil){
            AudioServicesCreateSystemSoundID(soundUrl, &pomodoroTimerAlarm)
            AudioServicesPlaySystemSound(pomodoroTimerAlarm)
        }
        if timerType == "pomodoro" {
            selectPomodoroTimerSound = alarmSoundType
            finishedPomodoroTimerSound = pomodoroTimerAlarm
        } else {
            selectRestTimerSound = alarmSoundType
            finishedRestTimerSound = pomodoroTimerAlarm
        }
    }
    
    // タイマー終了時、設定したアラームを鳴らす
    func soundAlarm() {
        switch TimerModel.TimerStatus(rawValue: TimerModel.timerModel.timerStatusDiscriminant) {
        case .pomodoroTimer:
            if let soundUrl = CFBundleCopyResourceURL(CFBundleGetMainBundle(), nil, nil, nil){
                AudioServicesCreateSystemSoundID(soundUrl, &finishedPomodoroTimerSound)
                AudioServicesPlaySystemSound(finishedPomodoroTimerSound)
            }
            if isVibration {
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            }
        case .restTimer, .longRestTimer:
            if let soundUrl = CFBundleCopyResourceURL(CFBundleGetMainBundle(), nil, nil, nil){
                AudioServicesCreateSystemSoundID(soundUrl, &finishedRestTimerSound)
                AudioServicesPlaySystemSound(finishedRestTimerSound)
            }
            if isVibration {
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            }
        default: break
        }
    }
    
    // バイブレーションを使用するかどうかを切り替える
    func useVibration() {
        isVibration = !isVibration
    }
}
