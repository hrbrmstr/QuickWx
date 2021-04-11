//
//  Settings.swift
//  QuickWx
//
//  Created by boB Rudis on 4/11/21.
//

import Foundation
import SwiftUI

struct GeneralSettingsView: View {
  
  @EnvironmentObject var model: WxModel
  @AppStorage("ipPort") private var ipPort: String = ""
    
  var body: some View {
    Form {
      VStack {
        Text("Enter the IP address (e.g. '192.168.1.20') or \nIP address:port (e.g. '24.63.157.106:22080') \nof the Davis WeatherLink.")
          .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
        TextField("IP Address:port", text: $ipPort)
          .onChange(of: ipPort) { val in
            model.stopTimer()
            model.startTimer()
          }
        HStack {
          Text("Connection status:")
            .padding(.leading, 0)
            .padding(.trailing, 0)
          Image(systemName: "circle.fill")
            .foregroundColor(model.live ? .green : .red)

        }
      }
    }
    .padding()
    .fixedSize()
  }
  
}

struct SettingsView: View {
  private enum Tabs: Hashable {
    case general, advanced
  }
  var body: some View {
    TabView {
      GeneralSettingsView()
        .tabItem {
          Label("Connection", systemImage: "network")
        }
        .tag(Tabs.general)
    }
    .padding(20)
//    .frame(width: 300, height: 150)
  }
}

