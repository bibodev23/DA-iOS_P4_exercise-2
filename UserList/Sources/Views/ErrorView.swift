//
//  ErrorView.swift
//  UserList
//
//  Created by Boualem Dahmane on 03/09/2024.
//

import SwiftUI

struct ErrorView: View {
    @ObservedObject var viewModel: UserListViewModel
    var body: some View {
        if let errorMessage = viewModel.errorMessage {
            Text(errorMessage)
                .foregroundColor(.red)
                .padding()
        }
    }
}
