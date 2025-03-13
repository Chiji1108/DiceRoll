//
//  ContentView.swift
//  DiceRoll
//
//  Created by 千々岩真吾 on 2025/03/13.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @State private var viewModel = DiceRollViewModel()
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        TabView {
            diceRollView
                .tabItem {
                    Label("ダイスロール", systemImage: "dice")
                }

            HistoryView()
                .tabItem {
                    Label("履歴", systemImage: "clock")
                }
        }
        .onAppear {
            // ViewModelのコールバックを設定
            viewModel.onRollCompleted = {
                saveDiceRoll()
            }
        }
    }

    private var diceRollView: some View {
        NavigationStack {
            VStack {
                Spacer()

                // 合計値表示
                if !viewModel.currentResults.isEmpty {
                    TotalValueView(total: viewModel.currentResults.reduce(0, +))
                }

                // ダイス表示
                DiceDisplayView(viewModel: viewModel)

                Spacer()

                // ダイス設定
                DiceSettingsView(viewModel: viewModel)

                // ロールボタン
                RollButton(
                    action: {
                        viewModel.rollDice()
                    }, isDisabled: viewModel.isRolling)
            }
            .navigationTitle("ダイスロール")
        }
    }

    private func saveDiceRoll() {
        guard !viewModel.currentResults.isEmpty else { return }

        let diceRoll = DiceRoll(
            results: viewModel.currentResults,
            diceType: viewModel.selectedDiceType.rawValue
        )

        modelContext.insert(diceRoll)

        // デバッグ用のログ
        print(
            "保存しました: ダイス \(viewModel.numberOfDice)個, 種類: \(viewModel.selectedDiceType.name), 結果: \(viewModel.currentResults), 合計: \(viewModel.currentResults.reduce(0, +))"
        )
    }
}

// MARK: - サブコンポーネント

struct TotalValueView: View {
    let total: Int

    var body: some View {
        Text("合計: \(total)")
            .font(.largeTitle)
            .bold()
            .padding()
            .accessibilityLabel("合計は\(total)です")
    }
}

struct DiceDisplayView: View {
    @ObservedObject var viewModel: DiceRollViewModel

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(0..<viewModel.numberOfDice, id: \.self) { index in
                    DiceView(
                        value: diceValue(for: index),
                        diceType: viewModel.selectedDiceType
                    )
                    .transition(.scale)
                }
            }
            .padding()
        }
    }

    private func diceValue(for index: Int) -> Int {
        if viewModel.isRolling {
            return viewModel.rollAnimationValues.indices.contains(index)
                ? viewModel.rollAnimationValues[index]
                : 1
        } else {
            return viewModel.currentResults.indices.contains(index)
                ? viewModel.currentResults[index]
                : 1
        }
    }
}

struct DiceSettingsView: View {
    @ObservedObject var viewModel: DiceRollViewModel

    var body: some View {
        VStack {
            HStack {
                Text("種類:")
                Picker("ダイスの種類", selection: $viewModel.selectedDiceType) {
                    ForEach(DiceType.allCases) { diceType in
                        Text(diceType.name).tag(diceType)
                    }
                }
                .pickerStyle(.segmented)
            }
            .padding(.horizontal)

            HStack {
                Text("数: \(viewModel.numberOfDice)")
                Slider(
                    value: $viewModel.numberOfDice.doubleBinding,
                    in: 1...6,
                    step: 1
                )
                .accessibilityLabel("ダイスの数")
                .accessibilityValue("\(viewModel.numberOfDice)個")
            }
            .padding(.horizontal)
        }
        .padding()
    }
}

struct RollButton: View {
    let action: () -> Void
    let isDisabled: Bool

    var body: some View {
        Button(action: action) {
            Text("ロール")
                .font(.title)
                .bold()
                .frame(maxWidth: .infinity)
                .padding()
        }
        .buttonStyle(.borderedProminent)
        .padding()
        .disabled(isDisabled)
    }
}

// MARK: - 拡張

extension Binding where Value == Int {
    var doubleBinding: Binding<Double> {
        Binding<Double>(
            get: { Double(wrappedValue) },
            set: { wrappedValue = Int($0) }
        )
    }
}

// Observable型に対応するためのObjservableObjectへの拡張
extension DiceRollViewModel: ObservableObject {}

#Preview {
    ContentView()
        .modelContainer(for: DiceRoll.self, inMemory: true)
}
