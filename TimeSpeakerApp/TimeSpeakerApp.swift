import SwiftUI
import AVFoundation

@main
struct TimeSpeakerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @State private var timeString: String = Self.formatter.string(from: Date())
    private let synthesizer = AVSpeechSynthesizer()

    var body: some View {
        VStack {
            Text(timeString)
                .font(.largeTitle)
                .padding()
            Button("Speak Time") {
                speakTime()
            }
        }
        .onAppear {
            speakTime()
            startTimer()
        }
    }

    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        return formatter
    }()

    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            timeString = Self.formatter.string(from: Date())
        }
    }

    private func speakTime() {
        let utterance = AVSpeechUtterance(string: "The current time is \(timeString)")
        synthesizer.speak(utterance)
    }
}
