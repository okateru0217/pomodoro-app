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
    
    private (set) internal var selectPomodoroTimerSound = "ベル"
    private (set) internal var selectRestTimerSound = "ベル"
    private var soundIdRing:SystemSoundID = 0
    private (set) internal var isVibration = true
    
    let userDefaults = UserDefaults.standard
    
    // 設定画面でアラーム音選択時、音を鳴らす
    func setFinishedTimerSound(alarmSoundType: String, timerType: String) {
        if alarmSoundType != "なし" {
            if let soundUrl:NSURL = NSURL(fileURLWithPath:
                    Bundle.main.path(forResource: alarmSoundType, ofType:"mp3")!) as NSURL?{
                AudioServicesCreateSystemSoundID(soundUrl, &soundIdRing)
                AudioServicesPlaySystemSound(soundIdRing)
            }
        }
        if timerType == "pomodoro" {
            selectPomodoroTimerSound = alarmSoundType
            self.userDefaults.set(self.selectPomodoroTimerSound, forKey: "selectPomodoroTimerSound")
        } else {
            selectRestTimerSound = alarmSoundType
            self.userDefaults.set(self.selectRestTimerSound, forKey: "selectRestTimerSound")
        }
    }
    
    // タイマー終了時、設定したアラームを鳴らす
    func soundAlarm() {
        if selectPomodoroTimerSound == "なし" && TimerModel.timerModel.timerStatusDiscriminant == 1 {
            return
        }
        
        if selectRestTimerSound == "なし" && TimerModel.timerModel.timerStatusDiscriminant == 0 || TimerModel.timerModel.timerStatusDiscriminant == 10 {
            return
        }
        switch TimerModel.TimerStatus(rawValue: TimerModel.timerModel.timerStatusDiscriminant) {
        case .pomodoroTimer:
            if let soundUrl:NSURL = NSURL(fileURLWithPath:
                    Bundle.main.path(forResource: selectPomodoroTimerSound, ofType:"mp3")!) as NSURL?{
                AudioServicesCreateSystemSoundID(soundUrl, &soundIdRing)
                AudioServicesPlaySystemSound(soundIdRing)
            }
            if isVibration {
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            }
        case .restTimer, .longRestTimer:
            if let soundUrl:NSURL = NSURL(fileURLWithPath:
                    Bundle.main.path(forResource: selectRestTimerSound, ofType:"mp3")!) as NSURL?{
                AudioServicesCreateSystemSoundID(soundUrl, &soundIdRing)
                AudioServicesPlaySystemSound(soundIdRing)
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
        self.userDefaults.set(self.isVibration, forKey: "isVibration")
    }
    
    // userDefaults呼び出し
    func setAlarmUserDefaults() {
        selectPomodoroTimerSound = userDefaults.string(forKey: "selectPomodoroTimerSound") ?? "ベル"
        selectRestTimerSound = userDefaults.string(forKey: "selectRestTimerSound") ?? "ベル"
        isVibration = userDefaults.bool(forKey: "isVibration")
    }
}
