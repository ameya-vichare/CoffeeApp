//
//  CoffeeCellView.swift
//  CoffeeModule
//
//  Created by Ameya on 13/09/25.
//

import SwiftUI
import AppModels
import DesignSystem

struct CoffeeCellView: View {
    private let viewModel: CoffeeCellViewModel
    
    init(viewModel: CoffeeCellViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: AppPointSystem.point_20)
                .foregroundStyle(AppColors.white)
            
            VStack {
                OrderHeaderView(viewModel: viewModel)
                
                OrderDetailView(viewModel: viewModel)
                
                Divider()
                    .background(AppColors.secondaryGray)
                    .padding([.top, .bottom], AppPointSystem.point_12)
                
                OrderUserNameView(viewModel: viewModel)
                
                OrderStatusView(viewModel: viewModel)
            }
            .padding([.bottom, .top], AppPointSystem.point_12)
            .padding([.leading, .trailing], AppPointSystem.point_16)
        }
        
        
    }
}

struct OrderHeaderView: View {
    private let viewModel: CoffeeCellViewModel
    
    init(viewModel: CoffeeCellViewModel) {
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
    private let viewModel: CoffeeCellViewModel
    
    init(viewModel: CoffeeCellViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        HStack {
            AsyncImage(url: viewModel.coffeeImageURL) { image in
                image
                    .resizable()
                    .frame(width: AppPointSystem.point_48, height: AppPointSystem.point_48)
                    .clipShape(RoundedRectangle(cornerRadius: AppPointSystem.point_12))
            } placeholder: {}
                .padding([.trailing], AppPointSystem.point_4)
            
            VStack(alignment: .leading) {
                Text("\(viewModel.coffeeType)")
                    .font(AppFonts.headlineMedium)
                
                Text("\(viewModel.coffeeSize)")
                    .font(AppFonts.captionMedium)
                    .foregroundStyle(AppColors.primaryGray)
            }
            
            
            Spacer()
            
            Text("x1")
                .font(AppFonts.subHeadline)
                .foregroundStyle(AppColors.primaryGray)
                .padding([.trailing], AppPointSystem.point_40)
            
            Text("$12")
                .font(AppFonts.subHeadlineMedium)
        }
    }
}

struct OrderUserNameView: View {
    private let viewModel: CoffeeCellViewModel
    
    init(viewModel: CoffeeCellViewModel) {
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
    private let viewModel: CoffeeCellViewModel
    
    init(viewModel: CoffeeCellViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: AppPointSystem.point_60/2)
                .frame(height: AppPointSystem.point_60)
                .foregroundStyle(AppColors.secondaryGray)
            
            HStack {
                Image(systemName: "cup.and.saucer")
                
                Text("\(viewModel.coffeeStatus)")
            }
        }
    }
}

#Preview {
    CoffeeCellView(viewModel:
        CoffeeCellViewModel(
            id: 123,
            userName: "Jason",
            coffeeType: "Capuccino",
            coffeeSize: "Large",
            coffeeExtras: "Blah",
            coffeeStatus: "Preparing",
            coffeeImageURL: CoffeeType.cappuccino.imageURL,
            createdAt: "2025-09-13T09:13:15.732796+00:00"
        )
    )
}
