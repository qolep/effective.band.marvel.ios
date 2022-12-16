import UIKit
import SnapKit

final class ListViewController: UIViewController {
    private let heroList = HeroList()
    private let background = BackgroundColor(frame: .zero)
    private var currentSelectedItemIndex = 0
    private var detailsTransfer: DetailsTransferManager?
    private let detailsViewController = DetailsViewController()
    private let logoImage: UIImageView = {
        let logo = UIImageView()
        logo.image = UIImage(named: "marvel_logo")
        return logo
    }()
    private let titleTextLabel: UILabel = {
        let titleTextLabel = UILabel()
        titleTextLabel.text = "Choose your hero"
        titleTextLabel.textColor = .white
        titleTextLabel.font = UIFont(name: "Roboto-Black", size: 37)
        titleTextLabel.textAlignment = .center
        titleTextLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleTextLabel
    }()
    private lazy var collectionView: UICollectionView = {
        let layout = PagingCollectionViewLayout()
         layout.itemSize = Static.collectionViewCardItemSize
        layout.minimumLineSpacing = Static.itemSpacing
        layout.sectionInset = Static.collectionViewLayoutInset
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.decelerationRate = .fast
        collectionView.backgroundColor = .none
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.addSubview(background)
        view.addSubview(logoImage)
        view.addSubview(titleTextLabel)
        registerCollectionViewCards()
        view.addSubview(collectionView)
        background.setTriangleColor(heroList.get(0).color)
        setLayout()
    }
    private func setLayout() {
        background.snp.makeConstraints { make in
            make.edges.equalTo(view.snp.edges)
        }
        logoImage.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(view).offset(70.0)
            make.size.equalTo(CGSize(width: 140, height: 30))
        }
        titleTextLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImage.snp.bottom).offset(20)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
        }
        collectionView.snp.makeConstraints { make in
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.top.equalTo(titleTextLabel.snp.bottom).offset(10)
            make.bottom.equalTo(view.snp.bottom).offset(-30)
        }
    }
    private func registerCollectionViewCards() {
        collectionView.register(CollectionViewCard.self,
                                forCellWithReuseIdentifier: String(describing: CollectionViewCard.self))
    }
}
extension ListViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    private enum Static{
        static var collectionViewLayoutInset : UIEdgeInsets{UIEdgeInsets(top: 0, left: 60, bottom: 0, right: 60)}
        static var itemSpacing: Double{40.0}
        static var collectionViewCardItemSize: CGSize{CGSize(width: UIScreen.main.bounds.width - 100, height: UIScreen.main.bounds.height - 250)}
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return heroList.count()
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: CollectionViewCard.self),
            for: indexPath) as? CollectionViewCard else {
            return .init()
        }
        let tag = indexPath.item + 1
        cell.setup(heroData: heroList.get(indexPath.item), and: tag)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tag = indexPath.row + 1
        let heroData = heroList.get(indexPath.item)
        let detailsTransfer = DetailsTransferManager(anchorViewTag: tag)
        detailsViewController.setup(heroData: heroData, tag: tag)
        detailsViewController.modalPresentationStyle = .custom
        detailsViewController.transitioningDelegate = detailsTransfer
        present(detailsViewController, animated: true)
        self.detailsTransfer = detailsTransfer
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView is UICollectionView else { return }
        let centerPoint = CGPoint(x: scrollView.frame.size.width / 2 + scrollView.contentOffset.x,
                                  y: scrollView.frame.size.height / 2 + scrollView.contentOffset.y)
        if let indexPath = collectionView.indexPathForItem(at: centerPoint) {
            currentSelectedItemIndex = indexPath.row
            background.setTriangleColor(heroList.get(indexPath.row).color)
        }
    }
}
