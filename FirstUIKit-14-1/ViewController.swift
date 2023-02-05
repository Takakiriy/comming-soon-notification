//
//  ViewController.swift
//  FirstUIKit-14-1
//
//  Created by Takakiri on 2022/11/14.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate {

    let messageField = UITextView()
    let messagePlaceHolder = UILabel()
    let imageField = UIImageView()
    let imageHiddenButton = MyButton()
    let imagePlaceHolder = UILabel()
    var imageURL = URL(filePath: "")
    let emptyImagePath = Bundle.main.path(forResource: "tryAttached", ofType: "png")!
    var emptyURL = URL(filePath: "")
    var imageChangeCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        let firstGuide = UILabel()
        self.view.addSubview(firstGuide)
        firstGuide.text = ""
        firstGuide.textColor = .gray
        firstGuide.numberOfLines = 0  // Multi lines

        let messageLabel = UILabel()
        self.view.addSubview(messageLabel)
        messageLabel.text = "もうすぐ"
        messageLabel.textColor = .black
        messageLabel.font = UIFont.boldSystemFont(ofSize: 20)

        let messageField = self.messageField
        self.view.addSubview(messageField)
        messageField.layer.borderWidth = 1
        messageField.layer.borderColor = UIColor.black.cgColor
        messageField.layer.cornerRadius = 5
        messageField.font = UIFont.systemFont(ofSize: 18)
        messageField.autocorrectionType = .no  // 勝手に英語のスペルを正しいのにする機能をoff
        messageField.autocapitalizationType = .none  // 勝手に英語の先頭の文字を大文字にするのをoff
        messageField.delegate = self

        let messagePlaceHolder = self.messagePlaceHolder
        messageField.addSubview(messagePlaceHolder)
        messagePlaceHolder.text = "メッセージ"
        messagePlaceHolder.font = UIFont.systemFont(ofSize: 18)
        self.textViewDidChange(messageField)

        let imageField = self.imageField
        self.view.addSubview(imageField)
        imageField.layer.borderWidth = 1
        imageField.layer.borderColor = UIColor.black.cgColor
        imageField.layer.cornerRadius = 5
        imageField.contentMode = .scaleAspectFit
        imageField.image = .init(contentsOfFile: self.emptyImagePath)

        let imagePlaceHolder = self.imagePlaceHolder
        imageField.addSubview(imagePlaceHolder)
        imagePlaceHolder.text = "画像"
        imagePlaceHolder.textColor = .lightGray
        imagePlaceHolder.font = UIFont.systemFont(ofSize: 18)

        let imageHiddenButton = self.imageHiddenButton
        self.view.addSubview(imageHiddenButton)
        imageHiddenButton.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.0)
        imageHiddenButton.showsMenuAsPrimaryAction = true
        self.setImageMenu()

        let nextGuide = UILabel()
        self.view.addSubview(nextGuide)
        nextGuide.text = "メッセージを入力したら、ホームに戻って、本体をロックすると、ロック画面に通知が表示されます。"
        nextGuide.textColor = .black
        nextGuide.numberOfLines = 0  // Multi lines

        let help = UILabel()
        self.view.addSubview(help)
        help.text = "ロック解除する前にメッセージの内容を隠さないようにする場合は、" +
            "ホーム >> 設定 >>（アプリ名）>> 通知 >> プレビューを表示 を「常に」に設定してください。"
        help.textColor = .gray
        help.numberOfLines = 0  // Multi lines

        let views = [
            "firstGuide": firstGuide,
            "messageLabel": messageLabel,
            "messageField": messageField,
            "messagePlaceHolder": messagePlaceHolder,
            "imageField": imageField,
            "imagePlaceHolder": imagePlaceHolder,
            "imageHiddenButton": imageHiddenButton,
            "nextGuide": nextGuide,
            "help": help]
        views.forEach { $1.translatesAutoresizingMaskIntoConstraints = false }

        // firstGuide layout
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-70-[firstGuide]", options: .alignAllCenterX, metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[firstGuide]-10-|", options: .alignAllTop, metrics: nil, views: views))

        // messageLabel layout
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[firstGuide]-20-[messageLabel]", options: .alignAllCenterX, metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[messageLabel]-10-|", options: .alignAllCenterX, metrics: nil, views: views))

        // messageField layout
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[messageLabel]-5-[messageField]", options: .alignAllCenterX, metrics: nil, views: views))
        messageField.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[messageField(>=100)]", options: .alignAllCenterX, metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[messageField]-10-|", options: .alignAllCenterX, metrics: nil, views: views))

        // messagePlaceHolder layout
        messageField.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-8-[messagePlaceHolder]", options: .alignAllCenterX, metrics: nil, views: views))
        messageField.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-5-[messagePlaceHolder]", options: .alignAllTop, metrics: nil, views: views))

        // imageField layout
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[messageField]-5-[imageField]", options: .alignAllCenterX, metrics: nil, views: views))
        imageField.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[imageField(<=250)]", options: .alignAllCenterX, metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[imageField]-10-|", options: .alignAllCenterX, metrics: nil, views: views))

        // imagePlaceHolder layout
        imageField.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-8-[imagePlaceHolder]", options: .alignAllCenterX, metrics: nil, views: views))
        imageField.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-5-[imagePlaceHolder]", options: .alignAllTop, metrics: nil, views: views))

        // imageHiddenButton layout
        imageHiddenButton.topAnchor.constraint(equalTo: imageField.topAnchor).isActive = true
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[imageHiddenButton(==imageField)]", options: .alignAllCenterX, metrics: nil, views: views))
        imageHiddenButton.leadingAnchor.constraint(equalTo: imageField.leadingAnchor).isActive = true
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:[imageHiddenButton(==imageField)]", options: .alignAllTop, metrics: nil, views: views))

        // nextGuide layout
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[imageField]-20-[nextGuide]", options: .alignAllCenterX, metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[nextGuide]-10-|", options: .alignAllTop, metrics: nil, views: views))

        // help layout
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[nextGuide]-20-[help]", options: .alignAllCenterX, metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[help]-10-|", options: .alignAllTop, metrics: nil, views: views))

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }

    func textViewDidChange(_ textView: UITextView) {
        if textView == self.messageField {
            let showPlaceHolder = (self.messageField.text!.count == 0)
            if showPlaceHolder {
                self.messagePlaceHolder.textColor = .lightGray
            } else {
                self.messagePlaceHolder.textColor = .clear
            }
        }
    }

    @objc func dismissKeyboard() {
        self.messageField.resignFirstResponder()
    }

    func setImageMenu() {
        self.imageHiddenButton.menu = UIMenu(children: [
            UIAction(title: "クリア") { action in self.handleClearImage() },
            UIAction(
                title: "貼り付け",
                attributes: UIPasteboard.general.hasImages ? [] : [.disabled]
            ) { action in self.handlePasteImage() },
        ])
    }

    func handlePasteImage() {
        let pasteBoard = UIPasteboard.general
        if pasteBoard.hasImages {

            self.imageField.image = pasteBoard.image
            let imageFileURL: URL = FileManager.default.temporaryDirectory.appendingPathComponent("paste").appendingPathExtension("jpeg")
            if let imageData = pasteBoard.image!.jpegData(compressionQuality: 0.2) {

                try! imageData.write(to: imageFileURL)
                self.imageURL = imageFileURL
                self.imageChangeCount += 1
                self.messageField.resignFirstResponder()
            }
        }
    }

    func handleClearImage() {
        self.imageField.image = .init(contentsOfFile: self.emptyImagePath)
        self.imageURL = URL(filePath: self.emptyURL.relativeString)
        self.imageChangeCount += 1
        self.messageField.resignFirstResponder()
    }
}

class MyButton: UIButton {
    override func menuAttachmentPoint(for configuration: UIContextMenuConfiguration) -> CGPoint {
        return CGPoint(x: 70, y: 30)
    }
}
