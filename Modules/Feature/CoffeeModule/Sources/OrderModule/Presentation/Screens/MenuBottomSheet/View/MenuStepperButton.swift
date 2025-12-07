//
//  BrewCrewMenuStepperButton.swift
//  CoffeeModule
//
//  Created by Ameya on 01/11/25.
//

import SwiftUI
import ImageLoading
import AppCore

struct MenuStepperButton: View {
    @State private var isIncrementing: Bool = false
    
    @ObservedObject private var viewModel: DefaultMenuModifierBottomSheetFooterViewModel
    
    init(viewModel: DefaultMenuModifierBottomSheetFooterViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: AppPointSystem.point_12)
                .stroke(AppColors.primaryCoffee, lineWidth: 1)
                .frame(
                    width: AppPointSystem.point_120,
                    height: AppPointSystem.point_44
                )
                .foregroundStyle(AppColors.white)
            
            HStack(spacing: 0) {
                Button {
                    isIncrementing = false
                    viewModel.decrementQuantity()
                } label: {
                    Image(systemName: "minus")
                        .frame(width: AppPointSystem.point_40, height: AppPointSystem.point_40)
                        .foregroundStyle(AppColors.primaryCoffee)
                }
                .buttonStyle(.plain)
                .contentShape(Rectangle())
                
                ZStack {
                    Text("\(viewModel.quantitySelection)")
                        .font(AppFonts.headline)
                        .foregroundStyle(AppColors.black)
                        .frame(width: AppPointSystem.point_24, alignment: .center)
                        .id(viewModel.quantitySelection)
                        .transition(
                            .asymmetric(
                                insertion: .move(
                                    edge: isIncrementing ? .bottom : .top
                                ).combined(with: .opacity),
                                removal: .move(
                                    edge: isIncrementing ? .top : .bottom
                                ).combined(with: .opacity)
                            )
                        )
                }.animation(
                    .spring(response: 0.35, dampingFraction: 0.75),
                    value: viewModel.quantitySelection
                )
                

                Button {
                    isIncrementing = true
                    viewModel.incrementQuantity()
                } label: {
                    Image(systemName: "plus")
                        .frame(width: AppPointSystem.point_40, height: AppPointSystem.point_40)
                        .foregroundStyle(AppColors.primaryCoffee)
                }
                .buttonStyle(.plain)
                .contentShape(Rectangle())
            }
        }
    }
}

#Preview {
    MenuStepperButton(
        viewModel: DefaultMenuModifierBottomSheetFooterViewModel(currency: "USD")
    )
}
