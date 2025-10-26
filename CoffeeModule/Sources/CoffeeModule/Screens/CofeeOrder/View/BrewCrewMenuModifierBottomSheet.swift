//
//  BrewCrewMenuModifierBottomSheet.swift
//  CoffeeModule
//
//  Created by Ameya on 25/10/25.
//

import SwiftUI
import DesignSystem
import ImageLoading

struct BrewCrewMenuModifierBottomSheet: View {
    
    var items : [String] = ["Regular", "Medium", "Large"]

    var body: some View {
        VStack {
            MenuModifierHeaderView()
            
            List(items, id: \.self) { item in
                Section(header: Text("Fruits")) {
                    Text("Apple")
                        .listRowSeparator(.hidden)
                }
                
            }
            .listStyle(.grouped)
            
            Spacer()
        }
    }
}

struct MenuModifierHeaderView: View {
    @Environment(\.imageService) var imageService
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(height: AppPointSystem.point_80)
                .foregroundStyle(AppColors.white)
                .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 4)
            
            HStack(spacing: AppPointSystem.point_12) {
                CustomImageView(
                    url: URL(string: "https://www.acouplecooks.com/wp-content/uploads/2020/10/how-to-make-cappuccino-005.jpg"),
                    targetSize: CGSize(width: AppPointSystem.point_60, height: AppPointSystem.point_60),
                    imageService: imageService) {
                        ProgressView()
                    }
                    .frame(width: AppPointSystem.point_60, height: AppPointSystem.point_60)
                    .clipShape(
                        RoundedRectangle(cornerRadius: AppPointSystem.point_12)
                    )
                
                Text("Hot Cappuccino")
                    .font(AppFonts.title3Medium)
                
                Spacer()
            }
            .padding([.leading, .trailing], 12)
        }
    }
    
}

#Preview {
    BrewCrewMenuModifierBottomSheet()
}
