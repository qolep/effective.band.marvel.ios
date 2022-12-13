import Foundation

protocol ListViewModelProtocol: AnyObject {
    var items: [ItemCard] { get }
    var itemsPublisher: Published<[ItemCard]>.Publisher { get }
    var isLoading: Bool { get }
    func refresh()
    func loadMoreIfNeeded()
}
