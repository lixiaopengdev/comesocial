//
//  LifeFlowShareViewController.swift
//  CSLiveModule
//
//  Created by fuhao on 2023/6/3.
//

import UIKit
import Kingfisher
import Photos
import CSBaseView

class LifeFlowShareViewController: BaseViewController {
    let titleText: String
    let contentText: String
    let shareURL: String
    let userAvatarImageURL: String?
    var contentImageURL: String?
    
    
    var shareQRImage: UIImage?
    var contentImage: UIImage?
    var userAvatarImage: UIImage?
    
    var container: UIView!
    init(titleText: String, contentText: String, shareURL: String, photoImageURL: String?, contentImageURL: String? = nil) {
        self.titleText = titleText
        self.contentText = contentText
        self.shareURL = shareURL
        self.userAvatarImageURL = photoImageURL
        self.contentImageURL = contentImageURL
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        finishLoadAsset()
    }
    
    fileprivate func finishLoadAsset() {
        if loadAsset() {
            print("loadAsset true")
            DispatchQueue.main.async {
                self.loadShareView()
            }
        }
    }
    
    fileprivate func loadAsset() -> Bool {
        
        //请求分享图
        if let contentImageURL = contentImageURL,
           contentImageURL.isEmpty == false,
           contentImage == nil {
            KingfisherManager.shared.retrieveImage(with: URL(string: contentImageURL)!) { [weak self] (result: Result<RetrieveImageResult, KingfisherError>) in
                switch result {
                case .success(let value):
                    self?.contentImage = value.image
                    self?.finishLoadAsset()
                case .failure(let error):
                    DispatchQueue.main.async { [weak self] in
                        self?.showFailureView()
                    }
                }
            }
            return false
        }
        
        //请求头像
        if let userAvatarImageURL = userAvatarImageURL,
              userAvatarImageURL.isEmpty == false,
              userAvatarImage == nil {
            
            KingfisherManager.shared.retrieveImage(with: URL(string: userAvatarImageURL)!) { [weak self] (result: Result<RetrieveImageResult, KingfisherError>) in
                switch result {
                case .success(let value):
                    self?.userAvatarImage = value.image
                    self?.finishLoadAsset()
                case .failure(let error):
                    DispatchQueue.main.async { [weak self] in
                        self?.showFailureView()
                    }
                }
            }
            return false
        }
        
        if userAvatarImage == nil {
            let url = Bundle(for: LiveViewController.self).url(forResource: "CSLiveModule", withExtension: "bundle")!
            let localBundle = Bundle(url: url)
            userAvatarImage = UIImage(named: "Rectangle 346", in: localBundle, with: .none)
        }
        
        
        
        //TODO: 请求二维码
        if shareQRImage == nil {
            let url = Bundle(for: LiveViewController.self).url(forResource: "CSLiveModule", withExtension: "bundle")!
            let localBundle = Bundle(url: url)
            shareQRImage = UIImage(named: "Rectangle 346", in: localBundle, with: .none)
//            KingfisherManager.shared.retrieveImage(with: URL(string: photoImageURL)!) { [weak self] (result: Result<RetrieveImageResult, KingfisherError>) in
//               switch result {
//               case .success(let value):
//                   self?.shareQRImage = value.image
//                   self?.finishLoadAsset()
//               case .failure(let error):
//                   DispatchQueue.main.async { [weak self] in
//                       self?.showFailureView()
//                   }
//               }
//            }
        }
        

        
        
        return true
    }
    
    fileprivate func showFailureView() {
        
    }
    
