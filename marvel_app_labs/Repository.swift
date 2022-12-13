import Alamofire
import CryptoKit
import Foundation

class Repository {
    private var database: DbProtocol = DataManager()
    private var isThereInternetConnection = true
    private let baseUrl = "https://gateway.marvel.com/v1/public/characters"
    func getHeroes(offset: Int = 0, _ completion: @escaping ([HeroModel]) -> Void) {
        guard isThereInternetConnection == true else { completion(self.database.getAll()); return }
        AF.request(
            baseUrl,
            parameters: keys(offset: offset)
        ).responseDataDecodable(of: HeroListPayload.self) { response in
            switch response.result {
            case .success(let heroPayload):
                debugPrint(response)
                guard let heroDecodable = heroPayload.data?.results else { completion(self.database.getAll()); return }
                let heroModelArray: [HeroModel] = heroDecodable.compactMap { self.heroFromDecodable(hero: $0) }
                self.database.writeAll(hero: heroModelArray)
                completion(heroModelArray)
            case .failure(let failure):
                self.isThereInternetConnection = false
                NSLog(failure.localizedDescription)
                completion(self.database.getAll())
            }
        }
    }
    func getHero(id: Int, _ completion: @escaping (HeroModel?) -> Void) {
        AF.request(
            baseUrl + "/\(id)",
            parameters: keys()
        ).responseDataDecodable(of: HeroListPayload.self) { response in
            switch response.result {
            case .success(let heroPayload):
                guard let heroDecodable = heroPayload.data?.results else { completion(nil); return }
                let heroModelArray: [HeroModel] = heroDecodable.compactMap { self.heroFromDecodable(hero: $0) }
                completion(heroModelArray.first)
            case .failure(let failure):
                NSLog(failure.localizedDescription)
                completion(nil)
            }
        }
    }
    private func heroFromDecodable(hero: HeroPayload?) -> HeroModel? {
        guard let unwrappedHeroPayload = hero else { return nil }
        guard let id = unwrappedHeroPayload.id else { return nil }
        
        return HeroModel(id: id, name: unwrappedHeroPayload.name,
                         imageURL: unwrappedHeroPayload.thumbnail?.imageUrlString,
                              description: hero?.description)
    }
    private func keys(offset: Int = 0) -> [String: String] {
        let privateKey = "b2301cb138032ffa8c08defe1d44222ef48c730c"
        let apikey = "e426895c827aa56816b990cb4f31ca96"
        let timeStamp = NSDate().timeIntervalSince1970
        let hash = getHash(timeStamp: timeStamp, apikey: apikey, privateKey: privateKey)
        return ["apikey": apikey, "ts": "\(timeStamp)", "hash": hash, "offset": "\(offset)"]
    }
    private func getHash(timeStamp: Double, apikey: String, privateKey: String) -> String {
        let dirtyMd5 = Insecure.MD5.hash(data: "\(timeStamp)\(privateKey)\(apikey)".data(using: .utf8)!)
        return dirtyMd5.map { String(format: "%02hhx", $0) }.joined()
    }
    private struct HeroListPayload: Decodable {
        let count: Int?
        let results: [HeroPayload?]?
    }
    private struct HeroPayload: Decodable {
        let name: String?
        let id: Int?
        let thumbnail: ThumbnailPayload?
        let description: String?
    }
    private struct ThumbnailPayload: Decodable {
        let imageUrlString: String?
        let imageExtension: String?
        enum CodingKeys: String, CodingKey {
            case imageUrlString = "path"
            case imageExtension = "extension"
        }
    }
}
