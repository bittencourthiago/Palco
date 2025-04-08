import SwiftUI

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var items: [HomeItem] = []
    private let service = HomeService()

    func loadItems() async {
        do {
            let home = try await service.fetchHome()
            title = home.title
            items = home.items
        } catch {
            items = []
        }
    }
}


struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
            ZStack {
                MeshGradientView()
                VStack(spacing: -52) {
                    HStack {
                        Spacer()
                        Text("Brasil")
                            .font(.system(size: 40, weight: .bold))
                            .padding(.top, 70)
                            .padding(.bottom, 30)
                        Spacer()
                    }
                    
                    .glass(cornerRadius: 40)
                    .ignoresSafeArea()
                    VStack {
                        HStack {
                            Spacer()
                            Text("Login")
                            Spacer()
                        }
                        Spacer()
                    }
                    .glass(cornerRadius: 40)
                    .padding(.bottom, 20)
                    .padding(.horizontal, 20)
                    .ignoresSafeArea()
                    
                }
                
                
//                VStack {
//                    Text(viewModel.title)
//                        .font(.title.bold())
//                    VStack {
//                        Text("test")
//                    }
//                    .glass(cornerRadius: 8)
//
//                    ForEach(viewModel.items, id: \.self) { item in
//                        switch item.type {
//                        case .list:
//                            HomeListView(item: item)
//                            Spacer()
//                        case .grid:
//                            HomeGridView(
//                                items: item.gridValues ?? [],
//                                columnsCount: item.columnsCount ?? 4
//                            )
//                            Spacer()
//                        }
//                    }
//                }
//                .padding(24)
//                .task {
//                    await viewModel.loadItems()
//                }
            }
    }
}

#Preview {
    ContentView()
}
