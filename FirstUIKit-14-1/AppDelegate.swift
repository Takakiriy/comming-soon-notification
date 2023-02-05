//
//  AppDelegate.swift
//  FirstUIKit-14-1
//
//  Created by Takakiri on 2022/11/14.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // ユーザーに通知を許可を確認します。許可していないとき
        UNUserNotificationCenter.current().requestAuthorization(
                options: [.alert, .sound, .badge, .provisional]) { (granted, _) in
            if granted {
                UNUserNotificationCenter.current().delegate = self
            }
        }

        // ユーザーが設定している通知設定の内容をデバッグ出力に出力します
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print(settings)
        }

        // 通知の初期値を修正します。再度試すときはアプリをアンインストールしてください。
        // requestAuthorization を呼び出す場合: ロック画面, 通知センター, バナー, サウンド, バッジ
        // requestAuthorization を呼び出さない場合: 通知センターのみ
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
        { (granted, error) in

            // 「プレビューを表示」は以下のコードでは設定されないようです
            //  https://www.techotopia.com/index.php?title=An_iOS_10_Local_Notification_Tutorial&mobileaction=toggle_view_mobile
            let category = UNNotificationCategory(identifier: "actionCategory",
                actions: [],
                intentIdentifiers: [],
                options: [.hiddenPreviewsShowTitle, .hiddenPreviewsShowSubtitle])
            UNUserNotificationCenter.current().setNotificationCategories([category])
        }


        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

// 通知を受け取ったときの処理
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        // アプリ起動時も通知を行う
        completionHandler([.sound, .banner ])
    }
}
