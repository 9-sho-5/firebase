import Foundation

class Message {
    private var id: UUID
    private var text: String
    private var userId: String
    private var createdAt: Date
    
    init(id: UUID, text: String, userId: String, createdAt: Date) {
        self.id = id
        self.text = text
        self.userId = userId
        self.createdAt = createdAt
    }
    
    public func getId() -> UUID {
        return id
    }
    
    public func getText() -> String {
        return text
    }
    
    public func getUserId() -> String {
        return userId
    }
    
    public func getCreatedAt() -> Date {
        return createdAt
    }
    
}
