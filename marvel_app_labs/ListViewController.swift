import UIKit
import SnapKit
import Kingfisher

    class ListViewController: UIViewController {
    private let heroList = HeroList()
    private let background = BackgroundColor(frame: .zero)
    private let marvelLogo: UIImageView = {
        let logo = UIImageView()
        logo.image = UIImage(named: "marvel_logo")
        return logo
    }()

    private let chooseYourHeroText: UILabel = {
        let text = UILabel()
        text.text = "Choose your hero"
        text.textColor = .white
        text.font = UIFont(name: "Roboto", size: 30)
        text.textAlignment = .center
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = PagingCollectionViewLayout()
        layout.itemSize = Static.collectionViewCardItemSize
        layout.minimumLineSpacing = Static
            .itemSpasing
        layout.scrollDirection = .horizontal
        layout.sectionInset = Static.collectionViewLayoutInset
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
        view.addSubview(background)
        view.addSubview(marvelLogo)
        view.addSubview(chooseYourHeroText)
        registerCollectionViewCells()
        view.addSubview(collectionView)
        background.setTriangleColor(heroList.get(0).color)
        setLayout()
    }

    private func setLayout() {
        background.snp.makeConstraints { make in
            make.edges.equalTo(view.snp.edges)
        }
        marvelLogo.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(view).offset(70.0)
            make.size.equalTo(CGSize(width: 140, height: 30))
        }
        chooseYourHeroText.snp.makeConstraints { make in
            make.top.equalTo(marvelLogo.snp.bottom).offset(20)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
        }
        collectionView.snp.makeConstraints { make in
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.top.equalTo(chooseYourHeroText.snp.bottom).offset(10)
            make.bottom.equalTo(view.snp.bottom).offset(-30)
        }
    }

    private func registerCollectionViewCells() {
        collectionView.register(CollectionViewCard.self, forCellWithReuseIdentifier: String(describing: CollectionViewCard.self))
    }
}

extension ListViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return heroList.count()
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CollectionViewCard.self), for: indexPath) as? CollectionViewCard
        else {
            return .init()
        }
        cell.setup(heroData: heroList.get(indexPath.item))
        return cell
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView is UICollectionView else { return }
        let centerPoint = CGPoint(x: scrollView.frame.size.width / 2 + scrollView.contentOffset.x,
                                  y: scrollView.frame.size.height / 2 + scrollView.contentOffset.y)
        if let indexPath = collectionView.indexPathForItem(at: centerPoint) {
            background.setTriangleColor(heroList.get(indexPath.row).color)
        }
    }
}
