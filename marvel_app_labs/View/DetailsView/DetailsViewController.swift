import UIKit
import Kingfisher
import SnapKit

class DetailsViewController: UIViewController {
    private let viewModel = DetailsViewModel()
    private let textOffset = 30
    private let wrapperView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    private let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    private let heroNameTextLabel: UILabel = {
        let heroNameTextLabel = UILabel()
        heroNameTextLabel.font = UIFont(name: "Roboto", size: 24)
        heroNameTextLabel.textColor = .white
        heroNameTextLabel.backgroundColor = UIColor.gray
        return heroNameTextLabel
    }()
    private let heroDescriptionTextLabel: UILabel = {
        let heroDescriptionTextLabel = UILabel()
        heroDescriptionTextLabel.textColor = .white
        heroDescriptionTextLabel.font = UIFont(name: "Roboto-Black", size: 34)
        heroDescriptionTextLabel.lineBreakMode = .byWordWrapping
        heroDescriptionTextLabel.numberOfLines = 0
        heroDescriptionTextLabel.backgroundColor = UIColor.gray
        return heroDescriptionTextLabel
    }()
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    func setup(heroData: HeroModel, tag: Int) {
        heroImageView.image = .init()
        heroDescriptionTextLabel.text = " "
        heroNameTextLabel.text = " "
        wrapperView.tag = tag
        viewModel.getHero(id: heroData.heroId) { [weak self] hero in
            guard let self = self else { return }
            guard let hero = hero else { return }
            self.heroImageView.kf.setImage(with: URL(string: hero.ImageURL))
            self.heroNameTextLabel.text = hero.name
            self.heroDescriptionTextLabel.text = hero.description
                }
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    private func configureUI() {
        view.backgroundColor = .clear
        view.addSubview(wrapperView)
        wrapperView.addSubview(heroImageView)
        wrapperView.addSubview(heroDescriptionTextLabel)
        wrapperView.addSubview(heroNameTextLabel)
        wrapperView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        heroImageView.snp.makeConstraints { make in
            make.edges.equalTo(wrapperView)
        }
        heroDescriptionTextLabel.snp.makeConstraints {
            $0.left.equalTo(wrapperView.snp.left).offset(textOffset)
            $0.right.equalTo(wrapperView.snp.right).offset(-textOffset)
            $0.bottom.equalTo(wrapperView.snp.bottom).offset(-textOffset)
        }
        heroNameTextLabel.snp.makeConstraints {
            $0.left.equalTo(wrapperView.snp.left).offset(textOffset)
            $0.right.equalTo(wrapperView.snp.right)
            $0.bottom.equalTo(heroDescriptionTextLabel.snp.top).offset(-10)
        }
    }
}
