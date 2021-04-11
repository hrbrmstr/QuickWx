//
//  model.swift
//  QuickWx
//
//  Created by boB Rudis on 4/9/21.
//

import Foundation
import SwiftUI

class WxModel: ObservableObject {
  
  @AppStorage("ipPort") private var ipPort: String?

  @Published var time: String = ""
  @Published var temp: String = ""
  @Published var humid: String = ""
  @Published var wind: String = ""
  @Published var rain: String = ""
  @Published var baro: String = ""
  @Published var barTrend: String = ""
  @Published var live: Bool = false
  
  let barSymbol = "barometer"
  let tempSumbol = "thermometer"
  let windSymbol = "wind"
  let rainSymbol = "cloud.rain.fill"
  let humidSymbol = "drop.fill"
  let riseSymbol = "arrow.up.circle.fill"
  let fallSymbol = "arrow.down.circle.fill"
  let steadySymbol = "line.horizontal.3.circle.fill"
  
  let dateFormatter = DateFormatter()
  
  weak var timer: Timer?
  let shortTimerDuration = 1.0
  let longTimerDuration = 15.0
  
  func updateConditions() {
    
    if (ipPort != nil) {
      let wxURL = URL(string: "http://\(ipPort!)/v1/current_conditions")!
      
      let task = URLSession.shared.weatherLinkTask(with: wxURL) { weatherLink, response, error in

        if let error = error {
          DispatchQueue.main.async { self.live = false }
          debugPrint("Error: \(error)")
          return
        }
        
        let response = response as! HTTPURLResponse

        let status = response.statusCode
        guard (200...299).contains(status) else {
          DispatchQueue.main.async { self.live = false }
          return
        }
        
        if let weatherLink = weatherLink {
          
          let date = Date(timeIntervalSince1970: Double((weatherLink.data?.ts!)!))
          
          if (weatherLink.data?.conditions?[0]["data_structure_type"]! == 1) {
            
            let temp: Double = weatherLink.data?.conditions?[0]["temp"]! ?? -99.0
            let humid: Double = weatherLink.data?.conditions?[0]["hum"]! ?? -99.0
            let wind: Double = weatherLink.data?.conditions?[0]["wind_speed_avg_last_10_min"]! ?? -99.0
            let rain: Double = weatherLink.data?.conditions?[0]["rainfall_last_24_hr"]! ?? -99.0
          
            let barSea: Double = weatherLink.data?.conditions?[2]["bar_sea_level"]! ?? -99.0
            let barTrend: Double = weatherLink.data?.conditions?[2]["bar_trend"]! ?? -99.0
            
            DispatchQueue.main.async {
              
              self.live = true
              
              self.time = self.dateFormatter.string(from: date)
              
              self.temp = String(format: "%3.1f", temp)
              self.humid = String(format: "%3.1f", humid)
              self.wind = String(format: "%3.1f", wind)
              self.rain = String(format: "%3.1f", rain)
              self.baro = String(format: "%2.2f", barSea)
              self.barTrend = String(format: "%3.1f", barTrend)
              
            }
            
          } else {
            DispatchQueue.main.async { self.live = false }
          }
          
        } else {
          DispatchQueue.main.async { self.live = false }
        }
      }
      task.resume()
      
    }
  }
  
  init() {
    
    dateFormatter.timeZone = TimeZone(abbreviation: "EST5EDT") //Set timezone that you want
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" //Specify your format that you want

    startTimer()
    
  }
  
  deinit {
    stopTimer()
  }
  
  func startTimer() {
    stopTimer()
    timer = Timer.scheduledTimer(withTimeInterval: shortTimerDuration, repeats: false) { [weak self] _ in
      self?.updateConditions()
      self?.startLongerTimer()
    }
  }
  
  func startLongerTimer() {
    stopTimer()
    timer = Timer.scheduledTimer(withTimeInterval: longTimerDuration, repeats: true) { [weak self] _ in // TODO: make this configurable
      self?.updateConditions()
    }
  }
  
  func stopTimer() {
    timer?.invalidate()
  }
  
  
}
