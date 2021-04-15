//
//  SceneDelegate.swift
//  PomodoroApp
//
//  Created by 岡澤輝明 on 2021/03/31.
//

import UIKit
import UserNotifications
import AudioToolbox

class SceneDelegate: UIResponder, UIWindowSceneDelegate, UNUserNotificationCenterDelegate {
    public static let sceneDelegate = SceneDelegate()
    
    var window: UIWindow?
    private let calender = Calendar(identifier: .gregorian)
    private var timeBackground: Date = Date()
    private var timeForeground: Date = Date()
    private (set) internal var isMovingTimer = false
    private var isAllowedLocalNotification = false
    
    let userDefaults = UserDefaults.standard
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
        userDefaults.removeObject(forKey: "isMovingTimer")
    }

    // フォアグラウンド復帰時
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        localNotification()
        isMovingTimer = userDefaults.bool(forKey: "isMovingTimer")
        timeForeground = Date()
        if isMovingTimer {
            let diff = calender.dateComponents([.second], from: timeBackground, to: timeForeground)
            TimerModel.timerModel.moveTimerBackground(backgroundTime: diff.second!)
        }
    }
    
    // バックグラウンド移行時
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        isMovingTimer = userDefaults.bool(forKey: "isMovingTimer")
        timeBackground = Date()
        notificationType()
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

extension SceneDelegate {
    func judgeMovingTimer(timerStatus: String) {
        switch timerStatus {
        case "開始", "休憩する", "再開":
            isMovingTimer = true
        case "一時停止":
            isMovingTimer = false
        default: break
        }
        self.userDefaults.set(self.isMovingTimer, forKey: "isMovingTimer")
    }
    // ローカル通知を許可するかのアラートを出す
    func localNotification() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        if #available(iOS 10.0, *) {
            center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                if granted {
                    self.isAllowedLocalNotification = true
                } else {
                    self.isAllowedLocalNotification = false
                }
            }
        } else {
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
    }
    // 通知の設定
    func notificationType() {
        let soundAlarmInterval = TimerModel.timerModel.minutes * 60 + TimerModel.timerModel.seconds
        
        // 通知の設定
        let content: UNMutableNotificationContent = UNMutableNotificationContent()
        if isMovingTimer {
            switch TimerModel.TimerStatus(rawValue: TimerModel.timerModel.timerStatusDiscriminant) {
            case .pomodoroTimer:
                content.title = "ポモドーロが終了しました！"
                content.sound = UNNotificationSound(named: UNNotificationSoundName("\(AlarmSoundModel.alarmSoundModel.selectPomodoroTimerSound).mp3"))
            case .restTimer:
                content.title = "休憩が終了しました！"
                content.sound = UNNotificationSound(named: UNNotificationSoundName("\(AlarmSoundModel.alarmSoundModel.selectRestTimerSound).mp3"))
            case .longRestTimer:
                content.title = "長い休憩が終了しました！"
                content.sound = UNNotificationSound(named: UNNotificationSoundName("\(AlarmSoundModel.alarmSoundModel.selectRestTimerSound).mp3"))
            default: break
            }
            // 通知する時間
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(soundAlarmInterval), repeats: false)
            
            let request: UNNotificationRequest = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request)
        }
    }
}
