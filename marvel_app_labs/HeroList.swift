import UIKit

struct HeroList {
    private let heroList = [
        HeroModel(name: "Black panther", image: UIImage(named: "black_panther"), color: .black),
        HeroModel(name: "Vision", image: UIImage(named: "vision"), color: .green),
        HeroModel(name: "Deadpool", image: UIImage(named: "deadpool"), color: .red),
        HeroModel(name: "Thanos", image: UIImage(named: "thanos"), color: .purple),
        HeroModel(name: "Iron Man", image: UIImage(named: "iron_man"), color: .yellow),
        HeroModel(name: "Spider Man", image: UIImage(named: "spider_man"), color: .blue),
        HeroModel(name: "Doctor Strange", image: UIImage(named: "dr_strange"), color: .purple),
        HeroModel(name: "Thor", image: UIImage(named: "thor"),   color: .gray)
    ]
    func get(_ index: Int) -> HeroModel {
        return heroList[index]
    }
    func count() -> Int {
        return heroList.count
    }
}
