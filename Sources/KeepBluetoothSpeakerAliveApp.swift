import SwiftUI
import AppKit

@main
struct KeepBluetoothSpeakerAliveApp: App {
    // Reference our manager as a StateObject to manage lifetime and trigger SwiftUI updates
    @StateObject private var pingManager = PingManager()
    
    var body: some Scene {
        MenuBarExtra {
            // Menu Option 1: Active (Toggle)
            Toggle("Active", isOn: $pingManager.isActive)
            
            Divider()
            
            // Menu Option 2: Every (Submenu)
            Menu("Every") {
                Button(action: {
                    pingManager.interval = 10
                    UserDefaults.standard.set(10, forKey: "pingInterval")
                }) {
                    HStack {
                        Text("10 seconds")
                        if pingManager.interval == 10 {
                            Image(systemName: "checkmark")
                        }
                    }
                }
                
                Button(action: {
                    pingManager.interval = 30
                    UserDefaults.standard.set(30, forKey: "pingInterval")
                }) {
                    HStack {
                        Text("30 seconds")
                        if pingManager.interval == 30 {
                            Image(systemName: "checkmark")
                        }
                    }
                }
                
                Button(action: {
                    pingManager.interval = 50
                    UserDefaults.standard.set(50, forKey: "pingInterval")
                }) {
                    HStack {
                        Text("50 seconds")
                        if pingManager.interval == 50 {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
            
            Divider()
            
            // Menu Option 3: Exit (Button)
            Button("Exit") {
                pingManager.cleanExit()
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut("q", modifiers: .command)
            
        } label: {
            Image(systemName: "speaker.wave.2")
        }
    }
}
