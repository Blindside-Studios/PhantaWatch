//
//  PhantaWatchApp.swift
//  PhantaWatch Watch App
//
//  Created by Nicolas Helbig on 27.06.26.
//

import SwiftUI

@main
struct PhantaWatch_Watch_AppApp: App {
    @StateObject var attractionsList = Attractions()
    @State var isLoading = false
    @State var hasFinished = false
    
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                ContentView(attractionsList: attractionsList)
                    .task{
                        await refreshTimes()
                    }
                    .toolbar {
                        ToolbarItem(placement: .bottomBar) {
                            HStack{
                                Spacer()
                                if !isLoading{
                                    Button("Refresh", systemImage: hasFinished ? "checkmark" : "arrow.clockwise") {
                                        Task {
                                            await refreshTimes()
                                        }
                                    }
                                    .labelStyle(.iconOnly)
                                } else {
                                    ProgressView()
                                        .progressViewStyle(.circular)
                                }
                            }
                        }
                    }
            }
        }
    }
    
    func refreshTimes() async{
        isLoading = true
        await attractionsList.populate()
        isLoading = false
        hasFinished = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.25) {
            hasFinished = false
        }
    }
}
