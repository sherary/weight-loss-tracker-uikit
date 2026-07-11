import Foundation

internal struct Bio: Codable {
    var id: Int
    var userId: UUID
    var age: Int
    var activityLevel: String
    var weight: Double
    var tdee: Double
    var bmr: Double
    var inputDate = Date()
    
    init(id: Int = 0, userId: UUID, age: Int, activityLevel: String, weight: Double, tdee: Double, bmr: Double) {
        self.userId = userId
        self.age = age
        self.activityLevel = activityLevel
        self.weight = weight
        self.tdee = tdee
        self.bmr = bmr
        self.id = id
    }
}

internal struct Users: Codable {
    var id = UUID()
    var credentialId: UUID
    var firstName: String
    var lastName: String
    var height: Double?
    var gender: Int?
    var avatar: String?
    var bio: Bio?
    
    init(credentialId: UUID = UUID(), firstName: String, lastName: String, height: Double? = 0, gender: Int? = 0, avatar: String? = Empty.String) {
        self.credentialId = credentialId
        self.firstName = firstName
        self.lastName = lastName
        self.height = height
        self.gender = gender
        self.avatar = avatar
    }
}

internal struct Credentials: Codable {
    var id = UUID()
    var username: String
    var password: String
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}
