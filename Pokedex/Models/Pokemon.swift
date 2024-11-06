import Foundation

struct Pokemon: Codable, Identifiable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let types: [PokemonType]
    let sprites: Sprites
    let stats: [Stat]
    let abilities: [Ability]
    
    var imageUrl: String {
        sprites.other?.officialArtwork.frontDefault ?? sprites.frontDefault
    }
    
    var cryUrl: URL? {
        return URL(string: "https://pokemoncries.com/cries/\(id).mp3")
    }
}

struct PokemonType: Codable {
    let slot: Int
    let type: Type
}

struct Type: Codable {
    let name: String
    
    static let allTypes = [
        "normal", "fire", "water", "electric", "grass", "ice",
        "fighting", "poison", "ground", "flying", "psychic", "bug",
        "rock", "ghost", "dragon", "dark", "steel", "fairy"
    ]
}

struct Sprites: Codable {
    let frontDefault: String
    let backDefault: String?
    let frontShiny: String?
    let backShiny: String?
    let other: Other?
    var versions: GameVersions? = nil
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case backDefault = "back_default"
        case frontShiny = "front_shiny"
        case backShiny = "back_shiny"
        case other
    }
}

struct Other: Codable {
    let officialArtwork: OfficialArtwork
    
    enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
}

struct OfficialArtwork: Codable {
    let frontDefault: String
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

struct Stat: Codable {
    let baseStat: Int
    let stat: StatInfo
    
    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case stat
    }
}

struct StatInfo: Codable {
    let name: String
}

struct Ability: Codable {
    let ability: AbilityInfo
    let isHidden: Bool
    
    enum CodingKeys: String, CodingKey {
        case ability
        case isHidden = "is_hidden"
    }
}

struct AbilityInfo: Codable {
    let name: String
}

struct GameVersions: Codable {
    let generationV: GenerationV
    
    enum CodingKeys: String, CodingKey {
        case generationV = "generation-v"
    }
}

struct GenerationV: Codable {
    let blackWhite: BlackWhite
    
    enum CodingKeys: String, CodingKey {
        case blackWhite = "black-white"
    }
}

struct BlackWhite: Codable {
    let animated: AnimatedSprites
}

struct AnimatedSprites: Codable {
    let frontDefault: String?
    let backDefault: String?
    let frontShiny: String?
    let backShiny: String?
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case backDefault = "back_default"
        case frontShiny = "front_shiny"
        case backShiny = "back_shiny"
    }
} 