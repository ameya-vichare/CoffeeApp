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
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(AppColors.white)
            
            VStack {
                OrderHeaderView(viewModel: viewModel)
                
                OrderDetailView(viewModel: viewModel)
                
                Divider()
                    .background(AppColors.secondaryGray)
                    .padding([.top, .bottom], 12)
                
                OrderUserNameView(viewModel: viewModel)
                
                OrderStatusView(viewModel: viewModel)
            }
            .padding([.bottom, .top], 12)
            .padding([.leading, .trailing], 16)
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
                    .padding([.bottom], 2)
                Text("\(viewModel.createdAt)")
                    .font(AppFonts.subHeadline)
                    .foregroundStyle(AppColors.primaryGray)
            }
            
            Spacer()
            
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(AppColors.secondaryGray)
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: "message.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(AppColors.secondaryGray)
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: "chevron.right")
                }
            }
        }
        .padding([.bottom], 12)
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
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } placeholder: {}
                .padding([.trailing], 4)
            
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
                .padding([.trailing], 40)
            
            Text("$12")
                .font(AppFonts.subHeadline)
                .fontWeight(.medium)
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
        .padding([.bottom], 12)
    }
}

struct OrderStatusView: View {
    private let viewModel: CoffeeCellViewModel
    
    init(viewModel: CoffeeCellViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .frame(height: 60)
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
