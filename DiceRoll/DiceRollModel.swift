import Foundation
import SwiftData

/// ダイスロールの結果を保存するためのデータモデル
@Model
final class DiceRoll {
    // MARK: - プロパティ

    /// ロールが行われた日時
    var date: Date

    /// 各ダイスの結果の配列
    var results: [Int]

    /// 使用されたダイスの種類（面の数）
    var diceType: Int

    // MARK: - 計算プロパティ

    /// ダイスの合計値
    var totalValue: Int {
        results.reduce(0, +)
    }

    /// 使用されたダイスの種類
    var diceTypeEnum: DiceType? {
        DiceType.allCases.first { $0.rawValue == diceType }
    }

    /// ダイスの個数
    var numberOfDice: Int {
        results.count
    }

    // MARK: - 初期化

    /// 新しいダイスロールを作成
    /// - Parameters:
    ///   - results: 各ダイスの結果の配列
    ///   - diceType: 使用されたダイスの種類（面の数）
    init(results: [Int], diceType: Int) {
        self.date = Date()
        self.results = results
        self.diceType = diceType
    }
}

/// ダイスの種類を表す列挙型
enum DiceType: Int, CaseIterable, Identifiable {
    // MARK: - ケース

    case d4 = 4
    case d6 = 6
    case d8 = 8
    case d10 = 10
    case d12 = 12
    case d20 = 20
    case d100 = 100

    // MARK: - Identifiableプロトコル準拠

    var id: Int { rawValue }

    // MARK: - 表示名

    /// ダイスの表示名（例: "d6"）
    var name: String {
        "d\(rawValue)"
    }

    /// ダイスの説明（例: "6面ダイス"）
    var description: String {
        "\(rawValue)面ダイス"
    }
}
