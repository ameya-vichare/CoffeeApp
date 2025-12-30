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
    let rows: [RowType]
    
    init(rows: [RowType]) {
        self.rows = rows
    }
}

enum RowType: Identifiable {
    var id: String {
        self.name
    }
    
    case settings
    case myOrders
    case address
    case changePassword
    case helpAndSupport
    case logout
    
    var name: String {
        switch self {
        case .settings: return "Settings"
        case .myOrders: return "My Orders"
        case .address: return "Address"
        case .changePassword: return "Change Password"
        case .helpAndSupport: return "Help & Support"
        case .logout: return "Logout"
        }
    }
    
    var imageName: String {
        switch self {
        case .settings: return "gearshape"
        case .myOrders: return "list.bullet"
        case .address: return "mappin.and.ellipse"
        case .changePassword: return "lock"
        case .helpAndSupport: return "questionmark.circle"
        case .logout: return "arrow.right.square"
        }
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
            rows: [
                .settings,
                .myOrders,
                .address,
                .changePassword
            ]
        ),
        SectionModel(
            rows: [
                .helpAndSupport,
                .logout
            ]
        )
    ]
    
    public init () {}
    
    public var body: some View {
        ZStack {
            List {
                ForEach(profileSections.enumerated(), id: \.element.id) { index, section in
                    
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
                                print("Cell tapped \(rowType)")
                            }
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
    let rowType: RowType
    
    init(rowType: RowType) {
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
        ProfileView()
    }
}
