import Foundation

struct KidsRecipeService {
    private static let baseURL = "https://kids-recipe.com"

    /// サイトトップURL
    static func topURL() -> URL {
        URL(string: baseURL)!
    }

    /// レシピ一覧URL
    static func recipesURL() -> URL {
        URL(string: "\(baseURL)/recipes")!
    }

    /// 食材名でサイト内検索するURL
    static func searchURL(ingredients: [String]) -> URL {
        let keyword = ingredients.joined(separator: " ")
        var components = URLComponents(string: "\(baseURL)/recipes")!
        components.queryItems = [URLQueryItem(name: "keyword", value: keyword)]
        return components.url!
    }
}
