import Foundation

class PokemonService {
    static let shared = PokemonService()
    private let baseURL = "https://pokeapi.co/api/v2"
    
    func fetchPokemonList(limit: Int = 1008) async throws -> [Pokemon] {
        let url = URL(string: "\(baseURL)/pokemon?limit=\(limit)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(PokemonListResponse.self, from: data)
        
        var pokemons: [Pokemon] = []
        await withTaskGroup(of: Pokemon?.self) { group in
            for result in response.results {
                group.addTask {
                    try? await self.fetchPokemon(url: result.url)
                }
            }
            
            for await pokemon in group {
                if let pokemon = pokemon {
                    pokemons.append(pokemon)
                }
            }
        }
        
        return pokemons.sorted(by: { $0.id < $1.id })
    }
    
    func fetchPokemon(url: String) async throws -> Pokemon {
        let url = URL(string: url)!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(Pokemon.self, from: data)
    }
    
    func fetchEvolutionChain(for pokemon: Pokemon) async throws -> EvolutionChain? {
        let speciesURL = "\(baseURL)/pokemon-species/\(pokemon.id)"
        let url = URL(string: speciesURL)!
        let (speciesData, _) = try await URLSession.shared.data(from: url)
        let species = try JSONDecoder().decode(PokemonSpecies.self, from: speciesData)
        
        let (evolutionData, _) = try await URLSession.shared.data(from: URL(string: species.evolutionChain.url)!)
        return try JSONDecoder().decode(EvolutionChain.self, from: evolutionData)
    }
}

struct PokemonListResponse: Codable {
    let results: [PokemonListItem]
}

struct PokemonListItem: Codable {
    let url: String
} 