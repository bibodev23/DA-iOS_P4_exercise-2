//
//  ListView.swift
//  UserList
//
//  Created by Boualem Dahmane on 02/09/2024.
//

import SwiftUI

struct ListView: View {
    @ObservedObject var viewModel: UserListViewModel
    var body: some View {
        List(viewModel.users) { user in
            NavigationLink(destination: UserDetailView(user: user)) {
                HStack {
                    AsyncImage(url: URL(string: user.picture.thumbnail)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    } placeholder: {
                        ProgressView()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    }
                    
                    VStack(alignment: .leading) {
                        Text("\(user.name.first) \(user.name.last)")
                            .font(.headline)
                        Text("\(user.dob.date)")
                            .font(.subheadline)
                    }
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
