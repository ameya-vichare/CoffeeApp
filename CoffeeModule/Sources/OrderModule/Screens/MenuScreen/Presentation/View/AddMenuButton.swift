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
import Combine

struct AddMenuButton: View {
    @State private var showSheet = false
    private var viewModel: MenuListCellViewModel
    
    init(viewModel: MenuListCellViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Button {
            viewModel.showMenuModifierBottomsheet()
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
    }
}

#Preview {
    AddMenuButton(
        viewModel: MenuListCellViewModel(
            menuItem: MenuItem.createFake(),
            orderItemUpdates: PassthroughSubject<CreateOrderItem, Never>()
        )
    )
}
