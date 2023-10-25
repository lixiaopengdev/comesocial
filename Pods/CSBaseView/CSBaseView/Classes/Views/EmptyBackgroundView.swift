//
//  EmptyBackgroundView.swift
//  CSBaseView
//
//  Created by 于冬冬 on 2023/6/1.
//

import Foundation
import CSUtilities

public enum EmptyStyle {
    case noContent(String)
    case error(String)
    case imageBreak(String)
    case lost(String)
    case noInternet(String)
    case wanring(String)
    case loading
}

public class EmptyBackgroundView: UIView {
    
    let emptyView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .cs_pureWhite
        label.font = .regularSubheadline
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(emptyView)
        addSubview(titleLabel)
        
        emptyView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(140)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 200, height: 136))
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(66)
            make.right.equalTo(-66)
            make.top.equalTo(emptyView.snp.bottom).offset(16)
        }
    }
    
    
   convenience public init(style: EmptyStyle) {
       self.init(frame: .zero)
       updateStyle(style)
    }
    
    
    func updateStyle(_ style: EmptyStyle) {
        emptyView.image = style.image
        titleLabel.text = style.title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EmptyStyle {
    
    var image: UIImage? {
        var name = ""
        switch self {
        case .noContent(_):
            name = "background_empty_no_content"
        case .error(_):
            name = "background_empty_error"
        case .imageBreak(_):
            name = "background_empty_image_break"
        case .lost(_):
            name = "background_empty_lost"
        case .noInternet(_):
            name = "background_empty_no_internet"
        case .wanring(_):
            name = "background_empty_wanring"
        case .loading:
            return nil
        }
        return UIImage.bundleImage(named: name)
    }
    
    var title: String {
        switch self {
        case .noContent(let string):
            return string
        case .error(let string):
            return string
        case .imageBreak(let string):
            return string
        case .lost(let string):
            return string
        case .noInternet(let string):
            return string
        case .wanring(let string):
            return string
        case .loading:
            return "Loading..."
        }
    }
}
