//
//  TimeDewFragmentView.swift
//  Alamofire
//
//  Created by 于冬冬 on 2023/3/21.
//

import UIKit
import CSImageKit
import CSNetwork
import CSFileKit
import SwiftyJSON
import CSUtilities

class TimeDewFragmentView: WidgetFragmentView, UITextViewDelegate {
    
    public var maxCharactersLimit = 100

    let imageView = UIImageView()
    let textView: TextView = {
        let textV = TextView()
        textV.textColor = .white
        textV.backgroundColor = UIColor(hex: 0x1b1b1b)
        textV.placeholder = "Please enter ..."
        return textV
    }()
    let button = Button()

    var timeDewFragment: TimeDewFragment {
        return fragment as! TimeDewFragment
    }
    override func initialize() {

        textView.delegate = self
        textView.layerCornerRadius = 14
        button.addTarget(self, action: #selector(generate), for: .touchUpInside)
        button.setTitle("Genetate", for: .normal)
        imageView.contentMode = .scaleAspectFill
        imageView.layerCornerRadius = 14
        imageView.backgroundColor = UIColor(hex: 0x1b1b1b)
//        imageView.image =
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedImage)))
        
        addSubview(textView)
        addSubview(button)
        addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(18)
            make.top.equalToSuperview()
            make.height.equalTo(300)
        }
        
        textView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(18)
            make.top.equalTo(imageView.snp.bottom).offset(35)
            make.height.equalTo(235)
        }
        
        button.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(35)
            make.height.equalTo(34)
            make.centerX.equalToSuperview()
        }
        
        timeDewFragment.$url.removeDuplicates().sink {[weak self] url in
            self?.imageView.setImage(with: url, placeholder: UIImage(systemName: "plus"))
        }.store(in: &cancellableSet)
        timeDewFragment.$url.map({ $0.isNilOrEmpty }).sink { [weak self] empty in
            let loading = self?.button.isLoading
            if  loading.unwrapped(or: false) {
                self?.button.isLoading = false
            }
            self?.button.isEnabled = empty
            self?.textView.isEditable = empty
            self?.imageView.isUserInteractionEnabled = empty
        }.store(in: &cancellableSet)
        timeDewFragment.$text.sink { [weak self] text in
            self?.textView.text = text
        }.store(in: &cancellableSet)
    }
    
    @objc func generate() {
        button.isLoading = true
        guard let text = textView.text,
              !text.isEmpty else {
            generateReport("text is empty")
            return
        }
        guard let image = imageView.image else {
            generateReport("image is empty")
            return
        }
        Task { [weak self] in
            do {
                let url = try await FileTask.saveImage(image:image)
                print(url)
                Network.request(FieldService.lifeSteam(text: text, file: url), type: TimeDewFragmentModel.self) { model in
                    if let json = model.toJSONString() {
                        self?.timeDewFragment.syncModel(json)
                        self?.button.isLoading = false
                    } else {
                        self?.generateReport("data error")
                    }
                } failure: { error in
                    self?.button.isLoading = false
                    HUD.showError(error.localizedDescription)
                }

                
            } catch {
                self?.generateReport(error.localizedDescription)
            }
          
        }
    }
    
    func generateReport(_ report: String) {
        HUD.showError(report)
        button.isLoading = false
    }
    
    @objc func selectedImage() {
        assembly.photoManager().showImagePicker(callback: { image in
            if let image = image {
                self.imageView.image = image
            }
        })
    }


    func textViewDidEndEditing(_ textView: UITextView) {
        if maxCharactersLimit > 0 {
            if let oriText = textView.text {
                if oriText.count > maxCharactersLimit {
                    let newText = oriText[..<oriText.index(oriText.startIndex, offsetBy: maxCharactersLimit)]
                    textView.text = String(newText)
                }
            }
        }
    }
}

