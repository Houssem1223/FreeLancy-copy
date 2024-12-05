import Foundation
class User: ObservableObject, Decodable, Identifiable {  // Add Identifiable here
    @Published var username: String
    @Published var email: String
    @Published var password: String
    @Published var skills: String?
    var role: String
    var avatarUrl: String?
    var id: String  // Assuming you have an `id` property, which will be the unique identifier

    // Initializer for the class
    init(username: String, email: String, password: String, role: String, avatarUrl: String?, skills: String?, id: String) {
        self.username = username
        self.email = email
        self.password = password
        self.role = role
        self.avatarUrl = avatarUrl
        self.skills = skills
        self.id = id
    }

    // The required initializer for Decodable
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let username = try container.decode(String.self, forKey: .username)
        let email = try container.decode(String.self, forKey: .email)
        let password = try container.decode(String.self, forKey: .password)
        let role = try container.decodeIfPresent(String.self, forKey: .role) ?? ""
        let avatarUrl = try container.decodeIfPresent(String.self, forKey: .avatarUrl)
        let skills = try container.decodeIfPresent(String.self, forKey: .skills)
        let id = try container.decode(String.self, forKey: .id)  // Assuming you have an `id` field

        self.init(username: username, email: email, password: password, role: role, avatarUrl: avatarUrl, skills: skills, id: id)
    }

    // CodingKeys to map the JSON keys to property names
    enum CodingKeys: String, CodingKey {
        case id  = "_id"
        case username
        case email
        case password
        case role
        case avatarUrl
        case skills
        // Add the id here for decoding
    }
}
