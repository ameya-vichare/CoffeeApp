//
//  BrewCrewAddMenuButton.swift
//  CoffeeModule
//
//  Created by Ameya on 23/10/25.
//


import SwiftUI
import DesignSystem
import ImageLoading

struct BrewCrewAddMenuView: View {
    @ObservedObject var viewModel: MenuCellViewModel
    
    init(viewModel: MenuCellViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        handleStateChange()
    }
    
    @ViewBuilder
    private func handleStateChange() -> some View {
        if viewModel.quantitySelection == 0 {
            BrewCrewAddMenuButton(
                selectionCount: $viewModel.quantitySelection,
                viewModel: viewModel
            )
        } else {
            BrewCrewMenuStepperButton(selectionCount: $viewModel.quantitySelection)
        }
    }
}

struct BrewCrewAddMenuButton: View {
    @Binding var selectionCount: Int
    @State private var showSheet = false
    @State private var heightFraction: PresentationDetent = .fraction(0.3)
    private var viewModel: MenuCellViewModel
    
    init(selectionCount: Binding<Int>, viewModel: MenuCellViewModel) {
        self._selectionCount = selectionCount
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
                BrewCrewMenuModifierBottomSheet(
                    viewModel: viewModel.bottomSheetModel
                )
            }
            .presentationCornerRadius(AppPointSystem.point_20)
            .presentationDragIndicator(.visible)
            .presentationDetents([.fraction(0.5),.large])
        }
    }
}

struct BrewCrewMenuStepperButton: View {
    @Binding var selectionCount: Int
    @State private var isIncrementing: Bool = false
    
    var body: some View {
        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: AppPointSystem.point_12)
                .frame(
                    width: AppPointSystem.point_120,
                    height: AppPointSystem.point_44
                )
                .foregroundStyle(AppColors.primaryCoffee)
            
            HStack(spacing: 0) {
                Button {
                    isIncrementing = false
                    selectionCount = max(0, selectionCount - 1)
                } label: {
                    Image(systemName: "minus")
                        .frame(width: AppPointSystem.point_40, height: AppPointSystem.point_40)
                        .foregroundStyle(AppColors.white)
                }
                .buttonStyle(.plain)
                .contentShape(Rectangle())
                
                ZStack {
                    Text("\(selectionCount)")
                        .font(AppFonts.headline)
                        .foregroundStyle(AppColors.white)
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
                        .foregroundStyle(AppColors.white)
                }
                .buttonStyle(.plain)
                .contentShape(Rectangle())
            }
        }
        .offset(y: AppPointSystem.point_44/2)
    }
}

//#Preview {
//    BrewCrewAddMenuView(
//        viewModel: MenuCellViewModel(
//            name: "",
//            currency: "",
//            price: 0.0,
//            description: "",
//            imageURL: ""
//        )
//    )
//}
