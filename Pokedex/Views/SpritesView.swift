import SwiftUI

struct SpritesView: View {
    let sprites: Sprites
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Sprites")
                .font(.title2)
                .bold()
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                SpriteImage(url: sprites.frontDefault, title: "Default Front")
                if let backDefault = sprites.backDefault {
                    SpriteImage(url: backDefault, title: "Default Back")
                }
                if let frontShiny = sprites.frontShiny {
                    SpriteImage(url: frontShiny, title: "Shiny Front")
                }
                if let backShiny = sprites.backShiny {
                    SpriteImage(url: backShiny, title: "Shiny Back")
                }
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

struct SpriteImage: View {
    let url: String
    let title: String
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: url)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 100, height: 100)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
} 