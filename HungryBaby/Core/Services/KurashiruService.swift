import Foundation
import UIKit

struct KurashiruService {
    private static let appScheme = "kurashiru"
    private static let webBase = "https://www.kurashiru.com/recipes"

    /// クラシルアプリがインストール済みならアプリURLを、なければWebURLを返す
    static func url(for recipeID: String) -> URL {
        let appURLString = "\(appScheme)://recipe?id=\(recipeID)"
        if let appURL = URL(string: appURLString),
           UIApplication.shared.canOpenURL(appURL) {
            return appURL
        }
        // フォールバック: ブラウザで開く
        return URL(string: "\(webBase)/\(recipeID)")!
    }

    static func webURL(for recipeID: String) -> URL {
        URL(string: "\(webBase)/\(recipeID)")!
    }
}
