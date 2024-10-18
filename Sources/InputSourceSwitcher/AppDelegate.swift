import Cocoa
import Carbon

enum KeyCode: UInt16 {
    case leftCommand = 0x37
    case rightCommand = 0x36
}

struct InputSourceID {
    static let english = "com.apple.keylayout.ABC"
    static let japanese = "com.apple.inputmethod.Kotoeri.RomajiTyping.Japanese"
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var previousFlags: NSEvent.ModifierFlags = []

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // アクセシビリティ許可の確認
        let options: [String: Bool] = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
        let accessEnabled = AXIsProcessTrustedWithOptions(options as CFDictionary)
        
        if accessEnabled {
            // イベントモニターのセットアップ
            NSEvent.addGlobalMonitorForEvents(matching: .flagsChanged) { [weak self] event in
                self?.flagsChanged(with: event)
            }
        } else {
            print("アクセシビリティの許可が必要です。")
        }

        listInputSources() // 入力ソースをリスト表示（任意）
    }

    func flagsChanged(with event: NSEvent) {
        let currentFlags = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
        let addedFlags = currentFlags.subtracting(previousFlags)
        previousFlags = currentFlags

        // コマンドキーが新たに押された場合
        if addedFlags.contains(.command) {
            switch event.keyCode {
            case KeyCode.leftCommand.rawValue:
                print("Left Command Key Pressed")
                switchToEnglishInput()
            case KeyCode.rightCommand.rawValue:
                print("Right Command Key Pressed")
                switchToJapaneseInput()
            default:
                break
            }
        }
    }

    /// 英語入力に切り替えます
    func switchToEnglishInput() {
        if let source = getInputSource(by: InputSourceID.english) {
            let status = TISSelectInputSource(source)
            if status == noErr {
                print("Switched to English Input")
            } else {
                print("Failed to switch to English Input")
            }
        } else {
            print("English Input Source not found")
        }
    }

    /// 日本語入力に切り替えます
    func switchToJapaneseInput() {
        if let source = getInputSource(by: InputSourceID.japanese) {
            let status = TISSelectInputSource(source)
            if status == noErr {
                print("Switched to Japanese Input")
            } else {
                print("Failed to switch to Japanese Input")
            }
        } else {
            print("Japanese Input Source not found")
        }
    }

    /// 指定したIDの入力ソースを取得します
    ///
    /// - Parameter id: 入力ソースのID
    /// - Returns: 見つかった場合は `TISInputSource`、見つからなかった場合は `nil`
    func getInputSource(by id: String) -> TISInputSource? {
        let properties = [kTISPropertyInputSourceID: id] as CFDictionary
        guard let sources = TISCreateInputSourceList(properties, false)?.takeRetainedValue() as? [TISInputSource],
              let source = sources.first else {
            return nil
        }
        return source
    }

    /// 利用可能な入力ソースのIDをリスト表示します
    func listInputSources() {
        if let sources = TISCreateInputSourceList(nil, false)?.takeRetainedValue() as? [TISInputSource] {
            for source in sources {
                if let id = TISGetInputSourceProperty(source, kTISPropertyInputSourceID) as? String {
                    print(id)
                }
            }
        }
    }
}
