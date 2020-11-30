//
//  MacSettings.swift
//
//
//  Created by Timur Khairullin on 11.07.2020.
//

import SwiftUI

// MARK: - MacSettings

public struct MacSettings: View {
    let items: [MacSettingsItem]
    
    public init(@MacSettingsBuilder items: () -> [MacSettingsItem]) {
        self.items = items()
    }
    
    // MARK: - selected, hovered
    
    @State private var selected: Int = 0

    @State private var hovered: Int? = nil
    private func set(isHovered: Bool, index: Int) {
        let newHovered = isHovered ? index : nil
        if newHovered == nil && hovered != index { return }
        guard hovered != newHovered else { return }
        hovered = newHovered
    }
    
    // MARK: - heights, widths

    @State private var contentHeights: [ContentHeightsPreference] = []
    @State private var toolbarWidth: CGFloat?
    @State private var maxContentWidth: CGFloat?

    private func height(index: Int) -> CGFloat? {
        let height = contentHeights.first { $0.index == index }?.height
        return height
    }

    private var width: CGFloat? {
        if toolbarWidth == nil && maxContentWidth == nil { return nil }
        return max(toolbarWidth ?? 0 + .toolbarPadding, maxContentWidth ?? 0)
    }
    
    // MARK: - View

    public var body: some View {
        ZStack {
            ForEach(0..<items.count) { index in
                items[index].content
                    .preferenceFromGeometry(key: ContentHeightsKey.self) {
                        [ContentHeightsPreference(index: index, height: $0.size.height)]
                    }
                    .isHidden(index != selected)
            }
        }
        .onPreferenceChange(ContentHeightsKey.self) {
            contentHeights = $0
        }
        .preferenceFromGeometry(key: MaxContentWidthKey.self, transform: { $0.size.width }, onChange: $maxContentWidth)
        .toolbar { toolbar }
        .navigationTitle(items[selected].title)
        .frame(minWidth: width, maxWidth: width, minHeight: height(index: selected), maxHeight: height(index: selected))
    }

    private var toolbar: some View {
        HStack(alignment: .center) {
            ForEach(0..<items.count) {
                toolbarItem(index: $0)
            }
        }
        .preferenceFromGeometry(key: ToolbarWidthKey.self, transform: { $0.size.width }, onChange: $toolbarWidth)
    }

    private func toolbarItem(index: Int) -> some View {
        VStack(spacing: .toolbarItemSpacing) {
            Image(systemName: items[index].image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: .toolbarImageHeight, alignment: .center)
                .foregroundColor(toolbarImageColor(index: index))
            Text(items[index].title)
                .font(.subheadline)
                .foregroundColor(.secondaryLabelColor)
        }
        .padding(.toolbarItemPadding)
        .background(toolbarItemBackground(index: index))
        .contentShape(Rectangle())
        .onTapGesture {
            selected = index
        }
        // Q: currently when using button as ToolbarItem, mouse hover + size of the items are not correct
        .onHover { isHovered in
            set(isHovered: isHovered, index: index)
        }
    }
    
    private func toolbarItemBackground(index: Int) -> some View {
        let isSelected = selected == index
        let isHovered = hovered == index
        return RoundedRectangle(cornerRadius: .toolbarItemBackgroundCornerRadius)
            .foregroundColor(isSelected ? .controlColor : (isHovered ? .separatorColor : .clear))
            .shadow(color: .shadow, radius: isSelected ? .toolbarItemBackgroundShadowRadius : 0.0)
    }

    private func toolbarImageColor(index: Int) -> Color {
        let isSelected = selected == index
        let isHovered = hovered == index
        return isSelected ? ( isHovered ? .selectedContentBackgroundColor : .accentColor) : .secondaryLabelColor
    }
}

// MARK: - MacSettingsItem

public struct MacSettingsItem {
    let title: String
    let image: String
    let content: AnyView
    
    public init<Content: View>(title: String, image: String, content: Content) {
        self.title = title
        self.image = image
        self.content = AnyView(content)
    }
}

// MARK: - MacSettingsBuilder

@_functionBuilder public struct MacSettingsBuilder {
    public static func buildBlock(_ partialResults: MacSettingsItem...) -> [MacSettingsItem] {
        partialResults.reduce([MacSettingsItem]()) { result, element in result + [element] }
    }
}

// MARK: - PreferenceKeys

fileprivate struct ToolbarWidthKey: PreferenceKey {
    static let defaultValue: CGFloat? = nil
    static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
        value = value ?? nextValue()
    }
}

fileprivate struct MaxContentWidthKey: PreferenceKey {
    static let defaultValue: CGFloat? = nil
    static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
        value = value ?? nextValue()
    }
}

fileprivate struct ContentHeightsKey: PreferenceKey {
    static let defaultValue: [ContentHeightsPreference] = []
    static func reduce(value: inout [ContentHeightsPreference], nextValue: () -> [ContentHeightsPreference]) {
        value.append(contentsOf: nextValue())
    }
}

fileprivate struct ContentHeightsPreference: Equatable {
    let index: Int
    let height: CGFloat
}

// MARK: - PreferenceFromGeometry

fileprivate extension View {
    func preferenceFromGeometry<Key: PreferenceKey>(
        key: Key.Type,
        transform: @escaping (GeometryProxy) -> Key.Value) -> some View {
        background(GeometryReader { proxy in
            Color.clear.preference(key: Key.self, value: transform(proxy))
        })
    }
}

fileprivate extension View {
    func preferenceFromGeometry<Key: PreferenceKey, Value: Equatable>(
        key: Key.Type,
        transform: @escaping (GeometryProxy) -> Value,
        onChange value: Binding<Value>) -> some View where Key.Value == Value {
        preferenceFromGeometry(key: key, transform: transform)
            .onPreferenceChange(Key.self) { value.wrappedValue = $0 }
    }
}

// MARK: - Hidden

fileprivate extension View {
    func isHidden(_ isHidden: Bool) -> some View {
        Group {
            if isHidden {
                self.hidden()
            } else {
                self
            }
        }
    }
}

// MARK: - Colors

fileprivate extension Color {
    static var controlColor: Color {
        Color(.controlColor)
    }
    
    static var secondaryLabelColor: Color {
        Color(.secondaryLabelColor)
    }
    
    static var selectedContentBackgroundColor: Color {
        Color(NSColor.selectedContentBackgroundColor)
    }
    
    static var separatorColor: Color {
        Color(.separatorColor)
    }
    
    static var shadow: Color {
        Color(NSColor.shadowColor.withAlphaComponent(0.1))
    }
}

// MARK: - Constants

fileprivate extension CGFloat {
    static let toolbarPadding: CGFloat = 22
    static let toolbarItemSpacing: CGFloat = 3
    static let toolbarImageHeight: CGFloat = 18
    static let toolbarItemBackgroundCornerRadius: CGFloat = 6.0
    static let toolbarItemBackgroundShadowRadius: CGFloat = 1.0
}

fileprivate extension EdgeInsets {
    static let toolbarItemPadding: EdgeInsets = EdgeInsets(top: 6, leading: 6, bottom: 4, trailing: 6)
}
