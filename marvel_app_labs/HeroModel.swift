import UIKit

struct HeroModel {
    let name: String
    let image: UIImage?
    let color: UIColor
    init(name: String, image: UIImage?, color: UIColor) {
        self.name = name
        self.image = image
        self.color = color
    }
}
