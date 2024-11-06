import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = PokemonViewModel()
    @State private var searchText = ""
    @State private var selectedType: String?
    @State private var showingCamera = false
    @State private var currentPokemonId: Int?
    
    // Break down filtering into smaller functions
    private func filterBySearch(_ pokemon: [Pokemon]) -> [Pokemon] {
        guard !searchText.isEmpty else { return pokemon }
        return pokemon.filter { pokemon in
            pokemon.name.lowercased().contains(searchText.lowercased()) ||
            String(pokemon.id).contains(searchText)
        }
    }
    
    private func filterByType(_ pokemon: [Pokemon]) -> [Pokemon] {
        guard let type = selectedType else { return pokemon }
        return pokemon.filter { pokemon in
            pokemon.types.contains { $0.type.name == type }
        }
    }
    
    // Compute filtered pokemon in steps
    private var searchFiltered: [Pokemon] {
        filterBySearch(viewModel.pokemons)
    }
    
    private var typeFiltered: [Pokemon] {
        filterByType(searchFiltered)
    }
    
    private var filteredPokemon: [Pokemon] {
        typeFiltered.sorted { $0.id < $1.id }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [
                        Color(red: 0.05, green: 0.08, blue: 0.2),
                        Color(red: 0.1, green: 0.15, blue: 0.3)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Search bar
                    SearchBar(text: $searchText)
                        .padding(.horizontal)
                        .padding(.top)
                    
                    // Type filters
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(Type.allTypes, id: \.self) { type in
                                TypeFilterButton(
                                    type: type,
                                    isSelected: type == selectedType
                                ) {
                                    withAnimation {
                                        if selectedType == type {
                                            selectedType = nil
                                        } else {
                                            selectedType = type
                                        }
                                        HapticFeedback.impact()
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                    }
                    .background(Color(UIColor.systemBackground).opacity(0.1))
                    
                    // Main content
                    if viewModel.isLoading {
                        Spacer()
                        ProgressView("Loading Pokédex...")
                            .foregroundColor(.white)
                        Spacer()
                    } else if filteredPokemon.isEmpty {
                        Spacer()
                        Text("No Pokémon Found")
                            .foregroundColor(.white)
                            .font(.title2)
                        Spacer()
                    } else {
                        ScrollView {
                            LazyVGrid(
                                columns: [
                                    GridItem(.flexible()),
                                    GridItem(.flexible())
                                ],
                                spacing: 16
                            ) {
                                ForEach(filteredPokemon) { pokemon in
                                    NavigationLink(
                                        destination: PokemonDetailView(pokemon: pokemon)
                                            .environmentObject(viewModel)
                                    ) {
                                        PokemonCard(pokemon: pokemon)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .contentShape(Rectangle())
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationTitle("Pokédex")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 16) {
                        Button {
                            showingCamera = true
                            HapticFeedback.impact()
                        } label: {
                            Image(systemName: "camera.fill")
                                .foregroundColor(RotomColors.primary)
                        }
                        
                        Button {
                            Task {
                                HapticFeedback.impact()
                                await viewModel.fetchPokemons()
                            }
                        } label: {
                            Image(systemName: "arrow.clockwise")
                                .foregroundColor(RotomColors.primary)
                        }
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $showingCamera) {
            CameraView()
        }
        .task {
            if viewModel.pokemons.isEmpty {
                await viewModel.fetchPokemons()
            }
        }
    }
} 