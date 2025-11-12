//
//  MenuModifierBottomSheetViewModel.swift
//  CoffeeModule
//
//  Created by Ameya on 27/10/25.
//

import Foundation
import AppModels
import Combine

protocol MenuModifierBottomSheetViewModelOutput {
    var shouldDismissBottomSheet: Bool { get }
}

typealias MenuModifierBottomSheetViewModel = MenuModifierBottomSheetViewModelOutput

@MainActor
final class DefaultMenuModifierBottomSheetViewModel: ObservableObject, MenuModifierBottomSheetViewModel {
    let id: Int
    let currency: String
    let name: String
    let imageURL: URL?
    let orderItemUpdates: PassthroughSubject<CreateOrderItem, Never>
    
    let priceComputeUseCase: MenuModifierBottomSheetPriceComputeUsecaseProtocol
    let createOrderUseCase: MenuModifierBottomSheetCreateOrderUseCaseProtocol
    
    let modifierViewModels: [MenuModifierCategoryCellViewModel]
    let footerViewModel: DefaultMenuModifierBottomSheetFooterViewModel
    let headerViewModel: MenuModifierBottomSheetHeaderViewModel
    
    private var totalPrice: Double = 0.0
    private var quantitySelection: Int = 1
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Output
    @Published var shouldDismissBottomSheet: Bool = false
    
    // MARK: - Init
    init(
        modifiers: [MenuModifier],
        id: Int,
        currency: String,
        name: String,
        imageURL: URL?,
        orderItemUpdates: PassthroughSubject<CreateOrderItem, Never>,
        priceComputeUseCase: MenuModifierBottomSheetPriceComputeUsecaseProtocol,
        createOrderUseCase: MenuModifierBottomSheetCreateOrderUseCaseProtocol
    ) {
        self.currency = currency
        self.id = id
        self.name = name
        self.imageURL = imageURL
        self.orderItemUpdates = orderItemUpdates
        self.priceComputeUseCase = priceComputeUseCase
        self.createOrderUseCase = createOrderUseCase
        
        let menuModifierViewModels: [MenuModifierCategoryCellViewModel] = modifiers.compactMap { (menuModifier) -> MenuModifierCategoryCellViewModel? in
            guard let options = menuModifier.options else { return nil }

            let menuModifierCellViewModels: [DefaultMenuModifierSelectionCellViewModel] = options.map {
                DefaultMenuModifierSelectionCellViewModel(
                    option: $0,
                    minimumSelection: menuModifier.minSelect ?? 0,
                    selectionPolicyUseCase: MenuModifierSelectionPolicyUseCase()
                )
            }

            return MenuModifierCategoryCellViewModel(
                menuModifier: menuModifier,
                options: menuModifierCellViewModels,
                deselectionUseCase: MenuModifierDeselectionUseCase()
            )
        }
        
        self.modifierViewModels = menuModifierViewModels
        self.footerViewModel = .init(currency: currency)
        self.headerViewModel = .init(name: name, imageURL: imageURL)
        
        self.bindChildren()
        self.computeTotalPrice()
    }
}

// MARK: - Bindings
extension DefaultMenuModifierBottomSheetViewModel {
    private func bindChildren() {
        let merged = Publishers.MergeMany(self.modifierViewModels.map { $0.priceComputePublisher})

        merged
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.computeTotalPrice()
            }
            .store(in: &cancellables)
        
        footerViewModel.$quantitySelection
            .receive(on: DispatchQueue.main)
            .sink { [weak self] quantity in
                self?.quantitySelection = quantity
                self?.computeTotalPrice()
            }
            .store(in: &cancellables)
        
        footerViewModel.addItemPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.createOrderItem()
            }
            .store(in: &cancellables)
    }
}

// MARK: - Use case execution
extension DefaultMenuModifierBottomSheetViewModel {
    private func computeTotalPrice() {
        self.totalPrice = self.priceComputeUseCase
            .getTotalPrice(
                selectedItemViewModels: getSelectedItemViewModels(),
                quantitySelection: quantitySelection
            )
        
        self.footerViewModel.setTotalPrice(price: self.totalPrice)
    }
    
    private func createOrderItem() {
        let createOrderItem = self.createOrderUseCase
            .buildCreateOrderItem(
                selectedItemViewModels: getSelectedItemViewModels(),
                id: id,
                quantitySelection: quantitySelection
            )
        
        self.orderItemUpdates.send(createOrderItem)
        self.shouldDismissBottomSheet = true
    }
    
    private func getSelectedItemViewModels() -> [DefaultMenuModifierSelectionCellViewModel] {
        self.modifierViewModels.flatMap { $0.options }
            .filter { $0.isSelected }
    }
}
