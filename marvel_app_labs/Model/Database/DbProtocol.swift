import RealmSwift

protocol DbProtocol: AnyObject {
    func write(hero: HeroModel)
    func writeAll(hero: [HeroModel])
    func getAll() -> [HeroModel]
    func getHero(id: Int) -> HeroModel?
}
