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
    private let viewModel: MenuModifierBottomSheetViewModel
    
    init(viewModel: MenuModifierBottomSheetViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(spacing: 0) {
            MenuModifierHeaderView()
            
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(self.viewModel.modifierViewModels) { item in
                        Text(item.name)
                        
                        ForEach(item.options) { option in
                            Text(option.name)
                        }
                    }
                }
            }
            .background(AppColors.secondaryGray)
            
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
    BrewCrewMenuModifierBottomSheet(
        viewModel: MenuModifierBottomSheetViewModel(
            modifierViewModels: [
                MenuModifierViewModel(
                    id: 0,
                    name: "Milk",
                    minSelection: 1,
                    maxSelection: 1,
                    options: [
                        MenuModifierCellViewModel(
                            id: 0,
                            name: "Regular",
                            price: 12.0,
                            currency: "USD",
                            isDefault: true
                        ),
                        MenuModifierCellViewModel(
                            id: 2,
                            name: "Small",
                            price: 12.0,
                            currency: "USD",
                            isDefault: true
                        )
                    ]
                )
            ]
        )
    )
}
