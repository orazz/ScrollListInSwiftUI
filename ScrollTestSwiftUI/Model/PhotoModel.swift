//
//  models.swift
//  ScrollTestSwiftui
//
//  Created by atakishiyev on 4/14/24.
//

import Foundation

// MARK: - Photo
struct Photo: Codable, Identifiable, Equatable, Hashable {
    
    let id = UUID().uuidString
    let createdAt, updatedAt, promotedAt: String?
    let width, height: Int
    let color, description: String?
    let urls: Urls
    let links: PhotoLinks
    let likes: Int
    let likedByUser: Bool?
    let topicSubmissions: TopicSubmissions?
    let assetType: String?
    let user: User

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case promotedAt 
        case width, height, color
        case description
        case urls, links, likes
        case likedByUser
        case topicSubmissions
        case assetType
        case user
    }
    
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        lhs.id == rhs.id
    }
    
    var scaleToFit: CGFloat {
        let widthScale = screenWidth / CGFloat(width)
        let heightScale = screenHeight / CGFloat(height)

        return min(widthScale, heightScale)
    }
    
    var imageWidth: CGFloat {
        return scaleToFit * CGFloat(width)
    }
    
    var imageHeight: CGFloat {
        return scaleToFit * CGFloat(height)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct User: Codable {
    let id: String
    let username, name, firstName, lastName: String?
    let profileImage: ProfileImage

    enum CodingKeys: String, CodingKey {
        case id
        case username, name
        case firstName
        case lastName
        case profileImage = "profile_image"
    }
}

struct ProfileImage: Codable {
    let small, medium, large: String
}

// MARK: - PhotoLinks
struct PhotoLinks: Codable {
    let html, download, downloadLocation: String?

    enum CodingKeys: String, CodingKey {
        case html, download
        case downloadLocation
    }
}

// MARK: - TopicSubmissions
struct TopicSubmissions: Codable {
    let people: People
}

// MARK: - People
struct People: Codable {
    let status: String
    let approvedOn: Date

    enum CodingKeys: String, CodingKey {
        case status
        case approvedOn
    }
}

// MARK: - Urls
struct Urls: Codable {
    let raw, full, regular, small: String
    let thumb: String

    enum CodingKeys: String, CodingKey {
        case raw, full, regular, small, thumb
    }
}

typealias Photos = [Photo]

