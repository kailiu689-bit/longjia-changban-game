import Cocoa
import AVFoundation
import WebKit

final class AppDelegate: NSObject, NSApplicationDelegate, WKScriptMessageHandler {
    private var window: NSWindow?
    private var musicPlayer: AVAudioPlayer?

    func applicationDidFinishLaunching(_ notification: Notification) {
        guard let resources = Bundle.main.resourceURL else { return }
        let gameURL = resources.appendingPathComponent("mech-three-kingdoms.html")

        let configuration = WKWebViewConfiguration()
        configuration.mediaTypesRequiringUserActionForPlayback = []
        configuration.userContentController.add(self, name: "music")
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.autoresizingMask = [.width, .height]

        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 1440, height: 920),
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )
        window.title = "龙甲 · 长坂战域"
        window.minSize = NSSize(width: 960, height: 640)
        window.center()
        window.contentView = webView
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        webView.loadFileURL(gameURL, allowingReadAccessTo: resources)
        playMusic()
        self.window = window
    }

    private func playMusic() {
        guard let url = Bundle.main.url(forResource: "battle-theme", withExtension: "m4a", subdirectory: "assets/mech-three-kingdoms") else { return }
        if musicPlayer == nil {
            musicPlayer = try? AVAudioPlayer(contentsOf: url)
            musicPlayer?.numberOfLoops = -1
            musicPlayer?.volume = 0.48
            musicPlayer?.prepareToPlay()
        }
        musicPlayer?.play()
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard message.name == "music", let command = message.body as? String else { return }
        if command == "play" { playMusic() }
        if command == "pause" { musicPlayer?.pause() }
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.setActivationPolicy(.regular)
app.run()
