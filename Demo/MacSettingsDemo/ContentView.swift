//
//  ContentView.swift
//  MacSettingsDemo
//
//  Created by Timur Khairullin on 11.07.2020.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HStack {
            Text("Cmd").bold()
            Text("+")
            Text(",").bold()
        }
        .frame(minWidth: 200, maxWidth: .infinity, minHeight: 200, maxHeight: .infinity)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
