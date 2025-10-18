//
//  CoffeeCellView.swift
//  CoffeeModule
//
//  Created by Ameya on 13/09/25.
//

import SwiftUI
import AppModels
import DesignSystem
import ImageLoading

struct CoffeeCellView: View {
    private var viewModel: OrderCellViewModel
    
    init(
        viewModel: OrderCellViewModel
    ) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: AppPointSystem.point_20)
                .foregroundStyle(AppColors.white)
            
            VStack {
                OrderHeaderView(viewModel: viewModel)

                LazyVStack {
                    ForEach(self.viewModel.items, id: \.id) { item in
                        OrderDetailView(viewModel: item)
                    }
                }

                Divider()
                    .background(AppColors.secondaryGray)
                    .padding([.top, .bottom], AppPointSystem.point_12)
                
                OrderTotalPriceView(viewModel: viewModel)
                
                OrderUserNameView(viewModel: viewModel)
                
                OrderStatusView(viewModel: viewModel)
            }
            .padding([.bottom, .top], AppPointSystem.point_12)
            .padding([.leading, .trailing], AppPointSystem.point_16)
        }
    }
}

struct OrderHeaderView: View {
    private let viewModel: OrderCellViewModel
    
    init(viewModel: OrderCellViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Order #\(viewModel.id)")
                    .font(AppFonts.title2SemiBold)
                    .padding([.bottom], AppPointSystem.point_2)
                Text("\(viewModel.createdAt)")
                    .font(AppFonts.subHeadline)
                    .foregroundStyle(AppColors.primaryGray)
            }
            
            Spacer()
            
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: AppPointSystem.point_12)
                        .foregroundStyle(AppColors.secondaryGray)
                        .frame(width: AppPointSystem.point_40, height: AppPointSystem.point_40)
                    
                    Image(systemName: "message.fill")
                        .resizable()
                        .frame(width: AppPointSystem.point_20, height: AppPointSystem.point_20)
                }
                
                ZStack {
                    RoundedRectangle(cornerRadius: AppPointSystem.point_12)
                        .foregroundStyle(AppColors.secondaryGray)
                        .frame(width: AppPointSystem.point_40, height: AppPointSystem.point_40)
                    
                    Image(systemName: "chevron.right")
                }
            }
        }
        .padding([.bottom], AppPointSystem.point_12)
    }
}

struct OrderDetailView: View {
    private let viewModel: OrderItemCellViewModel
    @Environment(\.imageService) var imageService: ImageService
    
    init(viewModel: OrderItemCellViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        HStack {
            CustomImageView(
                url: viewModel.imageURL,
                targetSize: CGSize(
                    width: AppPointSystem.point_48,
                    height: AppPointSystem.point_48
                ),
                imageService: imageService
            ) {
                ProgressView()
            }
            .frame(width: AppPointSystem.point_48, height: AppPointSystem.point_48)
            .clipShape(RoundedRectangle(cornerRadius: AppPointSystem.point_12))
            
            VStack(alignment: .leading) {
                Text(viewModel.name)
                    .font(AppFonts.headlineMedium)
                
                Text(viewModel.customisation)
                    .font(AppFonts.captionMedium)
                    .foregroundStyle(AppColors.primaryGray)
            }
            
            
            Spacer()
            
            Text(viewModel.displayQuantityLabel)
                .font(AppFonts.subHeadline)
                .foregroundStyle(AppColors.primaryGray)
                .padding([.trailing], AppPointSystem.point_40)
            
            Text(viewModel.displayPriceLabel)
                .font(AppFonts.subHeadline)
        }
    }
}

struct OrderTotalPriceView: View {
    private let viewModel: OrderCellViewModel
    
    init(viewModel: OrderCellViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        HStack {
            Text("Total:")
                .font(AppFonts.subHeadlineMedium)
            
            Spacer()
            
            Text(viewModel.displayTotalPriceLabel)
                .font(AppFonts.subHeadlineMedium)
        }
        .padding([.bottom], AppPointSystem.point_4)
    }
}

struct OrderUserNameView: View {
    private let viewModel: OrderCellViewModel
    
    init(viewModel: OrderCellViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        HStack {
            Text("Ordered by:")
                .font(AppFonts.subHeadline)
                .foregroundStyle(AppColors.primaryGray)
            
            Text("\(viewModel.userName)")
                .font(AppFonts.subHeadline)
            
            Spacer()
        }
        .padding([.bottom], AppPointSystem.point_12)
    }
}

struct OrderStatusView: View {
    private let viewModel: OrderCellViewModel
    
    init(viewModel: OrderCellViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: AppPointSystem.point_60/2)
                .frame(height: AppPointSystem.point_60)
                .foregroundStyle(AppColors.secondaryGray)
            
            HStack {
                Image(systemName: "cup.and.saucer")
                
                Text(viewModel.statusDisplayLabel)
            }
        }
    }
}

#Preview {
    CoffeeCellView(viewModel:
        OrderCellViewModel(
            id: "2",
            userName: "John Doe",
            createdAt: "2025-10-11T17:04:19.881007+00:00",
            totalPrice: "10",
            currency: "USD",
            status: "Pending",
            items: [
                OrderItemCellViewModel(
                    name: "Latte",
                    size: "Small",
                    modifiers: ["Oat Milk", "Caramel"],
                    imageURL: "https://images.unsplash.com/photo-1669872484166-e11b9638b50e",
                    totalPrice: "5",
                    currency: "USD",
                    quantity: "1"
                )
            ]
        )
    )
}
