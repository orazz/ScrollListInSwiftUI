//
//  NetworkManager.swift
//  ScrollTestSwiftui
//
//  Created by atakishiyev on 4/14/24.
//

import Foundation

fileprivate var clientID: String = ""

enum AppError: Error {
    case serverError(String)
}

final class NetworkManager {
    
    static var shared = NetworkManager()
    private var session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func fetchData<T: Decodable>(page: Int) async throws -> T {
        let endpoint: String = "https://api.unsplash.com/photos?page=\(page)"
        guard let url = URL(string: endpoint) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Client-ID \(clientID)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw AppError.serverError(String(data: data, encoding: .utf8)!)
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}
