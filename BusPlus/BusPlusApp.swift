//
//  BusPlusApp.swift
//  BusPlus
//
//  Created by Robin Phillips on 03/08/2021.
//

import SwiftUI

@MainActor
class TicketInfo: ObservableObject {
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var ticketNumber = ""
    
    var identifier: String {
        firstName + lastName + ticketNumber
    }
}

@main
struct BusPlusApp: App {
    @StateObject private var ticketInfo = TicketInfo()
    
    var body: some Scene {
        WindowGroup {
            TabView {
                ContentView()
                    .tabItem {
                        Image(systemName: "bus")
                        Text("Buses")
                    }
                
                TicketView()
                    .tabItem {
                        Image(systemName: "qrcode")
                        Text("Tickets")
                    }
                    .badge(ticketInfo.identifier.isEmpty ? "!" : nil)
                
            }
            .environmentObject(ticketInfo)
        }
        
    }
}
