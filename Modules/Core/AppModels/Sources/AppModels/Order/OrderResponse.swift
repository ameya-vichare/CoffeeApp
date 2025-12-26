//
//  OrderResponse.swift
//  AppModels
//
//  Created by Ameya on 26/12/25.
//

public struct OrderResponse: Decodable {
    public let orders: [Order]?
    public let pagination: OrderPagination?
    
    enum CodingKeys: String, CodingKey {
        case orders = "data"
        case pagination
    }
    
    public init(orders: [Order], pagination: OrderPagination) {
        self.orders = orders
        self.pagination = pagination
    }
}

public struct OrderPagination: Decodable {
    public let limit: Int?
    public let nextCursor: String?
    public let hasMore: Bool?
    
    enum CodingKeys: String, CodingKey {
        case limit
        case nextCursor = "next_cursor"
        case hasMore = "has_more"
    }
    
    public init(limit: Int, nextCursor: String?, hasMore: Bool) {
        self.limit = limit
        self.nextCursor = nextCursor
        self.hasMore = hasMore
    }
}
