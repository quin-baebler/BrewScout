//
//  favoriteShops.swift
//  BrewScout
//
//  Created by Phillip Dang on 6/3/24.
//

import Foundation

import Foundation

class FavoriteShops {
    static let shared = FavoriteShops()
    var likedShopIDs: Set<String> = []

    private init() {}
}

let favoriteShops = FavoriteShops.shared
