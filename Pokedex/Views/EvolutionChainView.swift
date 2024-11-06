import SwiftUI

struct EvolutionChainView: View {
    let chain: EvolutionChain
    let pokemons: [Pokemon]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Evolution Chain")
                .font(.title2)
                .bold()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 10) {
                    ForEach(buildEvolutionList(chain.chain), id: \.species.name) { chainLink in
                        HStack(alignment: .center, spacing: 10) {
                            if let pokemon = pokemons.first(where: { $0.name == chainLink.species.name }) {
                                NavigationLink(destination: PokemonDetailView(pokemon: pokemon)) {
                                    VStack {
                                        AsyncImage(url: URL(string: pokemon.imageUrl)) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        .frame(width: 100, height: 100)
                                        
                                        Text(pokemon.name.capitalized)
                                            .font(.caption)
                                            .foregroundColor(.primary)
                                        
                                        Text("#\(pokemon.id)")
                                            .font(.caption2)
                                            .foregroundColor(.secondary)
                                    }
                                    .padding(8)
                                    .background(Color(UIColor.secondarySystemBackground))
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                    )
                                }
                            }
                            
                            if chainLink.evolvesTo.count > 0 {
                                VStack(alignment: .center) {
                                    Image(systemName: "arrow.right")
                                        .foregroundColor(.secondary)
                                        .font(.title3)
                                    if let details = chainLink.evolutionDetails?.first {
                                        if let level = details.minLevel {
                                            Text("Lv. \(level)")
                                                .font(.caption2)
                                                .foregroundColor(.secondary)
                                        } else if details.trigger.name == "use-item" {
                                            Text("Item")
                                                .font(.caption2)
                                                .foregroundColor(.secondary)
                                        } else if details.trigger.name == "trade" {
                                            Text("Trade")
                                                .font(.caption2)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                }
                                .padding(.horizontal, 5)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
    
    private func buildEvolutionList(_ chain: ChainLink) -> [ChainLink] {
        var list = [chain]
        for evolution in chain.evolvesTo {
            list += buildEvolutionList(evolution)
        }
        return list
    }
} 