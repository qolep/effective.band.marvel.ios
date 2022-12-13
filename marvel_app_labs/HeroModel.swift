import Foundation

final class HeroModel {
    var heroId: Int
    var name: String
    var ImageURL: String
    var description: String
    init(id: Int, name: String, imageURL: String, description: String) {
        self.heroId = id
        self.name = name
        self.description = description
        if imageURL.hasSuffix("jpg") {
            self.ImageURL = imageURL
        } else {
            self.ImageURL = imageURL + "/portrait_uncanny.jpg"
        }
    }
    init(id: Int, name: String?, imageURL: String?, description: String?) {
        self.heroId = id
        self.name = name ?? "No name"
        self.description = description ?? ""
        guard let url = imageURL else { self.ImageURL = ""; return}
        if url.hasSuffix("jpg") {
            self.ImageURL = url
        } else {
            self.ImageURL = url + "/portrait_uncanny.jpg"
        }
    }
}
