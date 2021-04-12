//
//  SceneDelegate.swift
//  PomodoroApp
//
//  Created by 岡澤輝明 on 2021/03/31.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    public static let sceneDelegate = SceneDelegate()
    
    var window: UIWindow?
    private let calender = Calendar(identifier: .gregorian)
    private var timeBackground: Date?
    private var timeForeground: Date?
    private var isMovingTimer = false
    
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
    }

    // フォアグラウンド復帰時
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        timeForeground = Date()
//            let diff = calender.dateComponents([.second], from: timeBackground!, to: timeForeground!)
//            print(diff)
    }
    
    // バックグラウンド移行時
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        timeBackground = Date()
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
}
