//
//  ContentView.swift
//  BusPlus
//
//  Created by Robin Phillips on 03/08/2021.
//

import SwiftUI
import Foundation
import MapKit


extension URLSession {
    func decode<T: Decodable>(
        _ type: T.Type = T.self,
        from url: URL,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,
        dataDecodingStrategy: JSONDecoder.DataDecodingStrategy = .deferredToData,
        dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate
    ) async throws -> T {
        let (data, _) = try await data(from: url)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = keyDecodingStrategy
        decoder.dataDecodingStrategy = dataDecodingStrategy
        decoder.dateDecodingStrategy = dateDecodingStrategy
        
        let decoded = try decoder.decode(T.self, from: data)
        return decoded
    }
}

class BusInfo: ObservableObject {
    @Published var buses = [Bus]()
}

struct Bus: Codable, Hashable {
    let id: Int
    let name: String
    let location: String
    let destination: String
    let passengers: Int
    let fuel: Int
    let image: String
    
    
    
    static var example: Bus {
        let bus = Bus(id: 220, name: "Bussy McBusface", location: "South Brent", destination: "Totnes", passengers: 20, fuel: 30, image: "Image(systemName: \"bus\")")
        return bus
    }
    
}


struct ContentView: View {
    @State private var search = ""
    
    @State private var buses = [Bus]()
    @State private var favorites = Set<Bus>()
    
    @EnvironmentObject var ticketInfo: TicketInfo
    
    @State private var selectedBus: Bus?
    
    
    
    var filteredData: [Bus] {
        if search.isEmpty {
            return buses
        } else {
            return buses.filter {
                $0.name.localizedCaseInsensitiveContains(search)
                || $0.location.localizedCaseInsensitiveContains(search)
                || $0.destination.localizedCaseInsensitiveContains(search)
            }
        }
    }
    
    
    
    
    var body: some View {
        
        TabView {
            NavigationView {
                ZStack {
                    List(filteredData, id:\.id) { bus in
                        
                        BusRowView(bus: bus, isFavorite: favorites.contains(bus))
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                
                                Button {
                                    toggle(favorite: bus)
                                } label: {
                                    if favorites.contains(bus) {
                                        Label("Remove favorite", systemImage: "heart.slash")
                                    } else {
                                        Label("Add favorite", systemImage: "heart.fill")
                                    }
                                }
                                .tint(.green)
                                
                            }
                            .listStyle(PlainListStyle())
                            .listRowSeparator(.visible)
                            .listRowSeparatorTint(Color.blue)
                            .onTapGesture {
                                selectedBus = bus
                            }
                        
                        
                    }
                    .navigationTitle("BusPlus")
                    .task {
                        loadData()
                    }
                    .refreshable { loadData() }
                    .searchable(text: $search.animation(), prompt: "Filter")
                    
                    if let selectedBus = selectedBus {
                        AsyncImage(url: URL(string: selectedBus.image)) { image in
                            image
                                .resizable()
                                .cornerRadius(10)
                        } placeholder: {
                            Image(systemName: "bus")
                        }
                        .frame(width: 275, height: 275)
                        .padding(20)
                        .background(.ultraThinMaterial)
                        .cornerRadius(25)
                        .onTapGesture {
                            self.selectedBus = nil
                        }
                    }
                }
            }
        }
    }
    
    
    func loadData() {
        Task {
            let busURL = URL(string: "https://www.hackingwithswift.com/samples/bus-timetable")!
            buses = try await URLSession.shared.decode(from: busURL)
        }
    }
    
    func toggle(favorite bus: Bus) {
        if favorites.contains(bus) {
            favorites.remove(bus)
        } else {
            favorites.insert(bus)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



