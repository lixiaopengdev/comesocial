//
//  CSSearchBsr.swift
//  CSUtilities
//
//  Created by 于冬冬 on 2023/5/11.
//

import UIKit

public class CSSearchBar: UISearchBar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundImage = UIImage()
        
        searchTextField.backgroundColor = .clear
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Search").font(.regularSubheadline).foregroundColor(.cs_lightGrey)
        searchTextField.textColor = .cs_softWhite
        searchTextField.font = .regularSubheadline
        
        setSearchFieldBackgroundImage(UIImage.bundleImage(named: "search_background"), for: .normal)
        setImage(UIImage.bundleImage(named: "search_close_light"), for: .clear, state: .normal)
        setImage(UIImage.bundleImage(named: "button_icon_search"), for: .search, state: .normal)
        
        searchTextPositionAdjustment = UIOffset(horizontal: 5, vertical: 0)
        setPositionAdjustment(UIOffset(horizontal: 5, vertical: 0), for: .clear)

    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
