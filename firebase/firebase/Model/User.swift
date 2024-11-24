class User {
    private var displayName: String
    private var email: String
    private var imageURL: String
    
    init(displayName: String, email: String, imageURL: String) {
        self.displayName = displayName
        self.email = email
        self.imageURL = imageURL
    }
    
    public func getDisplayName() -> String {
        return displayName
    }
    
    public func getEmail() -> String {
        return email
    }
    
    public func getImageURL() -> String {
        return imageURL
    }
}
