//
//  AppDelegate.swift
//  PrayerTimes
//
//  Created by Jaafar Rammal on 6/24/20.
//  Copyright © 2020 Jaafar Rammal. All rights reserved.
//


import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var popover: NSPopover!
    var statusBarItem: NSStatusItem!
    
    // Create the SwiftUI view that provides the window contents.
    var contentView = PrayersView()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the popover
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 200, height: 220)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: contentView)
        self.popover = popover
        
        // Create the status item
        self.statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))
        
        if let button = self.statusBarItem.button {
            button.image = NSImage(named: "Icon")
            button.action = #selector(togglePopover(_:))
        }
        updateTimes()
    }
    
    func updateTimes(){
        
        let d_date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let stringDate: String = dateFormatter.string(from: d_date as Date)
        self.contentView.today = stringDate
        
        let fileName = "Timings"
        let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        let fileURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("txt")
//        print("FilePath: \(fileURL.path)")
        
        var readString = ""
        do {
            readString = try String(contentsOf: fileURL)
        } catch let error as NSError {
            print("Failed reading from URL: \(fileURL), Error: " + error.localizedDescription)
        }
        let out : [[String]] = readString
            .components(separatedBy: "\n").map({$0.components(separatedBy: ",")})
        
        let date = Date()
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
//        print(out[2][2].description)
//        print(month.description)
//        print(day.description)
        var current: [String] = []
        for entry in out{
            if(entry[0].description == month.description && entry[1].description == day.description){
                current = entry
                break
            }
        }
        
        current[5] = current[5].replacingOccurrences(of: "13.", with: "1.")
        current[7] = current[7].replacingOccurrences(of: "\r", with: "")
        for i in 0...current.count-1{
            current[i] = current[i].replacingOccurrences(of: ".", with: ":")
        }
        
        self.contentView.prayers[0].time = "\(current[2])\tam"
        self.contentView.prayers[1].time = "\(current[3])\tam"
        self.contentView.prayers[2].time = "\(current[4])\tam"
        self.contentView.prayers[3].time = "\(current[5])\tpm"
        self.contentView.prayers[4].time = "\(current[7])\tpm"
        popover.contentViewController = NSHostingController(rootView: contentView)
        popover.contentSize = NSSize(width: 200, height: 220)
    }
    
    @IBAction func refresh(_ sender: Any) {
        updateTimes()
    }
    
    @objc func togglePopover(_ sender: AnyObject?) {
        if let button = self.statusBarItem.button {
            if self.popover.isShown {
                self.popover.performClose(sender)
            } else {
                self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            }
        }
    }
    
}
