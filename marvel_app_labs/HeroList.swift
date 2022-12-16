import UIKit

struct HeroList {
    private let heroList = [
        HeroModel(name: "Black panther", imageURL: ImageUrl.black_panther, color: .black, description: Description.black_panther_desc),
        HeroModel(name: "Vision", imageURL: ImageUrl.vision, color: .green, description: Description.vision_desc),
        HeroModel(name: "Deadpool", imageURL: ImageUrl.deadpool, color: .red,
                  description: Description.deadpool_desc),
        HeroModel(name: "Thanos", imageURL: ImageUrl.thanos, color: .purple, description: Description.thanos_desc),
        HeroModel(name: "Iron Man", imageURL: ImageUrl.iron_man, color: .yellow, description: Description.iron_man_desc),
        HeroModel(name: "Spider Man", imageURL: ImageUrl.spider_man, color: .blue, description: Description.spider_man_desc),
        HeroModel(name: "Doctor Strange", imageURL: ImageUrl.dr, color: .purple, description: Description.dr_desc),
        HeroModel(name: "Thor", imageURL: ImageUrl.thor,   color: .gray, description: Description.thor_desc)
    ]
    func get(_ index: Int) -> HeroModel {
        return heroList[index]
    }
    func count() -> Int {
        return heroList.count
    }
}
