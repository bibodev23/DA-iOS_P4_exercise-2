//
//  TollbarContent.swift
//  UserList
//
//  Created by Boualem Dahmane on 02/09/2024.
//

import SwiftUI

struct ToolbarViewUsersList: View {
    @ObservedObject var viewModel: UserListViewModel
    var body: some View {
        HStack {
            Picker(selection: $viewModel.isGridView, label: Text("Display")) {
                Image(systemName: "rectangle.grid.1x2.fill")
                    .tag(true)
                    .accessibilityLabel(Text("Grid view"))
                Image(systemName: "list.bullet")
                    .tag(false)
                    .accessibilityLabel(Text("List view"))
            }
            .pickerStyle(SegmentedPickerStyle())
            
            Button(action: {
                viewModel.reloadUsers()
            }) {
                Image(systemName: "arrow.clockwise")
                    .imageScale(.large)
            }
        }
    }
}


