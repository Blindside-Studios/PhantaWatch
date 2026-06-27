//
//  ContentView.swift
//  PhantaWatch Watch App
//
//  Created by Nicolas Helbig on 27.06.26.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var attractionsList: Attractions
    var favouriteRides: [Attraction] {
        attractionsList.sharedList
            .flatMap(\.rides)
            .filter { Attractions.favouriteRides.contains($0.id) }
            .sorted {
                // show closed rides at the bottom, filter the rest by queue time
                if $0.is_open != $1.is_open { return $0.is_open }
                return $0.wait_time < $1.wait_time
            }
    }
    @Environment(\.openURL) var openURL
    
    var body: some View {
        List{
            Section("Important Rides"){
                ForEach(favouriteRides){ ride in
                    HStack{
                        Text(ride.name)
                        Spacer()
                        Text(ride.is_open ? "\(ride.wait_time) min" : "Closed")
                            .foregroundStyle(ride.is_open ? Color.primary : Color.red)
                            .opacity(0.7)
                    }
                }
            }
            
            ForEach(attractionsList.sharedList) { land in
                Section(land.name){
                    ForEach(land.rides){ ride in
                        HStack{
                            Text(ride.name)
                            Spacer()
                            Text(ride.is_open ? "\(ride.wait_time) min" : "Closed")
                                .foregroundStyle(ride.is_open ? Color.primary : Color.red)
                                .opacity(0.7)
                        }
                    }
                }
            }
            
            Section(footer:
                Text("Powered by Queue-Times.com")
                    .foregroundStyle(.secondary)
                    .onTapGesture {
                        openURL(URL(string: "https://queue-times.com")!)
                    }
            ) { }
        }
        .navigationTitle("Phantasialand")
    }
}
