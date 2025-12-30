//
//  SwiftUIView.swift
//  ProfileModule
//
//  Created by Ameya on 29/12/25.
//

import SwiftUI
import AppCore

struct SectionModel: Identifiable {
    let id = UUID()
    let title: String
    let rows: [RowModel]
    
    init(title: String, rows: [RowModel]) {
        self.title = title
        self.rows = rows
    }
}

struct RowModel: Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
    
    init(title: String, imageName: String) {
        self.title = title
        self.imageName = imageName
    }
}

public struct ProfileView: View {
    let profileSections: [SectionModel] = [
        SectionModel(
            title: "Section1",
            rows: [
                RowModel(
                    title: "Settings",
                    imageName: "gearshape"
                ),
                RowModel(
                    title: "My Orders",
                    imageName: "list.bullet"
                ),
                RowModel(
                    title: "Address",
                    imageName: "mappin.and.ellipse"
                ),
                RowModel(
                    title: "Change Password",
                    imageName: "lock"
                )
            ]
        ),
        SectionModel(
            title: "Section2",
            rows: [
                RowModel(
                    title: "Help & Support",
                    imageName: "questionmark.circle"
                ),
                RowModel(
                    title: "Logout",
                    imageName: "arrow.right.square"
                )
            ]
        )
    ]
    
    public init () {}
    
    public var body: some View {
        ZStack {
            List {
                ForEach(profileSections.enumerated(), id: \.element.id) { index, section in
                    
                    ForEach(section.rows) { row in
                        ProfileCellView(rowModel: row)
                            .listRowSeparator(.hidden)
                            .listRowInsets(
                                EdgeInsets(
                                    top: AppPointSystem.point_0,
                                    leading: AppPointSystem.point_0,
                                    bottom: AppPointSystem.point_0,
                                    trailing: AppPointSystem.point_0
                                )
                            )
                    }
                    
                    if index != profileSections.count - 1 {
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
    let rowModel: RowModel
    
    init(rowModel: RowModel) {
        self.rowModel = rowModel
    }
    
    public var body: some View {
        HStack {
            Image(systemName: rowModel.imageName)
            
            Text(rowModel.title)
                .font(AppFonts.headlineRegular)

            Spacer()
            
            Image(systemName: "chevron.right")
        }
        .padding([.horizontal], AppPointSystem.point_24)
    }
}

#Preview {
    NavigationStack {
        ProfileView()
    }
}
