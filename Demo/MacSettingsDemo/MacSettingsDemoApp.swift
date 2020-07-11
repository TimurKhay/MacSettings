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
                                content: Rectangle().frame(width: 700, height: 500).border(Color.green))
                MacSettingsItem(title: "Location",
                                image: "location",
                                content: Rectangle().frame(width: 500, height: 600).border(Color.green))
                MacSettingsItem(title: "Cloud",
                                image: "cloud",
                                content: Rectangle().frame(width: 400, height: 400).border(Color.green))
            }
        }
    }
}
