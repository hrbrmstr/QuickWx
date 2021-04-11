//
//  ContentView.swift
//  Shared
//
//  Created by boB Rudis on 4/9/21.
//

import SwiftUI

struct UnitsView: View {
  
  var measure: String
  var reading: String
  var units: String
  
  var body: some View {
    VStack(alignment: .leading) {
      Text(measure)
        .font(.body.lowercaseSmallCaps())
      HStack(alignment: .top, spacing: 0) {
        Text(reading)
          .padding(.leading, 0)
          .padding(.trailing, 0)
          .font(.largeTitle)
          .fixedSize()
        Text(units)
          .padding(.leading, 0)
          .padding(.trailing, 0)
          .font(.footnote)
          .fixedSize()
      }.fixedSize()
    }
    .padding(6)
    .fixedSize()
  }
  
}

//struct UnitsView_Previews: PreviewProvider {
//  static var previews: some View {
//    UnitsView(
//      measure: "TEMP",
//      reading: "60",
//      units: "°F"
//    )
//  }
//}


struct ReadingsView: View {
  
  var timestamp: String
  var temp: String
  var humid: String
  var wind: String
  var baro: String

  var body: some View {
    
    VStack(alignment: .leading) {
    
      Text(timestamp)
        .font(.body.monospacedDigit())
        .padding(.top, 10)
        .padding(.leading, 8)
        .padding(.bottom, -8)
        .fixedSize()
      
      HStack(alignment: .top) {
        
        VStack(alignment: .leading) {
          UnitsView(
            measure: "Temperature",
            reading: temp,
            units: "°F"
          )
          UnitsView(
            measure: "Humidity",
            reading: humid,
            units: "%"
          )
        }
        .padding(4)
        .fixedSize()
        
        VStack(alignment: .leading) {
          UnitsView(
            measure: "Wind",
            reading: wind,
            units: "MPH"
          )
          UnitsView(
            measure: "Pressure",
            reading: baro,
            units: "inHg"
          )
        }
        .padding(4)
        .fixedSize()
        
      }
      .fixedSize()
      
    }
    .padding(4)

  }
  
}

//struct ReadingsView_Previews: PreviewProvider {
//  static var previews: some View {
//    ReadingsView()
//  }
//}


struct ContentView: View {
  
  @EnvironmentObject var model: WxModel

  var body: some View {
    ReadingsView(
      timestamp: model.time,
      temp: model.temp,
      humid: model.humid,
      wind: model.wind,
      baro: model.baro
    )
    .fixedSize()
//    Text(model.time)
//      .multilineTextAlignment(.center)
//      .font(.system(.largeTitle, design: .monospaced))
//      .foregroundColor(.blue)
//      .padding()
//    Text(model.temp)
//      .font(.system(.largeTitle, design: .monospaced))
//      .foregroundColor(.blue)
//      .padding()
//    Text(model.humid)
//      .font(.system(.largeTitle, design: .monospaced))
//      .foregroundColor(.blue)
//      .padding()
//    Text(model.wind)
//      .font(.system(.largeTitle, design: .monospaced))
//      .foregroundColor(.blue)
//      .padding()
  }
}

//struct ContentView_Previews: PreviewProvider {
//  static var previews: some View {
//    ContentView()
//  }
//}
