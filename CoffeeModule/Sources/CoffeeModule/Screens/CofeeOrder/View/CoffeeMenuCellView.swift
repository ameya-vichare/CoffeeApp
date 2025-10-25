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
    private let viewModel: MenuCellViewModel
    
    init(viewModel: MenuCellViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            HStack(alignment: .top) {
                CoffeeMenuDetailView(viewModel: viewModel)
                
                Spacer()
                
                CoffeeMenuActionView(viewModel: viewModel)
            }
            .padding([.bottom, .top], AppPointSystem.point_12)
            .padding([.leading, .trailing], AppPointSystem.point_16)
        }
    }
}

struct CoffeeMenuDetailView: View {
    private let viewModel: MenuCellViewModel
    
    init(viewModel: MenuCellViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(viewModel.name)
                .font(AppFonts.headlineMedium)
                .padding([.top], 10)
            
            Text("\(viewModel.currency) \(viewModel.price)")
                .font(AppFonts.subHeadlineMedium)
                .padding([.top], 2)
            
            Text(viewModel.description)
                .font(AppFonts.captionMedium)
                .foregroundStyle(AppColors.primaryGray)
                .padding([.top], 2)
        }
    }
}

struct CoffeeMenuActionView: View {
    @Environment(\.imageService) var imageService: ImageService
    private let viewModel: MenuCellViewModel
    
    init(viewModel: MenuCellViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            CustomImageView(
                url: viewModel.imageURL,
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
    CoffeeMenuCellView(
        viewModel: MenuCellViewModel(
            name: "Hot Americano",
            currency: "USD",
            price: 0.0,
            description: "A shot of espresso, diluted to create a smooth black coffee.",
            imageURL: "https://images.unsplash.com/photo-1669872484166-e11b9638b50e"
        )
    )
}
