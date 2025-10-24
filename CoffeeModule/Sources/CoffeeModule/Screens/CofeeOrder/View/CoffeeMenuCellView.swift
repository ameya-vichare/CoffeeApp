//
//  SwiftUIView.swift
//  CoffeeModule
//
//  Created by Ameya on 22/10/25.
//

import SwiftUI
import DesignSystem
import ImageLoading

struct CoffeeMenuCellView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: AppPointSystem.point_12)
                .foregroundStyle(AppColors.white)
            
            HStack(alignment: .top) {
                CoffeeMenuDetailView()
                
                CoffeeMenuActionView()
            }
            .padding([.bottom, .top], AppPointSystem.point_12)
            .padding([.leading, .trailing], AppPointSystem.point_16)
        }
    }
}

struct CoffeeMenuDetailView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Hot Latte")
                .font(AppFonts.headlineMedium)
                .padding([.top], 10)
            
            Text("USD 12")
                .font(AppFonts.subHeadlineMedium)
                .padding([.top], 2)
            
            Text("A shot of espresso, diluted to create a smooth black coffee.")
                .font(AppFonts.captionMedium)
                .foregroundStyle(AppColors.primaryGray)
                .padding([.top], 2)
        }
    }
}

struct CoffeeMenuActionView: View {
    @Environment(\.imageService) var imageService: ImageService
    
    var body: some View {
        ZStack(alignment: .bottom) {
            CustomImageView(
                url: URL(string: "https://www.acouplecooks.com/wp-content/uploads/2020/10/how-to-make-cappuccino-005.jpg"),
                targetSize: CGSize(width: AppPointSystem.point_150, height: AppPointSystem.point_150),
                imageService: imageService) {
                    ProgressView()
            }
                .frame(width: AppPointSystem.point_150, height: AppPointSystem.point_150)
                .clipShape(RoundedRectangle(cornerRadius: AppPointSystem.point_12))
                .overlay(alignment: .bottom) {
                    BrewCrewAddMenuView()
                }
                .padding([.bottom], AppPointSystem.point_44/2)

        }
    }
}

#Preview {
    CoffeeMenuCellView()
}
