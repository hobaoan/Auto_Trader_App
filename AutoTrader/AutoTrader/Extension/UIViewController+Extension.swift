//
//  UIViewController+Extension.swift
//  AutoTrader
//
//  Created by An Bảo on 04/07/2024.
//

import Foundation
import UIKit

extension UIViewController {
    func customizeSearchController(searchController: UISearchController) {
        if let searchBarTextField = searchController.searchBar.value(forKey: "searchField") as? UITextField {            searchBarTextField.backgroundColor = .gray
            searchBarTextField.textColor = .opaqueSeparator
            searchBarTextField.tintColor = .opaqueSeparator
            if let searchIcon = searchBarTextField.leftView as? UIImageView {
                searchIcon.image = searchIcon.image?.withRenderingMode(.alwaysTemplate)
                searchIcon.tintColor = .opaqueSeparator
            }
        }
        searchController.searchBar.backgroundColor = .black
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .black
    }
}
