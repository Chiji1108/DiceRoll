import Foundation
import SwiftUI

@Observable
class DiceRollViewModel {
    // MARK: - プロパティ

    // 公開プロパティ
    var numberOfDice: Int = 2
    var selectedDiceType: DiceType = .d6
    var currentResults: [Int] = []
    var isRolling: Bool = false
    var rollAnimationValues: [Int] = []

    // コールバックプロパティ
    var onRollCompleted: (() -> Void)?

    // プライベートプロパティ
    private var timer: Timer?
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    private let animationDuration: TimeInterval = 1.0
    private let animationSteps = 10

    // MARK: - 公開メソッド

    /// ダイスを振るメインメソッド
    func rollDice() {
        prepareForRoll()
        startRollingAnimation()
    }

    // MARK: - プライベートメソッド

    /// ロールの前準備
    private func prepareForRoll() {
        isRolling = true
        rollAnimationValues = Array(repeating: 1, count: numberOfDice)
        feedbackGenerator.prepare()
    }

    /// アニメーションの開始
    private func startRollingAnimation() {
        var iterations = 0
        let timeInterval = animationDuration / Double(animationSteps)

        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) {
            [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }

            self.updateAnimationValues()

            iterations += 1
            if iterations >= self.animationSteps {
                self.finishRolling()
                timer.invalidate()
            }
        }
    }

    /// アニメーション値の更新
    private func updateAnimationValues() {
        for i in 0..<numberOfDice {
            let maxValue = selectedDiceType.rawValue
            rollAnimationValues[i] = generateRandomDiceValue(maxValue: maxValue)
        }
    }

    /// ランダムなダイスの値を生成
    private func generateRandomDiceValue(maxValue: Int) -> Int {
        return Int.random(in: 1...maxValue)
    }

    /// ロールの終了処理
    private func finishRolling() {
        // 最終的な結果を生成
        currentResults = (1...numberOfDice).map { _ in
            generateRandomDiceValue(maxValue: selectedDiceType.rawValue)
        }

        rollAnimationValues = currentResults
        isRolling = false

        // 触覚フィードバックを提供
        provideFeedback()

        // ロール完了時のコールバックを呼び出す
        onRollCompleted?()
    }

    /// 触覚フィードバックを提供
    private func provideFeedback() {
        feedbackGenerator.impactOccurred()
    }
}
