//
//  UserListViewModel.swift
//  UserList
//
//  Created by Boualem Dahmane on 21/08/2024.
//

import Foundation
import SwiftUI

// The ViewModel class responsible for managing and exposing user data to the view
final class UserListViewModel: ObservableObject {
    // MARK: - Private properties
    // The repository responsible for fetching users from a data source
    private let repository: UserListRepository
    
    // MARK: - Init
    // Initialize the ViewModel with a repository instance
    init(repository: UserListRepository) {
        self.repository = repository
        self.users = []
    }
    
    // MARK: - Outputs
    // Published properties that the view will observe for updates
    @Published var users: [User] = []
    @Published var isLoading: Bool = false
    @Published var isGridView: Bool = false
    @Published var errorMessage: String?
    
    // Function to determine if more data should be loaded based on the current item
    func shouldLoadMoreData(currentItem item: User) -> Bool {
        // Ensure there's a last item
        guard let lastItem = users.last else { return false }
        return !isLoading && item.id == lastItem.id
    }
    
    // MARK: - Inputs
    // Function to fetch the users from the repository
    func fetchUsers() {
        // If a loading operation is already in progress, do nothing
        guard !isLoading else { return }
        // Indicate a data fetch is in progress
        isLoading = true
        // Asynchrone data fetching with a Task
        Task {
            do {
                // Attempt to fetch users from the repository
                let users = try await repository.fetchUsers(quantity: 20)
                
                DispatchQueue.main.async {
                    // Append the fetched users to the existing users array
                    self.users.append(contentsOf: users)
                    // Reset the loading flag once the operation is complete
                    self.isLoading = false
                }
            } catch {
                
                // Handle any errors that occur during fetching
                print("Error fetching users: \(error.localizedDescription)")
                self.errorMessage = "Failed to load users. Please try again later."
                // Reset array users
                self.users = []
                // Reseat loading flag
                self.isLoading = false
                
            }
        }
    }
    
    // Function to reload the users, clearing the current list and fetching them again
    func reloadUsers() {
        // Clear the current list of users
        users.removeAll()
        // Fetch the users again
        fetchUsers()
    }
}
