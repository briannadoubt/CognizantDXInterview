//
//  WebServiceActor.swift
//  BriannaAndCognizantDX
//
//  Created by Bri on 2/10/22.
//

import SwiftUI

enum GitHubError: Error {
    case badURL
    // TODO: Add localizedDescription
}

struct GitHubUser: Codable, Identifiable {
    
    var username: String?
    var id: Int?
    var avatarUrl: URL?
    
    enum CodingKeys: String, CodingKey {
        case username = "login"
        case id
        case avatarUrl = "avatar_url"
    }
}

class WebServiceActor: ObservableObject {
    
    @Published var users: [GitHubUser] = []
    
    @MainActor func setUsers(_ value: [GitHubUser]) {
        self.users = value
    }
    
    func getUsers(_ completion: ((_ error: Error?) -> ())? = nil) throws {
        guard let url = URL(string: "https://api.github.com/users") else {
            throw GitHubError.badURL
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let decoder = JSONDecoder()
            if let error = error {
                completion?(error)
            }
            guard let data = data else {
                assertionFailure("No data")
                return
            }
            do {
                let newUsers = try decoder.decode([GitHubUser].self, from: data)
                Task {
                    await self.setUsers(newUsers)
                }
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
        task.resume()
    }
}
