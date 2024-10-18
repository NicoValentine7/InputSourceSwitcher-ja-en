import Cocoa
import Carbon

class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // グローバルモニタでキー変更イベントを監視
        NSEvent.addGlobalMonitorForEvents(matching: .flagsChanged) { [unowned self] event in
            handleFlagsChanged(event: event)
        }
        listInputSources() // 任意で入力ソースをリスト表示
    }

    func handleFlagsChanged(event: NSEvent) {
        guard event.modifierFlags.contains(.command) else { return }

        switch event.keyCode {
        case 0x37: // 左コマンドキー
            print("Left Command Key Pressed")
            switchInputSource(to: "com.apple.keylayout.ABC") // 英語キーボードに切り替え
        case 0x36: // 右コマンドキー
            print("Right Command Key Pressed")
            switchInputSource(to: "com.apple.inputmethod.Kotoeri.RomajiTyping.Japanese") // 日本語キーボードに切り替え
        default:
            break
        }
    }

    func switchInputSource(to sourceID: String) {
        guard let source = getInputSource(by: sourceID) else {
            print("\(sourceID) Input Source not found")
            return
        }
        TISSelectInputSource(source)
        print("Switched to \(sourceID)")
    }

    func getInputSource(by id: String) -> TISInputSource? {
        let properties = [kTISPropertyInputSourceID: id] as CFDictionary
        let sources = TISCreateInputSourceList(properties, false)?.takeRetainedValue() as? [TISInputSource]
        return sources?.first
    }

    func listInputSources() {
        // すべての入力ソースをリスト表示
        guard let sources = TISCreateInputSourceList(nil, false)?.takeRetainedValue() as? [TISInputSource] else {
            return
        }
        for source in sources {
            if let cfType = TISGetInputSourceProperty(source, kTISPropertyInputSourceID) {
                let cfString = Unmanaged<CFString>.fromOpaque(cfType).takeUnretainedValue()
                let id = cfString as String
                print(id)
            }
        }
    }
}
