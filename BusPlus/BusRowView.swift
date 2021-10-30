//
//  BusRowView.swift
//  BusRowView
//
//  Created by Robin Phillips on 13/09/2021.
//

import SwiftUI

struct BusRowView: View {
    var bus: Bus
    
    var isFavorite: Bool
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    
                    
                    VStack {
                        MapView(searchString: bus.location)
                            .background(Color.red)
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                        
                    }
                    
                }
                .padding(.vertical, 5.0)
            }
            .frame(height: 150)
            
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text("**\(bus.name)**")
                        if isFavorite {
                            Image(systemName: "heart.fill").foregroundColor(.red)
                        }
                    }
                    
                    HStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            Text("From: **\(bus.location)**")
                                .font(.caption)
                            Text("To: **\(bus.destination)**")
                                .font(.caption)
                            HStack {
                                HStack {
                                    Text("**\(bus.fuel)%**")
                                        .font(.caption)
                                    Image(systemName: "fuelpump")
                                        .foregroundColor(bus.fuel < 50 ? .red : .blue)
                                }
                                .frame(width: 70, height: 20)
                                .padding(5)
                                
                                .clipShape(Capsule())
                                .overlay(Capsule().stroke(Color.black.opacity(0.2), lineWidth: 1))
                                .padding(3)
                                
                                HStack {
                                    Text("**\(bus.passengers)**")
                                        .font(.caption)
                                    Image(systemName: "person.3.sequence.fill")
                                        .foregroundStyle(.red, .blue, .yellow)
                                }
                                .frame(width: 70, height: 20)
                                .padding(5)
                                
                                .clipShape(Capsule())
                                .overlay(Capsule().stroke(Color.black.opacity(0.2), lineWidth: 1))
                                .padding(3)
                                .layoutPriority(1)
                            }
                        }
                        
                    }
                    .layoutPriority(1)
                    
                }
                Spacer()
                VStack {
                    if bus == Bus.example {
                        Image(systemName: "bus")
                            .resizable()
                            .scaledToFit()
                    } else {
                        ZStack(alignment: .bottomTrailing) {
                            AsyncImage(url: URL(string: bus.image)) { image in
                                image.resizable()
                                    .scaledToFit()
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                            } placeholder: {
                                Image(systemName: "arrow.clockwise")
                            }
                            
                        }
                        
                    }
                    
                }
                .frame(height: 100)
            }
            
        }
    }
}

struct BusRowView_Previews: PreviewProvider {
    static var previews: some View {
        BusRowView(bus: Bus.example, isFavorite: true)
    }
}
