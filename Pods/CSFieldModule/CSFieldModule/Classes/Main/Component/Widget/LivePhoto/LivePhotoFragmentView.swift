//
//  LivePhotoFragmentView.swift
//  Alamofire
//
//  Created by 于冬冬 on 2023/5/26.
//

import CSAccountManager
import Combine
import CSUtilities

class LivePhotoFragmentView: WidgetFragmentView {
    
    let pageWidth = Device.UI.screenWidth - 15 * 2 - 14 * 2
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: pageWidth, height: fragment.height - 34)
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(LivePhotoFragmentViewCell.self, forCellWithReuseIdentifier: LivePhotoFragmentViewCell.cellIdentifier)
        collectionView.register(LivePhotoFragmentViewCell.self, forCellWithReuseIdentifier: LivePhotoFragmentViewCell.cellIdentifier + "my")
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = .cs_cardColorB_40
        pageControl.currentPageIndicatorTintColor = .cs_pureWhite
        return pageControl
    }()
    
    
    var photos: [LivePhotoFragment.PhotoInfo] = []
    var livePhotoFragment: LivePhotoFragment {
        return fragment as! LivePhotoFragment
    }
    
    override func initialize() {
        addSubview(collectionView)
        addSubview(pageControl)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 14, bottom: 34, right: 14))
        }
        pageControl.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(34)
        }
        livePhotoFragment
            .updatePublisher
            .sink { [weak self] photos in
                self?.photos = photos
                self?.collectionView.reloadData()
                self?.pageControl.numberOfPages = photos.count
            }
            .store(in: &cancellableSet)
    }
    
}

extension LivePhotoFragmentView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photo = photos[indexPath.row]
        let isMine = photo.id == AccountManager.shared.id
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LivePhotoFragmentViewCell.cellIdentifier + (isMine ? "my" : ""), for: indexPath)
        (cell as? LivePhotoFragmentViewCell)?.update(photo: photo)
        (cell as? LivePhotoFragmentViewCell)?.fragment = livePhotoFragment
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / pageWidth)
        pageControl.currentPage = Int(pageIndex)
    }

}


