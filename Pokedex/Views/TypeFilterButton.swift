import SwiftUI

struct TypeFilterButton: View {
    let type: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            HapticFeedback.impact()
            action()
        }) {
            Text(type.capitalized)
                .font(.subheadline)
                .bold()
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Color.forPokemonType(type)
                        .opacity(isSelected ? 1 : 0.5)
                )
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.2), lineWidth: isSelected ? 2 : 0)
                )
        }
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
    }
}

#Preview {
    HStack {
        TypeFilterButton(type: "fire", isSelected: true) {}
        TypeFilterButton(type: "water", isSelected: false) {}
    }
    .padding()
    .background(Color.black)
} 