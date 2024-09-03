//
//  GridView.swift
//  UserList
//
//  Created by Boualem Dahmane on 02/09/2024.
//

import SwiftUI

struct GridView: View {
    @ObservedObject var viewModel: UserListViewModel
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
                ForEach(viewModel.users) { user in
                    NavigationLink(destination: UserDetailView(user: user)) {
                        VStack {
                            AsyncImage(url: URL(string: user.picture.medium)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 150, height: 150)
                                    .clipShape(Circle())
                            } placeholder: {
                                ProgressView()
                                    .frame(width: 150, height: 150)
                                    .clipShape(Circle())
                            }
                            
                            Text("\(user.name.first) \(user.name.last)")
                                .font(.headline)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .onAppear {
                        if viewModel.shouldLoadMoreData(currentItem: user) {
                            viewModel.fetchUsers()
                        }
                    }
                }
            }
        }
    }
}


