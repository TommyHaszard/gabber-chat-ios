import SwiftUI

struct LoadingView: View {
    @EnvironmentObject var dependencies: AppDependencies
    @StateObject private var viewModel = LoadingScreenViewModel()

    var body: some View {
        switch viewModel.state {
        case .loading:
            ProgressView("Loading users...")
                .onAppear {
                    viewModel.loadData(with: dependencies)
                }
            
        case .success(let users):
            UserContentView()
            
        case .failure(let error):
            // Always handle potential errors
            Text("Failed to load users: \(error.localizedDescription)")
                .padding()
        }
    }
}
