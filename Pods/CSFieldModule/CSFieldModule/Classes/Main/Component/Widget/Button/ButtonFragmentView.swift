//
//  ButtonFragmentView.swift
//  CSFriendsModule
//
//  Created by 于冬冬 on 2023/3/3.
//

class ButtonFragmentView: WidgetFragmentView {

    let button = Button()
    var buttonFragment: ButtonFragment {
        return fragment as! ButtonFragment
    }
    override func initialize() {
        addSubview(button)
        
        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(34)
        }
        button.setTitle(buttonFragment.title, for: .normal)
        if buttonFragment.action != nil {
            button.addTarget(self, action: #selector(callJs), for: .touchUpInside)
        }
    }
    
    @objc func callJs() {
        buttonFragment.callAction()
    }
 
}
