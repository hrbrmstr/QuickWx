//
//  QuickWxApp.swift
//  Shared
//
//  Created by boB Rudis on 4/9/21.
//

import SwiftUI

var model = WxModel() // initialize the app model

@main
struct QuickWxApp: App {
  var body: some Scene {
    
    WindowGroup {
      
      #if os(macOS)
      ContentView()
        .navigationTitle("QuickWx")
        .environmentObject(model)
        .frame(
          alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/
        )
      
      #else
      ContentView()
        .environmentObject(model)
      #endif
      
    }

    #if os(macOS)
    Settings {
      SettingsView()
        .environmentObject(model)
    }
    #endif
    
  }
}
