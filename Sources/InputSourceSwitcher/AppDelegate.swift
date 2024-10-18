import Cocoa
import Carbon

class AppDelegate: NSObject, NSApplicationDelegate {
    enum CommandKey: UInt16 {
        case left = 0x37
        case right = 0x36
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSEvent.addGlobalMonitorForEvents(matching: .flagsChanged) { [weak self] event in
            self?.flagsChanged(with: event)
        }
        listInputSources()
    }

    func flagsChanged(with event: NSEvent) {
        guard event.modifierFlags.contains(.command) else { return }

        if let key = CommandKey(rawValue: event.keyCode) {
            switch key {
            case .left:
                switchToEnglishInput()
            case .right:
                switchToJapaneseInput()
            }
        }
    }

    func switchToEnglishInput() {
        guard let source = getInputSource(by: "com.apple.keylayout.ABC") else {
            print("英語入力ソースが見つかりません")
            return
        }
        if TISSelectInputSource(source) == noErr {
            print("英語入力に切り替えました")
        } else {
            print("入力ソースの切り替えに失敗しました")
        }
    }

    func switchToJapaneseInput() {
        guard let source = getInputSource(by: "com.apple.inputmethod.Kotoeri.RomajiTyping.Japanese") else {
            print("日本語入力ソースが見つかりません")
            return
        }
        if TISSelectInputSource(source) == noErr {
            print("日本語入力に切り替えました")
        } else {
            print("入力ソースの切り替えに失敗しました")
        }
    }

    func getInputSource(by id: String) -> TISInputSource? {
        let properties = [kTISPropertyInputSourceID: id] as CFDictionary
        guard let sources = TISCreateInputSourceList(properties, false)?.takeRetainedValue() as? [TISInputSource],
              let source = sources.first else {
            return nil
        }
        return source
    }

    func listInputSources() {
        if let sources = TISCreateInputSourceList(nil, false)?.takeRetainedValue() as? [TISInputSource] {
            for source in sources {
                if let idPtr = TISGetInputSourceProperty(source, kTISPropertyInputSourceID) {
                    let id = Unmanaged<CFString>.fromOpaque(idPtr).takeUnretainedValue() as String
                    print(id)
                }
            }
        }
    }
}
