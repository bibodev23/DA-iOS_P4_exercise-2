//
//  UserListViewModel.swift
//  UserList
//
//  Created by Boualem Dahmane on 21/08/2024.
//

import Foundation
import SwiftUI

final class UserListViewModel: ObservableObject {
    // MARK: - Private properties
    private let repository: UserListRepository
    
    // MARK: - Init
    
    init(repository: UserListRepository) {
        self.repository = repository
        self.users = []
    }
    
    // MARK: - Outputs
    
    @Published var users: [User] = []
    @Published var isLoading: Bool = false
    @Published var isGridView: Bool = false
    
    func shouldLoadMoreData(currentItem item: User) -> Bool {
        guard let lastItem = users.last else { return false }
        return !isLoading && item.id == lastItem.id
    }
    
    // MARK: - Inputs
    
    func fetchUsers() {
        isLoading = true
        //Asynchrone code with Task
        Task {
            do {
                let users = try await repository.fetchUsers(quantity: 20)
                // Ensure updates to published properties happen on the main thread to avoid SwiftUI warnings
                DispatchQueue.main.async {
                    self.users.append(contentsOf: users)
                    self.isLoading = false
                }
                
            } catch {
                print("Error fetching users: \(error.localizedDescription)")
                // Ensure isLoading flag is updated on the main thread in case of an error
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }
    }

    func reloadUsers() {
        users.removeAll()
        fetchUsers()
    }
}
