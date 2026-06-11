//
//  HiddenShelfWidgetControl.swift
//  HiddenShelfWidget
//
//  Created by student on 29/05/26.
//

import AppIntents
import SwiftUI
import WidgetKit

struct HiddenShelfWidgetControl: ControlWidget {
    static let kind: String = "MAD.Hidden-Shelf.HiddenShelfWidget"

    var body: some ControlWidgetConfiguration {
        AppIntentControlConfiguration(
            kind: Self.kind,
            provider: ControlProvider() // 👈 FIX: Diubah dari Provider() menjadi nama baru yang unik
        ) { value in
            ControlWidgetToggle(
                "Start Timer",
                isOn: value.isRunning,
                action: StartTimerIntent(value.name)
            ) { isRunning in
                Label(isRunning ? "On" : "Off", systemImage: "timer")
            }
        }
        .displayName("Timer")
        .description("A an example control that runs a timer.")
    }
}

extension HiddenShelfWidgetControl {
    struct Value {
        var isRunning: Bool
        var name: String
    }

    // 👈 FIX: Nama struct diubah menjadi ControlProvider agar tidak bentrok dengan TimelineProvider milik widget utama
    struct ControlProvider: AppIntentControlValueProvider {
        func previewValue(configuration: TimerConfiguration) -> Value {
            HiddenShelfWidgetControl.Value(isRunning: false, name: configuration.timerName)
        }

        func currentValue(configuration: TimerConfiguration) async throws -> Value {
            let isRunning = true // Check if the timer is running
            return HiddenShelfWidgetControl.Value(isRunning: isRunning, name: configuration.timerName)
        }
    }
}

struct TimerConfiguration: ControlConfigurationIntent {
    static let title: LocalizedStringResource = "Timer Name Configuration"

    @Parameter(title: "Timer Name", default: "Timer")
    var timerName: String
}

struct StartTimerIntent: SetValueIntent {
    static let title: LocalizedStringResource = "Start a timer"

    @Parameter(title: "Timer Name")
    var name: String

    @Parameter(title: "Timer is running")
    var value: Bool

    init() {}

    init(_ name: String) {
        self.name = name
    }

    func perform() async throws -> some IntentResult {
        // Start the timer…
        return .result()
    }
}
