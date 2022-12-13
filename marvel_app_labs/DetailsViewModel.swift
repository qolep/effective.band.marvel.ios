import Foundation

class DetailsViewModel{
    private let repository = Repository()
    func getHero(id: Int, completion: @escaping ((HeroModel?) -> Void)){
        repository.getHero(id: id, completion)
    }
}
