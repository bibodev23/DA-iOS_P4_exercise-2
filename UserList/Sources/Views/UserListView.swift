import SwiftUI

// Main view for displaying the user list
struct UserListView: View {
    
    // ViewModel observed to react to data changes
    @ObservedObject var viewModel: UserListViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                //Error view to handle and display errors
                ErrorView(viewModel: viewModel)
                // Toggle between list and grid view based on user preference
                if !viewModel.isGridView {
                    ListView(viewModel: viewModel)
                } else {
                    GridView(viewModel: viewModel)
                }
            }
            .navigationTitle("Users")
            .toolbar {
                ToolbarViewUsersList(viewModel: viewModel)
            }
        }
        // Fetch users when view appears
        .onAppear {
            viewModel.fetchUsers()
        }
    }
    
}

struct UserListView_Previews: PreviewProvider {
    static var previews: some View {
        UserListView(viewModel: UserListViewModel(repository: UserListRepository()))
    }
}

