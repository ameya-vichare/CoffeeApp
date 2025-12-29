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
    let title: String
    
    init(title: String) {
        self.title = title
    }
}

public struct ProfileView: View {
    let profileSections: [SectionModel] = [
        SectionModel(
            title: "Section1",
            rows: [
                RowModel(title: "Edit Profile"),
                RowModel(title: "About")
            ]
        ),
        SectionModel(
            title: "Section2",
            rows: [
                RowModel(title: "Logout"),
                RowModel(title: "App Version")
            ]
        )
    ]
    
    public init () {}
    
    public var body: some View {
        ZStack {
            List(profileSections) { section in
                Section(section.title) {
                    ForEach(section.rows) { row in
                        ProfileCellView()
                            .listRowSeparator(.hidden)
                    }
                }
            }
            .listStyle(.plain)
        }
        .navigationTitle("Profile")
    }
}

public struct ProfileCellView: View {
    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: AppPointSystem.point_12)
                .foregroundStyle(AppColors.secondaryGray)
            
            HStack {
                Text("Hello, World!")
                    .padding()
                
                Spacer()
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView()
    }
}
