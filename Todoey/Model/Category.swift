//
//  Category.swift
//  Todoey
//
//  Created by Shwetansh Srivastava on 09/01/20.
//  Copyright © 2020 Shwetansh Srivastava. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var color: String = ""
    let items = List<Item>()
}
