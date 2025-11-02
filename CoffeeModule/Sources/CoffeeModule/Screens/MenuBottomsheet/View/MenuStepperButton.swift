//
//  BrewCrewMenuStepperButton.swift
//  CoffeeModule
//
//  Created by Ameya on 01/11/25.
//

import SwiftUI
import DesignSystem
import ImageLoading
import AppModels

struct MenuStepperButton: View {
    @State var selectionCount: Int = 1
    @State private var isIncrementing: Bool = false
    
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
                    selectionCount = max(1, selectionCount - 1)
                } label: {
                    Image(systemName: "minus")
                        .frame(width: AppPointSystem.point_40, height: AppPointSystem.point_40)
                        .foregroundStyle(AppColors.primaryCoffee)
                }
                .buttonStyle(.plain)
                .contentShape(Rectangle())
                
                ZStack {
                    Text("\(selectionCount)")
                        .font(AppFonts.headline)
                        .foregroundStyle(AppColors.black)
                        .frame(width: AppPointSystem.point_24, alignment: .center)
                        .id(selectionCount)
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
                    value: selectionCount
                )
                

                Button {
                    isIncrementing = true
                    selectionCount += 1
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
    MenuStepperButton()
}
