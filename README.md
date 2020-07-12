## MacSettings

Mac Settings SwiftUI View

## Example

<p align="middle">
  <img src="Resources/general.png" width="32%" />
  <img src="Resources/appearance.png" width="32%" /> 
  <img src="Resources/content.png" width="32%" />
</p>

## Usage

```swift
import SwiftUI
import MacSettings

@main
struct MainApp: App {
    @SceneBuilder
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        Settings {
            MacSettings {
                MacSettingsItem(title: "General",
                                image: "gearshape",
                                content: generalSettings)
                MacSettingsItem(title: "Appearance",
                                image: "flame",
                                content: appearanceSettings)
                MacSettingsItem(title: "Content",
                                image: "heart",
                                content: contentSettings)
            }
        }
    }
    
    var generalSettings: some View { ... }
    var appearanceSettings: some View { ... }
    var contentSettings: some View { ... }
}
```
