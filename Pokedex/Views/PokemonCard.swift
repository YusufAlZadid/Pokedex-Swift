import SwiftUI

struct PokemonCard: View {
    let pokemon: Pokemon
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: URL(string: pokemon.imageUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 120)
                    .padding()
            } placeholder: {
                ProgressView()
                    .frame(height: 120)
            }
            .background(Color(UIColor.systemBackground).opacity(0.1))
            .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("#\(pokemon.id)")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text(pokemon.name.capitalized)
                    .font(.headline)
                    .foregroundColor(.white)
                
                HStack {
                    ForEach(pokemon.types, id: \.slot) { type in
                        Text(type.type.name.capitalized)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.forPokemonType(type.type.name))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 12)
        }
        .background(Color(UIColor.systemBackground).opacity(0.15))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
} 