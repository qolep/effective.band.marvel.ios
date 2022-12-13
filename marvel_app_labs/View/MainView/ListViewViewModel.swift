import Foundation
import RealmSwift

enum ItemCard {
    case hero(model: HeroModel)
    case loading
}
final class ListViewViewModel: ListViewModelProtocol {
    var isLoading = false
    @Published private(set) var items: [ItemCard] = []
    var itemsPublisher: Published<[ItemCard]>.Publisher { $items }
    private let repository = Repository()
    private var offset: Int = 0 {
        willSet { NSLog("\nNew offset = \(newValue)\n") }
    }
    let realm = try? Realm()
    private func loadMoreHero() {
        guard !isLoading else { return }
        isLoading = true
        items.append(.loading)
        repository.getHeroes(offset: self.offset) { [weak self] heroModelArray in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.items.removeAll(where: {
                    switch $0 {
                    case .loading:
                        return true
                    case .hero:
                        return false
                    }
                })
                let newHeroesArray = heroModelArray.map { ItemCard.hero(model: $0) }
                self.items.append(contentsOf: newHeroesArray)
                self.offset += heroModelArray.count
                self.isLoading = false
            }
        }
    }
    func loadMoreIfNeeded() {
        loadMoreHero()
    }
    func refresh() {
        items.removeAll(keepingCapacity: true)
        offset = 0
        loadMoreHero()
    }
}
