import SwiftData
import SwiftUI

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \DiceRoll.date, order: .reverse) private var diceRolls: [DiceRoll]

    var body: some View {
        NavigationStack {
            if diceRolls.isEmpty {
                ContentUnavailableView(
                    "ダイスの履歴がありません",
                    systemImage: "dice",
                    description: Text("ダイスを振ると、ここに履歴が表示されます")
                )
                .navigationTitle("履歴")
            } else {
                List {
                    ForEach(diceRolls) { roll in
                        VStack(alignment: .leading) {
                            HStack {
                                Text("合計: \(roll.totalValue)")
                                    .font(.headline)

                                Spacer()

                                Text(roll.date, style: .date)
                                    .font(.caption)

                                Text(roll.date, style: .time)
                                    .font(.caption)
                            }

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(roll.results.indices, id: \.self) { index in
                                        DiceView(
                                            value: roll.results[index],
                                            diceType: DiceType.allCases.first {
                                                $0.rawValue == roll.diceType
                                            } ?? .d6,
                                            size: 60
                                        )
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                    .onDelete(perform: deleteItems)
                }
                .navigationTitle("履歴")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
                }
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(diceRolls[index])
        }
    }
}

#Preview {
    MainActor.assumeIsolated {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: DiceRoll.self, configurations: config)

        let example1 = DiceRoll(results: [3, 6], diceType: 6)
        let example2 = DiceRoll(results: [10, 15, 5], diceType: 20)

        container.mainContext.insert(example1)
        container.mainContext.insert(example2)

        return HistoryView()
            .modelContainer(container)
    }
}
