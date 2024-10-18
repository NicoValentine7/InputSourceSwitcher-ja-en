import Cocoa
import Carbon

class AppDelegate: NSObject, NSApplicationDelegate {
    let leftCommandKeyCode: UInt16 = 0x37 // 左コマンドキー
    let rightCommandKeyCode: UInt16 = 0x36 // 右コマンドキー

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSEvent.addGlobalMonitorForEvents(matching: .flagsChanged) { [weak self] event in
            self?.flagsChanged(with: event)
        }
        listInputSources() // 入力ソースをリスト表示（任意）
    }

func flagsChanged(with event: NSEvent) {
    print("flagsChanged detected")
    print("KeyCode: \(event.keyCode)")
    print("Modifier Flags: \(event.modifierFlags.rawValue)")
    
    // 左コマンドキーが押された場合
    if event.keyCode == leftCommandKeyCode && event.modifierFlags.contains(.command) {
        print("Left Command Key Pressed")
        switchToEnglishInput()
    }
    // 右コマンドキーが押された場合
    else if event.keyCode == rightCommandKeyCode && event.modifierFlags.contains(.command) {
        print("Right Command Key Pressed")
        switchToJapaneseInput()
    }
}


func switchToEnglishInput() {
    if let source = getInputSource(by: "com.apple.keylayout.ABC") {
        TISSelectInputSource(source)
        print("Switched to English Input")
        } else {
            print("English Input Source not found")
        }
    }

    func switchToJapaneseInput() {
        if let source = getInputSource(by: "com.apple.inputmethod.Kotoeri.RomajiTyping.Japanese") {
            TISSelectInputSource(source)
            print("Switched to Japanese Input")
        } else {
            print("Japanese Input Source not found")
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
        // すべての入力ソースを取得
        if let sources = TISCreateInputSourceList(nil, false)?.takeRetainedValue() as? [TISInputSource] {
            for source in sources {
                if let cfType = TISGetInputSourceProperty(source, kTISPropertyInputSourceID) {
                    let cfString = Unmanaged<CFString>.fromOpaque(cfType).takeUnretainedValue()
                    let id = cfString as String
                    print(id)
                }
            }
        }
    }
}
