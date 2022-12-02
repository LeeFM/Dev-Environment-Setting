//
//  CollectionViewEmbeddedTableViewCell.swift
//  TouchStock_MTK
//
//  Created by 金融研發一部-李鳳謀 on 2022/8/31.
//  Copyright © 2022 mitake. All rights reserved.
//

import UIKit

class CollectionViewEmbeddedTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    class Section {
        
        typealias CellConfigureHandler = ((_ item: Any, _ cell: UICollectionViewCell) -> ())
        typealias HeaderConfigureHandler = ((UICollectionReusableView) -> ())
        typealias MovableCheckHandler = ((_ movingItem: Any, _ sourceIndexPath: IndexPath, _ destinationIndexPath: IndexPath) -> Bool)
        typealias DidMoveHandler = ((_ sourceIndexPath: IndexPath, _ destinationIndexPath: IndexPath) -> ())
        typealias SizeHandler = ((_ indexPath: IndexPath) -> CGSize)
        
        var items: [Any]
        var cellClass: UICollectionViewCell.Type
        var cellNib: UINib?
        var cellConfigureHandler: CellConfigureHandler
        var headerConfigureHandler: HeaderConfigureHandler?
        var movableCheckHandler: MovableCheckHandler?
        var didMoveHandler: DidMoveHandler?
        var cellSizeHandler: SizeHandler
        var headerHeight: CGFloat
        
        var cellIdentifier: String {
            return String(describing: cellClass.self)
        }
        
        init(items: [Any],
             cellClass: UICollectionViewCell.Type,
             cellNib: UINib? = nil,
             cellConfigureHandler: @escaping CellConfigureHandler,
             headerConfigureHandler: HeaderConfigureHandler? = nil,
             movableCheckHandler: MovableCheckHandler? = nil,
             didMoveHandler: DidMoveHandler? = nil,
             cellSizeHandler: @escaping SizeHandler,
             headerHeight: CGFloat = 0) {
            
            self.items = items
            self.cellClass = cellClass
            self.cellNib = cellNib
            self.cellConfigureHandler = cellConfigureHandler
            self.headerConfigureHandler = headerConfigureHandler
            self.movableCheckHandler = movableCheckHandler
            self.didMoveHandler = didMoveHandler
            self.cellSizeHandler = cellSizeHandler
            self.headerHeight = headerHeight
        }
    }
    
    private var collectionViewSections = [Section]()
    
    private var collectionViewLeading: NSLayoutConstraint!
    private var collectionViewTop: NSLayoutConstraint!
    private var collectionViewTrailing: NSLayoutConstraint!
    private var collectionViewBottom: NSLayoutConstraint!
    
    private var movingItem: Any?
    private var longPressLocation: CGPoint = .zero
    private var longPressIndexPath: IndexPath?
    
    lazy var collectionView: UICollectionView = {
        
        let layout = CollectionViewLeadingFlowLayout()
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor(hexString: "#1a2125")
        cv.isScrollEnabled = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        
        cv.delegate = self
        cv.dataSource = self
        
        cv.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CollectionViewEmbeddedTableViewHeader")
        
        return cv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        baseUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        
        self.contentView.frame = self.bounds
        self.contentView.layoutIfNeeded()
        
        return collectionView.contentSize
    }
    
    private func baseUI() {
        
        contentView.backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(collectionView)
        
        collectionViewLeading = collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        collectionViewTop = collectionView.topAnchor.constraint(equalTo: contentView.topAnchor)
        collectionViewTrailing = collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        collectionViewBottom = collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        NSLayoutConstraint.activate([collectionViewLeading,
                                     collectionViewTop,
                                     collectionViewTrailing,
                                     collectionViewBottom])
    }
    
    func configureCell(collectionViewSections: [Section],
                       padding: CGFloat = 0,
                       cornerRadius: CGFloat = 0,
                       inset: UIEdgeInsets = .zero,
                       spacing: CGFloat = 0,
                       isDragable: Bool) {
        
        self.collectionViewSections = collectionViewSections
        
        collectionViewLeading.constant = padding
        collectionViewTrailing.constant = -padding
        
        collectionView.layer.cornerRadius = cornerRadius
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = inset
            layout.minimumLineSpacing = spacing
            layout.minimumInteritemSpacing = spacing
        }
        
        for s in collectionViewSections {
            if let nib = s.cellNib {
                collectionView.register(nib, forCellWithReuseIdentifier: s.cellIdentifier)
            } else {
                collectionView.register(s.cellClass, forCellWithReuseIdentifier: s.cellIdentifier)
            }
        }
        
        if isDragable {
            let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture(gesture:)))
            collectionView.addGestureRecognizer(longPressGesture)
        } else {
            collectionView.gestureRecognizers?.removeAll()
        }
        
        collectionView.reloadData()
    }
    
    @objc func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        
        longPressLocation = gesture.location(in: self.collectionView)
        longPressIndexPath = collectionView.indexPathForItem(at: longPressLocation)
        
        switch gesture.state {
        case .began:
            guard let selectedIndexPath = longPressIndexPath else {
                break
            }
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
            movingItem = collectionViewSections[selectedIndexPath.section].items[selectedIndexPath.row]
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(longPressLocation)
        case .ended:
            collectionView.endInteractiveMovement()
            movingItem = nil
        default:
            collectionView.cancelInteractiveMovement()
            movingItem = nil
        }
    }
    
    // MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return collectionViewSections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewSections[section].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let section = collectionViewSections[indexPath.section]
        let item = section.items[indexPath.row]
        let deqCell = collectionView.dequeueReusableCell(withReuseIdentifier: section.cellIdentifier, for: indexPath)
        
        section.cellConfigureHandler(item, deqCell)
        
        return deqCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let section = collectionViewSections[indexPath.section]
        
        return section.cellSizeHandler(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let section = collectionViewSections[indexPath.section]
        
        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CollectionViewEmbeddedTableViewHeader", for: indexPath)
        
        reusableView.subviews.forEach{ $0.removeFromSuperview() }
        
        section.headerConfigureHandler?(reusableView)
        
        return reusableView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let section = collectionViewSections[section]
        
        return .init(width: collectionView.width, height: section.headerHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let section = collectionViewSections[sourceIndexPath.section]
        
        section.didMoveHandler?(sourceIndexPath, destinationIndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveFromItemAt originalIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
        
        let section = collectionViewSections[originalIndexPath.section]
        
        var targetIndexPath = proposedIndexPath
        
        // The longPressIndexPath is nil, which means we are drag'n dropping on a new location (at the end of a section in most cases)
        if longPressIndexPath == nil {
            
            for sectionIndex in 0..<collectionView.numberOfSections {
                
                let rows = collectionView.numberOfItems(inSection: sectionIndex)
                let lastIndexPath = IndexPath(row: rows - 1, section: sectionIndex)
                
                // 如果位置在最後一個cell的右側，視同用戶想擺放到最後的位置
                if let lastCellFrame = collectionView.layoutAttributesForItem(at: lastIndexPath)?.frame,
                   longPressLocation.x > lastCellFrame.maxX,
                   (lastCellFrame.minY...lastCellFrame.maxY) ~= longPressLocation.y {
                    
                    if sectionIndex == originalIndexPath.section {
                        targetIndexPath = lastIndexPath
                    } else {
                        targetIndexPath = IndexPath(row: rows, section: sectionIndex)
                    }
                }
            }
        }
        
        if let movingItem = movingItem,
           let checker = section.movableCheckHandler,
           checker(movingItem, originalIndexPath, targetIndexPath) {
            
            return targetIndexPath
            
        } else {
            return originalIndexPath
        }
    }
}
