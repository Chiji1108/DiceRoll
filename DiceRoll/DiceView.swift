import SwiftUI

struct DiceView: View {
    let value: Int
    let diceType: DiceType
    let size: CGFloat

    init(value: Int, diceType: DiceType, size: CGFloat = 100) {
        self.value = value
        self.diceType = diceType
        self.size = size
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(diceColor)
                .frame(width: size, height: size)
                .shadow(radius: 3)

            Text("\(value)")
                .font(.system(size: size * 0.5, weight: .bold))
                .foregroundStyle(.white)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(diceType.name)の目：\(value)")
        .accessibilityValue("\(value)")
    }

    private var diceColor: Color {
        switch diceType {
        case .d4:
            return .green
        case .d6:
            return .blue
        case .d8:
            return .purple
        case .d10:
            return .orange
        case .d12:
            return .pink
        case .d20:
            return .red
        case .d100:
            return .gray
        }
    }
}

#Preview {
    HStack {
        DiceView(value: 4, diceType: .d6)
        DiceView(value: 6, diceType: .d6)
    }
}
