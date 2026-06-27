//
//  Attraction.swift
//  PhantaWatch Watch App
//
//  Created by Nicolas Helbig on 27.06.26.
//

import Foundation
import Combine

class Attractions: ObservableObject {
    @Published var sharedList: [ThemeArea] = []
    static let favouriteRides: [Int] = [
        6825,  // Black Mamba
        5020,  // Crazy Bats
        6828,  // Winja's Fear
        6830,  // Winja's Force
        6814,  // Chiapas
        11815, // Colorado
        6812,  // Talocan
        6807,  // Mystery Castle
        6806,  // Raik
        6808,  // River Quest
        6805,  // Taron
        8236   // F.L.Y.
        ]

    @MainActor
    func populate() async {
        guard let url = URL(string: "https://queue-times.com/parks/56/queue_times.json") else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let response = try decoder.decode(QueueTimesResponse.self, from: data)
            sharedList = response.lands
        } catch {
            print("Fetch error: \(error)")
        }
    }
}

struct QueueTimesResponse: Identifiable, Codable {
    let id = UUID()
    let lands: [ThemeArea]
}

struct ThemeArea: Identifiable, Codable{
    let id: Int
    let name: String
    let rides: [Attraction]
}

struct Attraction: Identifiable, Codable{
    let id: Int
    let name: String
    let is_open: Bool
    let wait_time: Int
    let last_updated: Date
}
