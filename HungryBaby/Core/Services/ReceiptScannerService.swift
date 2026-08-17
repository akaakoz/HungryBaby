import UIKit
import Vision

struct ReceiptScannerService {
    /// レシート画像からテキストを認識し、食材名の候補を返す
    static func recognizeIngredients(from image: UIImage) async -> [String] {
        guard let cgImage = image.cgImage else { return [] }

        let recognizedTexts = await withCheckedContinuation { continuation in
            let request = VNRecognizeTextRequest { request, _ in
                guard let observations = request.results as? [VNRecognizedTextObservation] else {
                    continuation.resume(returning: [String]())
                    return
                }
                let texts = observations.compactMap { $0.topCandidates(1).first?.string }
                continuation.resume(returning: texts)
            }
            request.recognitionLevel = .accurate
            request.recognitionLanguages = ["ja", "en"]
            request.usesLanguageCorrection = true

            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            try? handler.perform([request])
        }

        return extractIngredients(from: recognizedTexts)
    }

    /// OCRテキストから食材名を抽出する
    private static func extractIngredients(from texts: [String]) -> [String] {
        // レシートで食材として除外するキーワード
        let excludeKeywords = [
            "合計", "小計", "税", "円", "¥", "点", "お買上", "レジ",
            "クレジット", "現金", "お釣り", "釣銭", "ポイント", "カード",
            "店", "TEL", "tel", "〒", "http", "www", "レシート",
            "領収", "会員", "番号", "日付", "時間", "担当", "枚",
            "袋", "値引", "割引", "クーポン", "返品", "交換",
            "いらっしゃいませ", "ありがとう", "またお越し",
            "内税", "外税", "非課税", "軽減", "%"
        ]

        // 数字のみ、または極端に短い/長いテキストを除外
        let filtered = texts.filter { text in
            let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
            guard trimmed.count >= 2, trimmed.count <= 20 else { return false }

            // 数字・記号のみの行を除外
            let digits = trimmed.filter { $0.isNumber || $0 == "," || $0 == "." || $0 == "¥" || $0 == "-" }
            if digits.count > trimmed.count / 2 { return false }

            // 除外キーワードを含む行を除外
            for keyword in excludeKeywords {
                if trimmed.contains(keyword) { return false }
            }

            return true
        }

        // 重複を除去して返す
        var seen = Set<String>()
        return filtered.compactMap { text in
            // 価格部分（数字+円など）を除去
            let cleaned = text
                .replacingOccurrences(of: #"\s*¥?[\d,]+円?\s*$"#, with: "", options: .regularExpression)
                .replacingOccurrences(of: #"^\s*[\d]+\s+"#, with: "", options: .regularExpression)
                .trimmingCharacters(in: .whitespacesAndNewlines)

            guard !cleaned.isEmpty, cleaned.count >= 2, !seen.contains(cleaned) else { return nil }
            seen.insert(cleaned)
            return cleaned
        }
    }
}
