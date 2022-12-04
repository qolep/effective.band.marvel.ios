import UIKit
import Foundation

struct HeroModel {
    let name: String
    let ImageURL: URL
    let color: UIColor
    let description : String
    init(name: String, imageURL: URL, color: UIColor, description: String) {
        self.name = name
        self.ImageURL = imageURL
        self.color = color
        self.description = description
    }
}

struct ImageUrl {
    static let spider_man = URL(string: """
           https://clck.ru/32vnV3Z
           """)
    static let black_panther = URL(string: """
           https://clck.ru/32qQoy
           """)
    static let vision = URL(string: """
                          https://clck.ru/32nUXJ
                          """)
    static let deadpool = URL(string: """
                          https://clck.ru/32nUY3
                          """)
    static let thanos = URL(string: """
                          https://clck.ru/32nUZi
                          """)
    static let iron_man = URL(string: """
                          https://clck.ru/32nUam
                          """)
    static let dr = URL(string: """
                          https://clck.ru/32nUbd
                          """)
    static let thor = URL(string: """
                          https://clck.ru/32nUcM
                          """)}
struct Description {
    static let spider_man_desc = "I am spider man!"
    static let black_panther_desc = "I am black panther!"
    static let vision_desc = "I am vision!"
    static let deadpool_desc = "I am deadpool!"
    static let thanos_desc = "I am thanos!"
    static let iron_man_desc = "I am iron man!"
    static let dr_desc = "I am dr.strange!"
    static let thor_desc = "I am thor!"}
