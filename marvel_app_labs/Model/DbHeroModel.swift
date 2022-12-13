import RealmSwift

final class DbHeroModel: Object {
    @Persisted(primaryKey: true) var heroId: Int
    @Persisted var name: String
    @Persisted var ImageURL: String
    @Persisted var Description: String
    convenience init(id: Int, name: String, imageURL: String, description: String) {
        self.init()
        self.heroId = id
        self.name = name
        self.Description = description
        if imageURL.hasSuffix("jpg") {
            self.ImageURL = imageURL
        } else {
            self.ImageURL = imageURL + "/portrait_uncanny.jpg"
        }
    }
    convenience init(_ heroModel:HeroModel) {
        self.init()
        self.heroId = heroModel.heroId
        self.name = heroModel.name
        self.Description = heroModel.description
        self.ImageURL = heroModel.ImageURL
    }
}
