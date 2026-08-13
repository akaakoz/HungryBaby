import Foundation

struct KurashiruService {
    private static let searchBase = "https://www.kurashiru.com/search"

    /// 食材名の配列 + ステージからクラシル検索URLを生成
    static func searchURL(ingredients: [String], stage: BabyStage?) -> URL {
        var terms = ingredients
        if let stage { terms.append(stage.searchKeyword) }
        let query = terms.joined(separator: " ")
        var components = URLComponents(string: searchBase)!
        components.queryItems = [URLQueryItem(name: "query", value: query)]
        return components.url!
    }

    /// レシピ名 + ステージでクラシル検索URLを生成
    static func searchURL(recipeName: String, stage: BabyStage?) -> URL {
        var query = recipeName
        if let stage { query += " \(stage.searchKeyword)" }
        var components = URLComponents(string: searchBase)!
        components.queryItems = [URLQueryItem(name: "query", value: query)]
        return components.url!
    }
}
