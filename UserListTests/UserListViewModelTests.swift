//
//  UserListViewModelTests.swift
//  UserListTests
//
//  Created by Boualem Dahmane on 25/08/2024.
//

import XCTest
import Combine
@testable import UserList

// Test case class for validating the functionality of the UserListViewModel
final class UserListViewModelTests: XCTestCase {
    var cancellables: Set<AnyCancellable> = []
    var repository: UserListRepository!
    var viewModel: UserListViewModel!
    
    // Setup method initializes the UserListViewModel with a mock repository to simulate data fetching, ensuring tests run in a controlled environment
    override func setUp() {
        super.setUp()
        repository = UserListRepository(executeDataRequest: mockExecuteDataRequest) // Use a mock repository to inject simulated data
        viewModel = UserListViewModel(repository: repository)
    }
    
    // Teardown method clears subscriptions to avoid memory leaks and ensure no interference with subsequent tests
    override func tearDown() {
        cancellables.removeAll()
        super.tearDown()
    }
    
    //Test to check if the viewModel correctly determines when more data should be loaded
    func testShouldLoadMoreData() {
        // Simulate loading users
        viewModel.fetchUsers()
        
        let expectation = XCTestExpectation(description: "Data loaded")
        
        // Subscribe to the users property and fulfill the expectation when data is loaded
        viewModel.$users
            .dropFirst() // Ignore the initial empty state
            .sink { users in
                if !users.isEmpty {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // Wait for the expectation to be fulfilled
        wait(for: [expectation], timeout: 2.0)
        
        // Determine if more data should be loaded based on the last user in the list
        let shouldLoadMore = viewModel.shouldLoadMoreData(currentItem: viewModel.users.last!)
        
        // Verify that more data should indeed be loaded
        XCTAssertTrue(shouldLoadMore)
    }
    
    // Test to verify that the UserListViewModel successfully fetches user data
    func testFetchUsersSuccess() {
        // Trigger user data fetching
        viewModel.fetchUsers()
        
        let expectation = XCTestExpectation(description: "Users fetched successfully")
        
        // Subscribe to the users property and fulfill expectation when users are loaded
        viewModel.$users
            .dropFirst()
            .sink { users in
                if users.count == 2 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        // Wait for the expectation to be fulfilled
        wait(for: [expectation], timeout: 2.0)
        
        // Ensure the loading state is false after fetching is complete
        XCTAssertFalse(viewModel.isLoading)
        // Verify that no error occurred and the correct users were fetched
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.users.count, 2)
        XCTAssertEqual(viewModel.users[0].name.first, "John")
        XCTAssertEqual(viewModel.users[1].name.last, "Smith")
    }
    
    // Test to verify the handling of fetch failure
    func testFetchUsersFailure() {
        // Simulate a failure by redefining the repository with a function that throws an error
        repository = UserListRepository(executeDataRequest: { _ in throw URLError(.badServerResponse) })
        viewModel = UserListViewModel(repository: repository)
        
        let expectation = XCTestExpectation(description: "Fetch users failed")
        
        // Trigger user data fetching
        viewModel.fetchUsers()
        
        // Subscribe to the users property and fulfill the expectation when an error occurs
        viewModel.$users
            .dropFirst()
            .sink { users in
                if users.isEmpty {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // Wait for the expectation to be fulfilled or timeout
        wait(for: [expectation], timeout: 2.0)
        
        // Verify that loading state is false, no users were fetched, and the correct error message is displayed
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.users.isEmpty)
        XCTAssertEqual(viewModel.errorMessage, "Failed to load users. Please try again later.")
    }
    
    // Test to verify the behavior when fetching an empty user list
    func testFetchEmptyUserList() {
        // Simulate a response with an empty list of users
        let emptyResponseJSON = """
        {
            "results": []
        }
        """
        let emptyData = emptyResponseJSON.data(using: .utf8)!
        repository = UserListRepository(executeDataRequest: { _ in
            return (emptyData, HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!)
        })
        viewModel = UserListViewModel(repository: repository)
        
        // Trigger user data fetching
        viewModel.fetchUsers()
        
        let expectation = XCTestExpectation(description: "Empty user list fetched")
        // Subscribe to the users property and fulfill the expectation when the list is confirmed to be empty
        viewModel.$users
            .dropFirst()
            .sink { users in
                if users.isEmpty {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        // Wait for the expectation to be fulfilled or timeout (extended to ensure completion)
        wait(for: [expectation], timeout: 5.0)
        
        // Verify that loading state is false, no users were fetched, and no error message is displayed
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.users.isEmpty)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    // Test to verify that reloading users works correctly
    func testReloadUsers() {
        //Initially load users
        viewModel.fetchUsers()
        
        let fetchExpectation = XCTestExpectation(description: "Users fetched successfully")
        
        // Subscribe to the users property and fulfill the expectation when users are loaded
        viewModel.$users
            .dropFirst()
            .sink { users in
                if users.count == 2 {
                    fetchExpectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        wait(for: [fetchExpectation], timeout: 2.0)
        
        // Trigger user data reloading
        viewModel.reloadUsers()
        XCTAssertTrue(viewModel.users.isEmpty) // Assert that users list is cleared
        XCTAssertTrue(viewModel.isLoading) // Assert that loading state is true
        
        let reloadExpectation = XCTestExpectation(description: "Users reloaded successfully")
        
        // Subscribe to the users property and fulfill the expectation when users are reloaded
        viewModel.$users
            .dropFirst()
            .sink { users in
                if users.count == 2 {
                    reloadExpectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        wait(for: [reloadExpectation], timeout: 2.0)
        
        // Ensure loading state is false and the correct users are fetched again
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.users.count, 2)
    }
    
    // Test to verify that toggling the grid view mode correctly updates the isGridView state
    func testToggleGridView() {
        
        XCTAssertFalse(viewModel.isGridView)
        
        viewModel.isGridView.toggle()
        
        XCTAssertTrue(viewModel.isGridView)
    }
    
    // Test to verify toggling the loading state
    func testToggleIsLoading() {
        
        XCTAssertFalse(viewModel.isLoading)
        
        viewModel.isLoading.toggle()
        
        XCTAssertTrue(viewModel.isLoading)
    }
}
