import Foundation

@MainActor
class PokemonViewModel: ObservableObject {
    @Published var pokemons: [Pokemon] = []
    @Published var evolutionChains: [Int: EvolutionChain] = [:]
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var favorites = Set<Int>()
    
    func fetchPokemons() async {
        isLoading = true
        errorMessage = nil
        
        do {
            pokemons = try await PokemonService.shared.fetchPokemonList()
            await fetchEvolutionChains()
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    private func fetchEvolutionChains() async {
        await withTaskGroup(of: Void.self) { group in
            for pokemon in pokemons {
                group.addTask {
                    if let chain = try? await PokemonService.shared.fetchEvolutionChain(for: pokemon) {
                        await MainActor.run {
                            self.evolutionChains[pokemon.id] = chain
                        }
                    }
                }
            }
        }
    }
    
    func toggleFavorite(_ pokemonId: Int) {
        if favorites.contains(pokemonId) {
            favorites.remove(pokemonId)
        } else {
            favorites.insert(pokemonId)
        }
    }
    
    var filteredPokemon: [Pokemon] {
        pokemons.sorted { $0.id < $1.id }
    }
    
    func pokemonInGeneration(_ gen: Int) -> [Pokemon] {
        let ranges: [ClosedRange<Int>] = [
            1...151,    // Gen 1
            152...251,  // Gen 2
            252...386,  // Gen 3
            387...493,  // Gen 4
            494...649,  // Gen 5
            650...721,  // Gen 6
            722...809,  // Gen 7
            810...905,  // Gen 8
            906...1008  // Gen 9
        ]
        
        guard gen >= 1 && gen <= ranges.count else { return [] }
        return pokemons.filter { ranges[gen - 1].contains($0.id) }
    }
} 