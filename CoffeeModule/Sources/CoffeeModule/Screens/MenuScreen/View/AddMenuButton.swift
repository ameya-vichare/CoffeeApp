//
//  BrewCrewAddMenuButton.swift
//  CoffeeModule
//
//  Created by Ameya on 23/10/25.
//

import SwiftUI
import DesignSystem
import ImageLoading
import AppModels

struct AddMenuButton: View {
    @State private var showSheet = false
    private var viewModel: MenuListCellViewModel
    
    init(viewModel: MenuListCellViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Button {
            showSheet = true
        } label: {
            ZStack(alignment: .center) {
                RoundedRectangle(cornerRadius: AppPointSystem.point_12)
                    .frame(
                        width: AppPointSystem.point_120,
                        height: AppPointSystem.point_44
                    )
                    .foregroundStyle(AppColors.secondaryGray)
                    .overlay {
                        RoundedRectangle(cornerRadius: AppPointSystem.point_12)
                            .stroke(AppColors.primaryCoffee, lineWidth: 1)
                    }
                    
                Text("ADD")
                    .font(AppFonts.headline)
                    .foregroundStyle(AppColors.primaryCoffee)
            }
            .offset(y: AppPointSystem.point_44/2)
        }
        .buttonStyle(.plain)
        .tint(AppColors.black)
        .sheet(isPresented: $showSheet) {
            VStack {
                MenuModifierBottomSheet(
                    viewModel: MenuModifierBottomSheetViewModel(
                        modifiers: viewModel.modifiers
                    )
                )
            }
            .presentationCornerRadius(AppPointSystem.point_20)
            .presentationDragIndicator(.visible)
            .presentationDetents([.fraction(0.5),.large])
        }
    }
}

#Preview {
    AddMenuButton(
        viewModel: MenuListCellViewModel(
            id: 0,
            name: "Hot Americano",
            currency: "USD",
            price: 0.0,
            description: "A shot of espresso, diluted to create a smooth black coffee.",
            imageURL: "https://images.unsplash.com/photo-1669872484166-e11b9638b50e",
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
            ]
        )
    )
}
