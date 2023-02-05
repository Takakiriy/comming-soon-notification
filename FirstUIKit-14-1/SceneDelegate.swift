//
//  SceneDelegate.swift
//  FirstUIKit-14-1
//
//  Created by Takakiri on 2022/11/14.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var viewController: ViewController?
    var previousMessage = ""
    var previousImageChangeCount = 0
    var previousImageUUID = ""

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let  window = UIWindow(windowScene: windowScene)

        self.window = window
        window.backgroundColor = .white
        let viewController = ViewController()
        self.viewController = viewController
        window.rootViewController = viewController

        window.makeKeyAndVisible()

        // クリップボードが変更された時の処理を登録します
        NotificationCenter.default.addObserver(self,
            selector: #selector(handleClipboardChanged),
            name: UIPasteboard.changedNotification, object: nil)
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        let message = self.viewController!.messageField.text!
        let imageChangeCount = self.viewController!.imageChangeCount
        let isEmptyImage = (self.viewController!.imageURL.absoluteString == self.viewController!.emptyURL.absoluteString)
        let imageChanged = (imageChangeCount != self.previousImageChangeCount)
        let changed = (message != self.previousMessage  ||  imageChanged)
        let noMessage = (message == ""  &&  isEmptyImage)

        if (noMessage  ||  !(changed)) {
            return
        }
        self.previousMessage = message
        self.previousImageChangeCount = imageChangeCount

        // 1秒後に通知するトリガー
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        // 通知の内容
        let content = UNMutableNotificationContent()
        content.title = "もうすぐ"
        content.body = message
        content.sound = .default

        // 画像を添付します
        // 通知が発生したら画像ファイルが削除されます
        if !(isEmptyImage) {
            let imageURL = self.viewController!.imageURL
            let sendingImageURL = imageURL.appendingPathExtension("send").appendingPathExtension(imageURL.pathExtension)
            if !(FileManager.default.fileExists(atPath: sendingImageURL.relativeString)) {
                try! FileManager.default.copyItem(at: imageURL, to: sendingImageURL)
            }

            content.attachments = [try! UNNotificationAttachment(
                identifier: "CommingSoonNotification-Image-" + UUID().uuidString,
                url: sendingImageURL, options: nil)]
        }

        // 通知を登録します
        let request = UNNotificationRequest.init(
            identifier: "CommingSoonNotification-" + UUID().uuidString,
            content: content,
            trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request)
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        self.viewController!.setImageMenu()
    }

    @objc func handleClipboardChanged() {
        self.viewController!.setImageMenu()
    }
}

