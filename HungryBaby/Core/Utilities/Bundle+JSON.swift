import Foundation

extension Bundle {
    func decode<T: Decodable>(_ type: T.Type, from filename: String) throws -> T {
        guard let url = self.url(forResource: filename, withExtension: nil) else {
            throw BundleError.fileNotFound(filename)
        }
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(type, from: data)
    }

    enum BundleError: LocalizedError {
        case fileNotFound(String)

        var errorDescription: String? {
            switch self {
            case .fileNotFound(let name):
                "バンドルにファイルが見つかりません: \(name)"
            }
        }
    }
}
