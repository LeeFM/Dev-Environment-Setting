//
//  PopoverTemplateViewController.swift
//  TouchStock_MTK
//
//  Created by 金融研發一部-李鳳謀 on 2021/9/13.
//  Copyright © 2021 mitake. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

struct PopoverSetting {
    let width: CGFloat
    let cellHeight: CGFloat
    let anchorPoint: CGPoint
    let direction: UIPopoverArrowDirection
    let spacing: CGFloat
    let cornerRadius: CGFloat
    
    init(width: CGFloat,
         cellHeight: CGFloat,
         anchorPoint: CGPoint = .zero,
         direction: UIPopoverArrowDirection = .down,
         spacing: CGFloat = 8,
         cornerRadius: CGFloat = 0) {
        
        self.width = width
        self.cellHeight = cellHeight
        self.anchorPoint = anchorPoint
        self.direction = direction
        self.spacing = spacing
        self.cornerRadius = cornerRadius
    }
}

class PopoverTemplateViewController<I, C: UITableViewCell>: UIViewController, UITableViewDelegate {
    
    typealias CellConfigureHandler = ((Int, I, C) -> ())
    typealias CellSelectHandler = ((I, C) -> ())
    typealias DismissHandler = (() -> ())
    
    private let kReuseIdentifier = "PopoverTemplateViewControllerCell"
    
    private var items = [I]()
    private var registerCellClass: C.Type
    private var cellNib: UINib?
    private var cellConfigureHandler: CellConfigureHandler
    private var cellSelectHandler: CellSelectHandler
    private var dismissHandler: DismissHandler?
    private var sourceView: UIView
    private weak var sourceViewController: UIViewController?
    private var setting: PopoverSetting
    
    private let bag = DisposeBag()
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.showsVerticalScrollIndicator = false
        tv.showsHorizontalScrollIndicator = false
        tv.isScrollEnabled = false
        tv.backgroundColor = .clear
        
        return tv
    }()
    
    private lazy var transparentAreaView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var tableViewContentHeight: CGFloat {
        return CGFloat(items.count) * setting.cellHeight
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        baseUI()
        customize(for: tableView)
        bind()
    }
    
    init(items: [I],
         registerCellClass: C.Type,
         cellNib: UINib?,
         cellConfigureHandler: @escaping CellConfigureHandler,
         cellSelectHandler: @escaping CellSelectHandler,
         dismissHandler: DismissHandler? = nil,
         sourceView: UIView,
         sourceViewController: UIViewController,
         setting: PopoverSetting) {
        
        self.items = items
        self.registerCellClass = registerCellClass
        self.cellNib = cellNib
        self.cellConfigureHandler = cellConfigureHandler
        self.cellSelectHandler = cellSelectHandler
        self.dismissHandler = dismissHandler
        self.sourceView = sourceView
        self.sourceViewController = sourceViewController
        self.setting = setting
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func baseUI() {
        view.backgroundColor = .clear
        
        view.addSubview(transparentAreaView)
        
        NSLayoutConstraint.activate([transparentAreaView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     transparentAreaView.topAnchor.constraint(equalTo: view.topAnchor),
                                     transparentAreaView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     transparentAreaView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
        
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(didTapTransparentArea))
        tapGes.numberOfTouchesRequired = 1
        
        transparentAreaView.addGestureRecognizer(tapGes)
        
        view.addSubview(tableView)
        
        if let nib = cellNib {
            tableView.register(nib, forCellReuseIdentifier: kReuseIdentifier)
        } else {
            tableView.register(registerCellClass, forCellReuseIdentifier: kReuseIdentifier)
        }
    }
    
    private func bind() {
        tableView.rx.setDelegate(self)
            .disposed(by: bag)
        
        Observable.just(items)
            .bind(to: tableView.rx.items(cellIdentifier: kReuseIdentifier, cellType: C.self)) { [weak self] row, item, cell in
                self?.cellConfigureHandler(row, item, cell)
            }
            .disposed(by: bag)
    }
    
    private func hide() {
        dismissHandler?()
        
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    
    @objc func didTapTransparentArea() {
        hide()
    }
    
    // MARK: - Public func
    func customize(for tableView: UITableView) {
        
    }
    
    func show() {
        guard let parent = sourceViewController else { return }
        
        view.frame = parent.view.bounds
        transparentAreaView.frame = parent.view.bounds
        
        // 預設以sourceView最左上角算出來的座標
        let sourceViewPointOnParentView = sourceView.convert(setting.anchorPoint, to: parent.view)
        
        var x = sourceViewPointOnParentView.x
        var y = sourceViewPointOnParentView.y
        let width = setting.width
        let height = self.tableViewContentHeight
        
        switch setting.direction {
        case .up:
            let adjustedY = y - height - setting.spacing
            y = adjustedY
            break
        case .left:
            let adjustedX = x - width - setting.spacing
            x = adjustedX
            break
        case .down:
            let adjustedY = y + sourceView.height + setting.spacing
            y = adjustedY
            break
        case .right:
            let adjustedX = x + sourceView.width + setting.spacing
            x = adjustedX
            break
        default:
            break
        }
        
        // 檢查是否超出邊界
        /// 左
        x = max(x, parent.view.bounds.minX)
        /// 右
        if x + width > parent.view.bounds.maxX {
            x = parent.view.bounds.maxX - width
        }
        /// 上
        if setting.direction == .up {
            y = max(y, parent.view.bounds.minY)
        }
        /// 下
        if setting.direction == .down, (y + height) > parent.view.bounds.maxY {
            y = parent.view.bounds.maxY - height
        }
        
        tableView.frame = CGRect(x: x, y: y, width: width, height: height)
        tableView.layer.cornerRadius = setting.cornerRadius
        
        parent.addChild(self)
        parent.view.addSubview(self.view)
        self.didMove(toParent: parent)
    }
    
    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? C {
            let item = items[indexPath.row]
            
            self.cellSelectHandler(item, cell)
            
            hide()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return setting.cellHeight
    }
}
