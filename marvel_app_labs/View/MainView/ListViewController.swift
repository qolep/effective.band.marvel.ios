import UIKit
import SnapKit
import Combine
import Alamofire
import Kingfisher

final class ListViewController: UIViewController {
    private var subscriptions = Set<AnyCancellable>()
    private let viewModel: ListViewModelProtocol = ListViewViewModel()
    private let background = BackgroundColor(frame: .zero)
    private var currentSelectedItemIndex = 0
    private var detailsTransfer: DetailsTransferManager?
    private let detailsViewController = DetailsViewController()
    private var offset: Int = 0
    private let logoImage: UIImageView = {
        let logo = UIImageView()
        logo.image = UIImage(named: "marvel_logo")
        return logo
    }()
    private lazy var mainScrollView: UIScrollView = {
        let mainScrollView = UIScrollView()
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Reloading data")
        refreshControl.backgroundColor = .systemGray
        refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        mainScrollView.refreshControl = refreshControl
        mainScrollView.showsVerticalScrollIndicator = false
        mainScrollView.showsHorizontalScrollIndicator = false
        return mainScrollView
    }()
    private let contentView = UIView()
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
    @objc func refresh() {
        viewModel.refresh()
        mainScrollView.refreshControl?.endRefreshing()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        setupBindings()
        title = ""
        view.addSubview(mainScrollView)
        mainScrollView.addSubview(contentView)
        contentView.addSubview(background)
        contentView.addSubview(logoImage)
        contentView.addSubview(titleTextLabel)
        registerListViewCard()
        contentView.addSubview(collectionView)
        background.setTriangleColor(.black)
        mainScrollView.contentInsetAdjustmentBehavior = .never
        mainScrollView.alwaysBounceHorizontal = false
        mainScrollView.alwaysBounceVertical = true
        viewModel.loadMoreIfNeeded()
        setLayout()
    }
    private func setLayout() {
        mainScrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.snp.edges)
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalToSuperview()
        }
        background.snp.makeConstraints { make in
            make.edges.equalTo(contentView.snp.edges)
        }
        logoImage.snp.makeConstraints { make in
            make.centerX.equalTo(contentView.snp.centerX)
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(10)
            make.size.equalTo(CGSize(width: 140, height: 30))
        }
        titleTextLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImage.snp.bottom).offset(20)
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
        }
        collectionView.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.top.equalTo(titleTextLabel.snp.bottom).offset(10)
            make.bottom.equalTo(contentView.snp.bottom).offset(-30)
        }
    }
    private func setupBindings() {
        viewModel.itemsPublisher.sink { [weak self] _ in
            self?.collectionView.reloadData()
        }.store(in: &subscriptions)
    }
    private func registerListViewCard() {
        collectionView.register(CollectionViewCard.self,
                                forCellWithReuseIdentifier: String(describing: CollectionViewCard.self))
        
        collectionView.register(CardLoadingIndicator.self,
                                forCellWithReuseIdentifier: String(describing: CardLoadingIndicator.self))
    }
}
    extension ListViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
        private enum Static{
                static var collectionViewLayoutInset : UIEdgeInsets{UIEdgeInsets(top: 0, left: 60, bottom: 0, right: 60)}
                static var itemSpacing: Double{40.0}
                static var collectionViewCardItemSize: CGSize{CGSize(width: UIScreen.main.bounds.width - 100, height: UIScreen.main.bounds.height - 250)}
            }
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return viewModel.items.count
        }
        func collectionView(_ collectionView: UICollectionView,
                            cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let tag = indexPath.item + 1
            switch viewModel.items[indexPath.item] {
            case .hero(model: let model):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: String(describing: CollectionViewCard.self),
                    for: indexPath) as? CollectionViewCard else {
                    return .init()
                }
                cell.setup(heroModel: model, and: tag)
                return cell
            case .loading:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: String(describing: CardLoadingIndicator.self),
                    for: indexPath) as? CardLoadingIndicator else {
                    return .init()
                }
                cell.setup()
                return cell
            }
        }
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            switch viewModel.items[indexPath.item] {
            case .hero(model: let model):
                let tag = indexPath.row + 1
                let heroData = model
                let detailsTransferManager = DetailsTransferManager(anchorViewTag: tag)
                detailsViewController.setup(heroData: heroData, tag: tag)
                detailsViewController.modalPresentationStyle = .custom
                detailsViewController.transitioningDelegate = detailsTransferManager
                present(detailsViewController, animated: true)
                self.detailsTransfer = detailsTransferManager
            case .loading:
                break
            }
        }
        func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            if indexPath.row == viewModel.items.count - 1 {
                viewModel.loadMoreIfNeeded()
            }
            /*
             should add background triangle color somehow. Idea: find average color of pic.
             */
        }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let size = Static.collectionViewCardItemSize
            let cardWidth = (indexPath.row == viewModel.items.count && viewModel.isLoading ) ? 40 : size.width
            return CGSize(width: cardWidth, height: size.height)
        }
    }
