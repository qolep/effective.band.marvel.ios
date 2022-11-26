import UIKit
import Kingfisher

final class CollectionViewCard: UICollectionViewCell {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20.0
        imageView.clipsToBounds = true
        return imageView
    }()
    private let heroName: UILabel = {
        let heroName = UILabel()
        heroName.font = UIFont(name: "Roboto", size: 24)
        heroName.textColor = .white
        heroName.backgroundColor = UIColor.gray
        return heroName
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpLayout()
    }
    func setup(heroData: HeroModel) {
        imageView.kf.setImage(with: heroData.ImageURL)
        heroName.text = heroData.name
    }
    private func setUpLayout() {
        addSubview(imageView)
        addSubview(heroName)
        heroName.snp.makeConstraints {
            $0.left.equalTo(self.snp.left).offset(20)
            $0.top.equalTo(self.snp.bottom).offset(-50)
        }
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
