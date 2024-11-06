struct EvolutionChain: Codable {
    let chain: ChainLink
}

struct ChainLink: Codable {
    let species: Species
    let evolvesTo: [ChainLink]
    let evolutionDetails: [EvolutionDetails]?
    
    enum CodingKeys: String, CodingKey {
        case species
        case evolvesTo = "evolves_to"
        case evolutionDetails = "evolution_details"
    }
}

struct Species: Codable {
    let name: String
    let url: String
}

struct EvolutionDetails: Codable {
    let minLevel: Int?
    let trigger: EvolutionTrigger
    let item: Item?
    
    enum CodingKeys: String, CodingKey {
        case minLevel = "min_level"
        case trigger
        case item
    }
}

struct EvolutionTrigger: Codable {
    let name: String
}

struct Item: Codable {
    let name: String
}

struct PokemonSpecies: Codable {
    let evolutionChain: EvolutionChainURL
    
    enum CodingKeys: String, CodingKey {
        case evolutionChain = "evolution_chain"
    }
}

struct EvolutionChainURL: Codable {
    let url: String
} 