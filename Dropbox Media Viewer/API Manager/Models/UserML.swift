//
//  UserML.swift
//  Dropbox Media Viewer
//
//  Created by Shumakov Dmytro on 29.08.2023.
//

import Foundation


// MARK: - User Model Structure -

struct UserML: Codable {
    
    let id: String?
    let name: String?
    let email: String?
    let photoURL: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, email, photoURL
    }    
}

extension UserML: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        let id = lhs.id == rhs.id
        
        return id
    }
}

extension UserML {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try? values.decode(String.self, forKey: .id)
        name = try? values.decode(String.self, forKey: .name)
        email = try? values.decode(String.self, forKey: .email)
        photoURL = try? values.decode(String.self, forKey: .photoURL)
    }
}
