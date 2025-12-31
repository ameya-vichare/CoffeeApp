//
//  SwiftUIView.swift
//  ProfileModule
//
//  Created by Ameya on 29/12/25.
//

import SwiftUI
import AppCore

public struct ProfileView<ViewModel: ProfileViewModel>: View {
    @ObservedObject var viewModel: ViewModel
    
    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ZStack {
            List {
                ForEach(viewModel.profileSections.enumerated(), id: \.element.id) { index, section in
                    
                    ForEach(section.rows) { rowType in
                        ProfileCellView(rowType: rowType)
                            .listRowSeparator(.hidden)
                            .listRowInsets(
                                EdgeInsets(
                                    top: AppPointSystem.point_0,
                                    leading: AppPointSystem.point_0,
                                    bottom: AppPointSystem.point_0,
                                    trailing: AppPointSystem.point_0
                                )
                            )
                            .onTapGesture {
                                viewModel.didSelectRow(with: rowType)
                            }
                    }
                    
                    if index != viewModel.profileSections.count - 1 {
                        Rectangle()
                            .foregroundStyle(AppColors.primaryGray)
                            .opacity(0.3)
                            .frame(height: 1)
                            .padding([.horizontal], AppPointSystem.point_12)
                    }
                }
            }
            .listStyle(.plain)
            .background(AppColors.clear)
        }
        .navigationTitle("Profile")
    }
}

public struct ProfileCellView: View {
    let rowType: ProfileRowType
    
    init(rowType: ProfileRowType) {
        self.rowType = rowType
    }
    
    public var body: some View {
        HStack {
            Image(systemName: rowType.imageName)
            
            Text(rowType.name)
                .font(AppFonts.headlineRegular)

            Spacer()
            
            Image(systemName: "chevron.right")
        }
        .contentShape(Rectangle())
        .padding([.horizontal], AppPointSystem.point_24)
        .padding([.vertical], AppPointSystem.point_12)
    }
}

#Preview {
    NavigationStack {
        ProfileView(viewModel: DefaultProfileViewModel())
    }
}
