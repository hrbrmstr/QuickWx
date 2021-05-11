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

struct SparklineChart: View {
    var values: [Float]
    var color: Color

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(NSColor.controlBackgroundColor).opacity(0.8))
                .cornerRadius(2.0)
            Sparkline(values: values).fill(color.opacity(0.7))
            
            let maxValue = values.max() ?? 0.0
            if maxValue > 1.0 {
                Sparkline(values: values.map({ max($0 - 1.0, 0.0) }))
                    .fill(color.opacity(0.5))
            }
            if maxValue > 2.0 {
                Sparkline(values: values.map({ max($0 - 2.0, 0.0) }))
                    .fill(color.opacity(0.5))
            }
            if maxValue > 3.0 {
                Sparkline(values: values.map({ max($0 - 3.0, 0.0) }))
                    .fill(color.opacity(1.0))
            }
        }
    }
    
    struct Sparkline: Shape {
        var values: [Float]

        func path(in rect: CGRect) -> Path {
            var path = Path()
            
            let segmentWidth = rect.maxX / CGFloat(values.count - 1)
            
            path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - (CGFloat(clamp(values[0])) * rect.maxY)))
            
            for (index, value) in values.dropFirst().enumerated() {
                let x = CGFloat(index + 1) * segmentWidth
                let y = rect.maxY - (CGFloat(clamp(value)) * rect.maxY)
                path.addLine(to: CGPoint(x: x, y: y))
            }
            
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            
            return path
        }
        
        func clamp(_ value: Float) -> Float {
            return max(0.0, min(1.0, value))
        }
    }
}

struct Sparkline_Previews: PreviewProvider {
    static let values: [Float] = [
        3.8,
        3.1,
        3.5,
        3.3,
        2.7,
        2.3,
        1.5,
        1.4,
        1.4,
        0.9,
        0.25,
        0.32,
        0.78,
        0.12,
        0.15,
        0.03,
        0.0
    ]
    
    static var previews: some View {
        SparklineChart(values: values, color: .blue).frame(width: 300, height: 40)
    }
}

