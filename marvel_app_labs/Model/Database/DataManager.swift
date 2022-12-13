import RealmSwift
import Foundation

final class DataManager {
    let realm: Realm?
    init() {
        self.realm = try? Realm()
    }
    func write(object: Object) {
    }
    func get<T: Object> (id: Int) -> T? {
        return nil
    }
    func getAll<T: Object> () -> [T]? {
        return nil
    }
}
extension DataManager: DbProtocol {
    func getHero(id: Int) -> HeroModel? {
        guard let model = realm?.object(ofType: DbHeroModel.self, forPrimaryKey: id) else { return nil }
        return HeroModel(realmModel: model)
    }
    func write(hero: HeroModel) {
        try? realm?.write { realm?.add(DbHeroModel(hero), update: .modified) }
    }
    func writeAll(hero: [HeroModel]) {
        let modelsArray = hero.map { DbHeroModel($0) }
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            try? self.realm?.write { self.realm?.add(modelsArray, update: .modified) }
        }
    }
    func getAll() -> [HeroModel] {
        guard let heroResults = self.realm?.objects(DbHeroModel.self) else { return [] }
        return heroResults.compactMap { HeroModel(realmModel: $0) }
    }
}
extension HeroModel {
    convenience init? (realmModel: DbHeroModel) {
        self.init(id: realmModel.heroId, name: realmModel.name, imageURL: realmModel.ImageURL, description: realmModel.Description)
    }
}
