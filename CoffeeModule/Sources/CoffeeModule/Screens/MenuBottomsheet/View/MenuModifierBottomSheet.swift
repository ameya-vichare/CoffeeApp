//
//  BrewCrewMenuModifierBottomSheet.swift
//  CoffeeModule
//
//  Created by Ameya on 25/10/25.
//

import SwiftUI
import DesignSystem
import ImageLoading
import AppModels

struct MenuModifierBottomSheet: View {
    @ObservedObject private var viewModel: MenuModifierBottomSheetViewModel
    
    init(viewModel: MenuModifierBottomSheetViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(spacing: 0) {
            MenuModifierHeaderView()
            
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(self.viewModel.modifierViewModels) { viewModel in
                        MenuModifierCellView(viewModel: viewModel)
                    }
                }
            }
            .padding()
            
            Spacer()
            
            MenuModifierFooterView(viewModel: viewModel)
        }
        .background(AppColors.secondaryGray)
    }
}

struct MenuModifierCellView: View {
    @ObservedObject private var viewModel: MenuModifierCategoryCellViewModel
    
    init(viewModel: MenuModifierCategoryCellViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(
                cornerRadius: AppPointSystem.point_12
            )
                .foregroundStyle(AppColors.white)
                .padding([.bottom], AppPointSystem.point_12)
            
            VStack(alignment: .leading) {
                Text(viewModel.name)
                    .font(AppFonts.headline)
                    .foregroundStyle(AppColors.black)
                
                Text(viewModel.displayDescription)
                    .font(AppFonts.subHeadline)
                    .foregroundStyle(AppColors.primaryGray)
                
                Divider()
                    .padding([.bottom], 10)
                
                ForEach(viewModel.options) { viewModel in
                    MenuModifierSelectionView(viewModel: viewModel)
                }
            }
            .padding()
        }
    }
}

struct MenuModifierSelectionView: View {
    @ObservedObject private var viewModel: MenuModifierSelectionCellViewModel
    
    init(viewModel: MenuModifierSelectionCellViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        HStack {
            Text(viewModel.name)
                .font(AppFonts.subHeadline)
                .foregroundStyle(AppColors.black)

            Spacer()
            
            Text("\(viewModel.currency) \(viewModel.displayPrice)")
                .font(AppFonts.subHeadline)
                .foregroundStyle(AppColors.black)
            
            Image(systemName: viewModel.isSelected ? "record.circle" : "circle")
                .foregroundStyle(
                    AppColors.primaryCoffee
                )
        }
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.toggleSelection()
        }
        .padding([.bottom], 10)
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

struct MenuModifierFooterView: View {
    @ObservedObject private var viewModel: MenuModifierBottomSheetViewModel
    
    init(viewModel: MenuModifierBottomSheetViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(height: AppPointSystem.point_80)
                .foregroundStyle(AppColors.white)
            
            HStack(alignment: .center, spacing: AppPointSystem.point_4) {
                MenuStepperButton()
                
                Spacer()
                
                MenuAddToCartButton(viewModel: viewModel)
            }
            .padding()
        }
    }
}

struct MenuAddToCartButton: View {
    @ObservedObject private var viewModel: MenuModifierBottomSheetViewModel
    
    init(viewModel: MenuModifierBottomSheetViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: AppPointSystem.point_12)
                .frame(height: AppPointSystem.point_44)
                .foregroundStyle(AppColors.primaryCoffee)
            
            Text(
                "Add item - \(viewModel.currency) \(viewModel.totalPrice.formatPrice())"
            )
            .font(AppFonts.mediumSixteen)
                .foregroundStyle(AppColors.white)
        }
    }
}

#Preview {
    MenuModifierBottomSheet(
        viewModel: MenuModifierBottomSheetViewModel(
            modifiers: [
                MenuModifier(
                    id: 1,
                    name: "Milk Type",
                    selectionType: .single,
                    minSelect: 1,
                    maxSelect: 1,
                    options: [
                        MenuModifierOption(
                            id: 3,
                            name: "Oat Milk",
                            price: 0.50,
                            currency: "USD",
                            isDefault: true
                        )
                    ]
                )
            ],
            currency: "USD"
        )
    )
}
