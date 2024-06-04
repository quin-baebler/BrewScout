//
//  favoriteShops.swift
//  BrewScout
//
//  Created by Phillip Dang on 6/3/24.
//
import Foundation

class FavoriteShops {
    static let shared = FavoriteShops()
    var list = [ShopListViewController.Place]()
    private init() {}
}
