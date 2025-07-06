import SwiftUI

struct LoadingView: View {
    @StateObject private var viewModel = LoadingScreenViewModel()

    var body: some View {
        // Switch on the view model's state
        switch viewModel.state {
        case .loading:
            ProgressView("Loading users...")
                .onAppear {
                    // Trigger the data load when the view appears
                    viewModel.loadData()
                }
            
        case .success(let users):
            // When data is loaded, show the UserListView
            UserListView(users: users)
            
        case .failure(let error):
            // Always handle potential errors
            Text("Failed to load users: \(error.localizedDescription)")
                .padding()
        }
    }
}
