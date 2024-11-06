import SwiftUI

struct AnimatedSpriteView: View {
    let sprites: AnimatedSprites
    @State private var currentIndex = 0
    @State private var isAnimating = false
    
    private var spriteUrls: [String] {
        [
            sprites.frontDefault,
            sprites.backDefault,
            sprites.frontShiny,
            sprites.backShiny
        ].compactMap { $0 }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Animated Sprites")
                .font(.title2)
                .bold()
            
            if !spriteUrls.isEmpty {
                AsyncImage(url: URL(string: spriteUrls[currentIndex])) { image in
                    image
                        .resizable()
                        .interpolation(.none) // Keeps pixel art sharp
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 150, height: 150)
                
                Button(action: {
                    isAnimating.toggle()
                }) {
                    Label(isAnimating ? "Stop Animation" : "Start Animation", systemImage: isAnimating ? "pause.fill" : "play.fill")
                }
                .buttonStyle(.bordered)
            } else {
                Text("No animated sprites available")
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
        .onAppear {
            startAnimation()
        }
        .onChange(of: isAnimating) { newValue in
            if newValue {
                startAnimation()
            }
        }
    }
    
    private func startAnimation() {
        guard isAnimating else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if isAnimating {
                currentIndex = (currentIndex + 1) % spriteUrls.count
                startAnimation()
            }
        }
    }
} 