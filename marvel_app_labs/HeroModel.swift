import UIKit
import Foundation
import CryptoKit
import Alamofire

struct HeroModel {
    let heroId: Int
    let name: String
    let ImageURL: String
    let description : String
    init(id: Int, name: String, imageURL: String, description: String) {
        self.heroId = id
        self.name = name
        self.description = description
        if imageURL.hasSuffix("jpg") {
                    self.ImageURL = imageURL
                } else {
                    self.ImageURL = imageURL + "/portrait_uncanny.jpg"
                }
            }
        }
let baseUrl = "https://gateway.marvel.com/v1/public/characters"

func getHeroes(id: Int = -1, offset: Int = 0, _ completion: @escaping ([HeroModel]) -> Void) {
    AF.request(
        baseUrl + (id == -1 ? "" : "/\(id)"),
        parameters: keys(offset: offset)
    ).responseDecodable(of: HeroesPayload.self) { response in
        switch response.result {
        case .success(let heroesPayload):
            let heroDecod = heroesPayload.data?.results
            var heroModelArray: [HeroModel] = []
            for hero in heroDecod! {
                let newModel = HeroModel(id: hero?.id ?? -1, name: hero?.name ?? "",
                                         imageURL: hero?.thumbnail?.imageUrlString ?? "",
                                              description: hero?.description ?? "")
                heroModelArray.append(newModel)
            }
            completion(heroModelArray)
        case .failure(let failure):
            NSLog(failure.localizedDescription)
        }
    }

/*
Result<[HeroModel]?, Error>
 switch response.result {
        case .success(let heroesPayload):
            let heroDecod = heroesPayload.data?.results
            var heroModelArray: [HeroModel] = []
              {
                let newModel = HeroModel(--id: hero?.id ?? -1, name: hero?.name ?? "",
                                              imageURL: hero?.thumbnail?.imageUrlString ?? "",
                                              description: hero?.description ?? "") --replace it with private func decod
                heroModelArray.append(newModel)
            }
            completion(heroModelArray)
        case .failure(let failure):
            NSLog(failure.localizedDescription)
        }
    } */
}
private struct HeroesPayload: Decodable {
    let data: HeroesListDecodable?
}
private struct HeroesListDecodable: Decodable {
    let count: Int?
    let results: [HeroDecodable?]?
}
struct HeroDecodable: Decodable {
    let name: String?
    let id: Int?
    let thumbnail: Thumbnail?
    let description: String?
}
struct Thumbnail: Decodable {
    let imageUrlString: String?
    let imageExtension: String?
    enum CodingKeys: String, CodingKey {
        case imageUrlString = "path"
        case imageExtension = "extension"
    }
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
