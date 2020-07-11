//
//  MacSettingsDemoApp.swift
//  MacSettingsDemo
//
//  Created by Timur Khairullin on 11.07.2020.
//

import SwiftUI
import MacSettings

@main
struct MacSettingsDemoApp: App {
    @SceneBuilder
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        Settings {
            MacSettings {
                MacSettingsItem(title: "General",
                                image: "gearshape",
                                content: GeneralSettings())
                MacSettingsItem(title: "Appearance",
                                image: "flame",
                                content: AppearanceSettings())
                MacSettingsItem(title: "Content",
                                image: "heart",
                                content: ContentSettings())
            }
        }
    }
}

struct GeneralSettings: View {
    @State var one: Bool = true
    @State var two: Bool = true
    @State var three: Bool = true

    var body: some View {
        VStack(alignment: .leading) {
            Toggle("100% SwiftUI", isOn: $one)
            Toggle("Nested in Settings Scene", isOn: $two)
            Toggle("Available in macOS BigSur", isOn: $three)
        }.padding()
    }
}

struct AppearanceSettings: View {
    @State var one: Bool = true
    @State var two: Bool = true
    @State var three: Bool = true

    var body: some View {
        VStack(alignment: .leading) {
            Toggle("Dark Mode", isOn: $one)
            Toggle("Accent Color", isOn: $two)
            Toggle("Adaptive size", isOn: $three)
        }.padding()
    }
}

struct ContentSettings: View {
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.red, .orange, .yellow, .green, .blue, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .frame(width: 300, height: 200)
            Text("Any content is possible")
                .font(.headline)
                .foregroundColor(colorScheme == .dark ? .black : .white)
        }
    }
}
