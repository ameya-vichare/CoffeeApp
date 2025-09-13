//
//  CoffeeCellView.swift
//  CoffeeModule
//
//  Created by Ameya on 13/09/25.
//

import SwiftUI
import AppModels

struct CoffeeCellView: View {
    private let viewModel: CoffeeCellViewModel
    
    init(viewModel: CoffeeCellViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(Color(.white))
            
            VStack {
                OrderHeaderView(viewModel: viewModel)
                
                OrderDetailView(viewModel: viewModel)
                
                Divider()
                    .background(Color(.systemGray6))
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
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding([.bottom], 2)
                Text("\(viewModel.createdAt)")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
            
            Spacer()
            
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(Color(.systemGray6))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: "message.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(Color(.systemGray6))
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
                    .font(.headline)
                    .fontWeight(.medium)
                
                Text("\(viewModel.coffeeSize)")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(Color(.gray))
            }
            
            
            Spacer()
            
            Text("x1")
                .font(.subheadline)
                .foregroundStyle(Color(.gray))
                .padding([.trailing], 40)
            
            Text("$12")
                .font(.subheadline)
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
                .font(.subheadline)
                .foregroundStyle(.gray)
            
            Text("\(viewModel.userName)")
                .font(.subheadline)
            
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
                .foregroundStyle(Color(.systemGray6))
            
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
