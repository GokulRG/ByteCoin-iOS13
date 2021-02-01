//
//  PriceData.swift
//  ByteCoin
//
//  Created by Gokul Rama on 2/1/21.
//  Copyright © 2021 The App Brewery. All rights reserved.
//

struct PriceData: Decodable {
    let rate: Double
    let asset_id_quote: String
}
