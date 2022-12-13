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
        imageView.kf.indicatorType = .activity
        setUpLayout()
    }
    func setup(heroModel: HeroModel?, and tag: Int) {
        imageView.image = .init()
        imageView.layoutIfNeeded()
        guard let heroData = heroModel else{return}
        let processor = DownsamplingImageProcessor(size: imageView.bounds.size)
                     |> RoundCornerImageProcessor(cornerRadius: 20)
        let resource = ImageResource(downloadURL: URL(string: heroData.ImageURL) ?? URL(string: "http://127.0.0.1")!, cacheKey: "\(heroData.heroId)")
               imageView.kf.setImage(
                   with: resource,
                   placeholder: UIImage(named: "placeholder"),
                   options: [
                       .processor(processor),
                       .cacheOriginalImage
                   ]
               ) {            switch $0 {
            case .success(let value):
                NSLog("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                NSLog("Job failed: \(error.localizedDescription)")
            }
        }
        imageView.tag = tag
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