    fileprivate func loadShareView() {
        print("loadShareView")
        guard let url = Bundle(for: LiveViewController.self).url(forResource: "CSLiveModule", withExtension: "bundle") else {
            return
        }
        let localBundle = Bundle(url: url)
        container = UIView()
        view.addSubview(container)
        
        container.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-(view.frame.size.height * 0.055))
            make.left.equalToSuperview().offset(60)
            make.right.equalToSuperview().offset(-60)
        }
        
        container.backgroundColor = .white
        container.layer.cornerRadius = 15
        container.layer.masksToBounds = true
        
        var anchorImageView: UIImageView!
        if let contentImage = contentImage {
            let contentImageView = UIImageView()
            
            
            contentImageView.contentMode = .scaleAspectFit
            anchorImageView = contentImageView
            
            container.addSubview(contentImageView)
            
            contentImageView.layer.cornerRadius = 15
            contentImageView.layer.masksToBounds = true
            let ratio = contentImage.size.height / contentImage.size.width
            contentImageView.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(8)
                make.top.equalToSuperview().offset(8)
                make.right.equalToSuperview().offset(-8)
                make.height.equalTo(contentImageView.snp.width).multipliedBy(ratio)
            }
            
            contentImageView.image = contentImage
            
            let photoImageView = UIImageView()
            container.addSubview(photoImageView)
            
            photoImageView.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(20)
                make.top.equalToSuperview().offset(23)
                make.width.height.equalTo(41)
            }
            
            photoImageView.image = shareQRImage
        }else {
            let shareQRImageView = UIImageView()
            container.addSubview(shareQRImageView)
            anchorImageView = shareQRImageView
            
            shareQRImageView.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(40)
                make.height.equalTo(shareQRImageView.snp.width)
                make.left.equalToSuperview().offset(60)
                make.right.equalToSuperview().offset(-60)
            }
            
            shareQRImageView.image = shareQRImage
        }
        
        
        //title
        let titleLabel = UILabel()
        container.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(anchorImageView.snp.bottom).offset(14)
            make.centerX.equalToSuperview()
        }
        
        titleLabel.textColor = UIColor(red: 0.063, green: 0.063, blue: 0.118, alpha: 1)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.92
        titleLabel.textAlignment = .center
        titleLabel.attributedText = NSMutableAttributedString(string: titleText, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])

        
        //text content
        let contentLabel = UILabel()
        container.addSubview(contentLabel)
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        contentLabel.textColor = UIColor(red: 0.384, green: 0.384, blue: 0.427, alpha: 1)
        contentLabel.font = UIFont.systemFont(ofSize: 12)
        contentLabel.numberOfLines = 0
        contentLabel.lineBreakMode = .byWordWrapping
        let paragraphStyle2 = NSMutableParagraphStyle()
        paragraphStyle2.lineHeightMultiple = 0.98
        paragraphStyle2.alignment = .center
        contentLabel.textAlignment = .center
        contentLabel.attributedText = NSMutableAttributedString(string: contentText, attributes: [NSAttributedString.Key.kern: 0.24, NSAttributedString.Key.paragraphStyle: paragraphStyle2])
        
        
        //foot zone
        let footZone = UIView()
        container.addSubview(footZone)
        footZone.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview().offset(-14)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
        }
        
        let userAvatarImageView = UIImageView()
        footZone.addSubview(userAvatarImageView)
        userAvatarImageView.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.height.equalTo(26)
        }
        userAvatarImageView.image = userAvatarImage
        userAvatarImageView.layer.cornerRadius = 10
        userAvatarImageView.layer.masksToBounds = true
        
        
        let copyRightLabel = UILabel()
        copyRightLabel.textColor = .cs_lightGrey
        copyRightLabel.font = .systemFont(ofSize: 8)
        copyRightLabel.textAlignment = .right
        copyRightLabel.text = "Content Generated by Come Social AI"
        footZone.addSubview(copyRightLabel)
        
        copyRightLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        
        
        let closeButton = UIButton()
        view.addSubview(closeButton)
        let downloadButton = UIButton()
        view.addSubview(downloadButton)
        
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(container.snp.bottom).offset(40)
            make.right.equalToSuperview().offset(-(Int(view.frame.size.width) >> 1 + 16))
            make.width.height.equalTo(60)
        }
        
        downloadButton.snp.makeConstraints { make in
            make.top.equalTo(container.snp.bottom).offset(40)
            make.left.equalTo(closeButton.snp.right).offset(32)
            make.width.height.equalTo(60)
        }
        

        closeButton.setImage(UIImage(named: "Frame 51657", in: localBundle, with: .none), for: .normal)
        downloadButton.setImage(UIImage(named: "Frame 51658", in: localBundle, with: .none), for: .normal)
        
        closeButton.addTarget(self, action: #selector(closeButtonClick), for: .touchUpInside)
        downloadButton.addTarget(self, action: #selector(downloadButtonClick), for: .touchUpInside)

    }
    
    @objc
    func closeButtonClick(button: UIButton?) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    func downloadButtonClick(button: UIButton) {
        saveViewToAlbum(view: container)
    }
    func applyRoundedCorners(to image: UIImage, cornerRadius: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        let bounds = CGRect(origin: .zero, size: image.size)
        UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).addClip()
        image.draw(in: bounds)
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return roundedImage
    }
    
    func applyAlphaToImage(_ image: UIImage, alpha: CGFloat, cornerRadius: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        let bounds = CGRect(origin: .zero, size: image.size)
        image.draw(in: bounds)

        let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        path.addClip()
        UIColor.clear.setFill()
        UIRectFillUsingBlendMode(bounds, .normal)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    

    func requestPhotoLibraryAuthorization(completion: @escaping (Bool) -> Void) {
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                completion(status == .authorized)
            }
        }
    }
    
    fileprivate func saveViewToAlbum(view: UIView) {

        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        view.layer.render(in: context)
        guard let screenshot = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return
        }
        UIGraphicsEndImageContext()
        
        guard let roundedImage = applyRoundedCorners(to: screenshot, cornerRadius: 20) else { return }
        guard let finalImage = applyAlphaToImage(roundedImage, alpha: 0, cornerRadius: view.layer.cornerRadius) else { return }

        
        
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                
                guard let imageData = finalImage.pngData() else {
                    // Handle the case when there's an error converting the image to PNG data
                    self.showToast(message: "Handle the case when there's an error converting the image to PNG data.")
                    return
                }

                PHPhotoLibrary.shared().performChanges({
                    let creationRequest = PHAssetCreationRequest.forAsset()
                    creationRequest.addResource(with: .photo, data: imageData, options: nil)
                }) { success, error in
                    DispatchQueue.main.async {
                        if success {
                            self.showToast(message: "content saved to album successfully.") { [weak self] in
                                self?.closeButtonClick(button: nil)
                            }
                        } else {
                            if let error = error {
                                self.showToast(message: "Error saving view content to album: \(error.localizedDescription)")
                            } else {
                                self.showToast(message: "Unknown error saving view content to album.")
                            }
                        }
                    }
                }

            } else {
                self.showToast(message: "Permission denied to access photo library.")
            }
        }
    }
    
    fileprivate func showToast(message: String, callBack: (()-> Void)? = nil) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 150, y: self.view.frame.size.height-100, width: 300, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = UIFont.systemFont(ofSize: 14)
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        
        self.view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 3.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { _ in
            toastLabel.removeFromSuperview()
            
            if let callBack = callBack {
                callBack()
            }
        })
    }
    


}
