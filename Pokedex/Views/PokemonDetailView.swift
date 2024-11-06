import SwiftUI

struct PokemonDetailView: View {
    let pokemon: Pokemon
    @EnvironmentObject var viewModel: PokemonViewModel
    @StateObject private var audioManager = AudioManager.shared
    @State private var showQuickNav = false
    @State private var selectedGeneration = 1
    @State private var currentPokemonId: Int
    
    init(pokemon: Pokemon) {
        self.pokemon = pokemon
        _currentPokemonId = State(initialValue: pokemon.id)
    }
    
    private var currentIndex: Int {
        viewModel.pokemons.firstIndex(where: { $0.id == currentPokemonId }) ?? 0
    }
    
    var body: some View {
        TabView(selection: $currentPokemonId) {
            ForEach(viewModel.pokemons) { pokemon in
                ScrollView {
                    VStack(spacing: 0) {
                        // Pokemon Card Header
                        headerView(for: pokemon)
                        
                        // Info Cards
                        VStack(spacing: 16) {
                            // Basic Info Card
                            infoCard(for: pokemon)
                            
                            // Stats Card
                            statsCard(for: pokemon)
                            
                            // Evolution Chain Card
                            if let evolutionChain = viewModel.evolutionChains[pokemon.id] {
                                evolutionChainCard(chain: evolutionChain)
                            }
                            
                            // Sprites Card
                            spritesGridView(sprites: pokemon.sprites)
                        }
                        .padding(.horizontal)
                    }
                }
                .background(backgroundGradient(for: pokemon))
                .tag(pokemon.id)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if let index = viewModel.pokemons.firstIndex(where: { $0.id == currentPokemonId }) {
                    Text("\(index + 1) of \(viewModel.pokemons.count)")
                        .foregroundColor(.secondary)
                }
            }
        }
    }
    
    // MARK: - Component Views
    
    private func headerView(for pokemon: Pokemon) -> some View {
        ZStack(alignment: .topTrailing) {
            AsyncImage(url: URL(string: pokemon.imageUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 250)
                    .shadow(color: Color.forPokemonType(pokemon.types.first?.type.name ?? "normal").opacity(0.5), radius: 20)
            } placeholder: {
                ProgressView()
            }
            .padding(.top, 20)
            
            if let cryUrl = pokemon.cryUrl {
                Button(action: {
                    audioManager.playPokemonCry(from: cryUrl)
                    HapticFeedback.impact()
                }) {
                    Image(systemName: "speaker.wave.2.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Color.white.opacity(0.2))
                        .clipShape(Circle())
                }
                .padding()
            }
        }
        .frame(height: 300)
        .background(Color.forPokemonType(pokemon.types.first?.type.name ?? "normal").opacity(0.8))
    }
    
    private func infoCard(for pokemon: Pokemon) -> some View {
        VStack(spacing: 16) {
            Text(pokemon.name.capitalized)
                .font(.title)
                .bold()
                .foregroundColor(.primary)
            
            Text("#\(String(format: "%03d", pokemon.id))")
                .font(.title2)
                .foregroundColor(.secondary)
            
            HStack(spacing: 12) {
                ForEach(pokemon.types, id: \.slot) { type in
                    Text(type.type.name.capitalized)
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.forPokemonType(type.type.name))
                        .cornerRadius(20)
                }
            }
            
            HStack(spacing: 30) {
                VStack {
                    Text("Height")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(String(format: "%.1f m", Double(pokemon.height) / 10))
                        .bold()
                }
                
                VStack {
                    Text("Weight")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(String(format: "%.1f kg", Double(pokemon.weight) / 10))
                        .bold()
                }
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(15)
    }
    
    private func statsCard(for pokemon: Pokemon) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Base Stats")
                .font(.title2)
                .bold()
                .foregroundColor(.primary)
            
            ForEach(pokemon.stats, id: \.stat.name) { stat in
                StatRow(stat: stat)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(15)
    }
    
    private func evolutionChainCard(chain: EvolutionChain) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Evolution Chain")
                .font(.title2)
                .bold()
                .foregroundColor(.primary)
            
            EvolutionChainView(chain: chain, pokemons: viewModel.pokemons)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(15)
    }
    
    private func spritesGridView(sprites: Sprites) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Sprites")
                .font(.title2)
                .bold()
                .foregroundColor(.primary)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                SpriteView(image: sprites.frontDefault, title: "Front")
                if let backDefault = sprites.backDefault {
                    SpriteView(image: backDefault, title: "Back")
                }
                if let frontShiny = sprites.frontShiny {
                    SpriteView(image: frontShiny, title: "Shiny Front")
                }
                if let backShiny = sprites.backShiny {
                    SpriteView(image: backShiny, title: "Shiny Back")
                }
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(15)
    }
    
    private func backgroundGradient(for pokemon: Pokemon) -> some View {
        LinearGradient(
            colors: [
                Color.forPokemonType(pokemon.types.first?.type.name ?? "normal").opacity(0.3),
                Color(UIColor.systemBackground)
            ],
            startPoint: .top,
            endPoint: .center
        )
        .ignoresSafeArea()
    }
}

// MARK: - Supporting Views

struct StatRow: View {
    let stat: Stat
    
    var body: some View {
        HStack {
            Text(statName(stat.stat.name))
                .frame(width: 100, alignment: .leading)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text("\(stat.baseStat)")
                .frame(width: 40)
                .bold()
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(width: geometry.size.width, height: 8)
                        .opacity(0.3)
                        .foregroundColor(.gray)
                    
                    Rectangle()
                        .frame(width: min(CGFloat(stat.baseStat) / 255 * geometry.size.width, geometry.size.width), height: 8)
                        .foregroundColor(statColor(for: stat.baseStat))
                }
                .cornerRadius(4)
            }
            .frame(height: 8)
        }
    }
    
    private func statName(_ name: String) -> String {
        switch name {
        case "hp": return "HP"
        case "attack": return "Attack"
        case "defense": return "Defense"
        case "special-attack": return "Sp. Atk"
        case "special-defense": return "Sp. Def"
        case "speed": return "Speed"
        default: return name.capitalized
        }
    }
    
    private func statColor(for value: Int) -> Color {
        switch value {
        case 0...50: return .red
        case 51...90: return .orange
        case 91...130: return .yellow
        default: return .green
        }
    }
}

struct SpriteView: View {
    let image: String
    let title: String
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: image)) { image in
                image
                    .resizable()
                    .interpolation(.none)
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 80, height: 80)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
} 