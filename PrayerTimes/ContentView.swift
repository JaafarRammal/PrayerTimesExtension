//
//  ContentView.swift
//  PrayerTimes
//
//  Created by Jaafar Rammal on 6/24/20.
//  Copyright © 2020 Jaafar Rammal. All rights reserved.
//

import SwiftUI

let date = NSDate() // Get Todays Date
let dateFormatter = DateFormatter()

struct Prayer{
    var name: String;
    var time: String;
}

struct PrayersView: View {
    
    var prayers: [Prayer] = [
        Prayer(name: "Imsak\t\t\t",     time: ""),
        Prayer(name: "Fajr\t\t\t\t",    time: ""),
        Prayer(name: "Sunrise\t\t\t",   time: ""),
        Prayer(name: "Duhr\t\t\t",      time: ""),
        Prayer(name: "Maghrib\t\t",     time: ""),
    ]
    
    var today = ""
    
    var body: some View {
        
        VStack{
            VStack(alignment: .center) {
                Text("Prayer Times").font(.headline)
            }
            List(prayers, id: \.name){ i in
                VStack(alignment: .leading) {
                    Text(i.name).font(.subheadline)
                }
                VStack(alignment: .trailing){
                    Text(i.time).font(.subheadline)
                }
            }
            VStack(alignment: .center) {
                Text(today).font(.headline)
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PrayersView()
    }
}
