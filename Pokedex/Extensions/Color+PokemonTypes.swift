import SwiftUI

extension Color {
    static func forPokemonType(_ type: String) -> Color {
        switch type.lowercased() {
        case "normal": return Color(hex: "A8A878")
        case "fire": return Color(hex: "F08030")
        case "water": return Color(hex: "6890F0")
        case "electric": return Color(hex: "F8D030")
        case "grass": return Color(hex: "78C850")
        case "ice": return Color(hex: "98D8D8")
        case "fighting": return Color(hex: "C03028")
        case "poison": return Color(hex: "A040A0")
        case "ground": return Color(hex: "E0C068")
        case "flying": return Color(hex: "A890F0")
        case "psychic": return Color(hex: "F85888")
        case "bug": return Color(hex: "A8B820")
        case "rock": return Color(hex: "B8A038")
        case "ghost": return Color(hex: "705898")
        case "dragon": return Color(hex: "7038F8")
        case "dark": return Color(hex: "705848")
        case "steel": return Color(hex: "B8B8D0")
        case "fairy": return Color(hex: "EE99AC")
        default: return .gray
        }
    }
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    static func textColor(for pokemonType: String) -> Color {
        let darkTypes = ["ghost", "dark", "psychic", "dragon", "fighting"]
        return darkTypes.contains(pokemonType.lowercased()) ? .white : .black
    }
} 