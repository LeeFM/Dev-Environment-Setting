//
//  MFSearchCell.swift
//  TouchStock_MTK
//
//  Created by 金融研發一部-李鳳謀 on 2022/7/21.
//  Copyright © 2022 mitake. All rights reserved.
//

import UIKit

class MFSearchInnerView: UIView {
    
    private lazy var cycle: UILabel = {
        let l = UILabel()
        l.font = UIFont.dynamicFont(ofSize: 11)
        l.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6)
        l.textAlignment = .left
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private lazy var rankInfo: UILabel = {
        let l = UILabel()
        l.font = UIFont.dynamicFont(ofSize: 11)
        l.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.6)
        l.textAlignment = .left
        l.numberOfLines = 2
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private lazy var separator: UIView = {
        let v = UIView()
        v.backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.1294117647, blue: 0.1450980392, alpha: 1)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private var cycleMapper = [0: "・當沖",
                               1: "・隔日沖",
                               2: "・1天",
                               3: "・1周",
                               4: "・1月",
                               5: "・1季"]
    
    convenience init(cycleInfo: BranchesCycleInfo, isLast: Bool) {
        self.init(frame: .zero)
        
        backgroundColor = .clear
        
        addSubview(cycle)
        addSubview(rankInfo)
        addSubview(separator)
        
        NSLayoutConstraint.activate([cycle.leadingAnchor.constraint(equalTo: leadingAnchor),
                                     cycle.topAnchor.constraint(equalTo: topAnchor, constant: MIUIScaledSize(4)),
                                     cycle.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 66/300),
                                     separator.heightAnchor.constraint(equalToConstant: 1),
                                     separator.leadingAnchor.constraint(equalTo: leadingAnchor),
                                     separator.trailingAnchor.constraint(equalTo: trailingAnchor),
                                     separator.bottomAnchor.constraint(equalTo: bottomAnchor),
                                     rankInfo.topAnchor.constraint(equalTo: topAnchor, constant: MIUIScaledSize(4)),
                                     rankInfo.leadingAnchor.constraint(equalTo: cycle.trailingAnchor),
                                     rankInfo.trailingAnchor.constraint(equalTo: trailingAnchor),
                                     rankInfo.bottomAnchor.constraint(equalTo: separator.topAnchor, constant: MIUIScaledSize(-4))])
        
        cycle.text = cycleMapper[cycleInfo.tradeCycle.intValue]
        
        var msg = ""
        for (index, text) in cycleInfo.info.enumerated() {
            msg += text
            
            if index == cycleInfo.info.count - 1 {
                break
            }
            
            if index % 2 == 0 {
                msg += "、"
            } else {
                msg += "\n"
            }
        }
        
        rankInfo.text = msg
        separator.isHidden = isLast
    }
}

class MFSearchCell: UITableViewCell {
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var branchName: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var expandButton: UIButton!
    @IBOutlet weak var expandTouchArea: UIView!
    
    @IBOutlet weak var addButtonTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var stackViewTopAnchor: NSLayoutConstraint!
    @IBOutlet weak var stackViewBottomAnchor: NSLayoutConstraint!
    @IBOutlet weak var expandButtonHeightAnchor: NSLayoutConstraint!
    @IBOutlet weak var expandButtonBottomAnchor: NSLayoutConstraint!
    
    private var branch: BrokerBranches!
    private var isAdded = false
    private var routeHandler: ((BrokerBranches) -> ())?
    private var addHandler: ((BrokerBranches) -> ())?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        baseUI()
    }
    
    private func baseUI() {
        branchName.font = UIFont.dynamicFont(ofSize: 15)
        
        addButtonTopAnchor.constant = MIUIScaledSize(10)
        
        stackViewTopAnchor.constant = MIUIScaledSize(33)
        
        selectionStyle = .none
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(expandTouchAreaTapped))
        tap.numberOfTouchesRequired = 1
        expandTouchArea.addGestureRecognizer(tap)
    }
    
    func configureCell(branch: BrokerBranches,
                       isAdded: Bool, isExpanded: Bool,
                       routeHandler: ((BrokerBranches) -> ())?,
                       addHandler: ((BrokerBranches) -> ())?) {
        
        self.branch = branch
        self.isAdded = isAdded
        self.routeHandler = routeHandler
        self.addHandler = addHandler
        
        branchName.text = branch.branchesName
        
        let buttonImage = isAdded ? UIImage(named: "MitakeStock.bundle/images/bk_icon_round_check_20_n.png") : UIImage(named: "bk_icon_add_20_n.png")
        addButton.setImage(buttonImage, for: .normal)
        
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let infoToDisplay = isExpanded ? branch.cycleinfo ?? [] : Array(branch.cycleinfo.prefix(2))
        
        for (index, info) in infoToDisplay.enumerated() {
            let innerView = MFSearchInnerView(cycleInfo: info, isLast: index == infoToDisplay.count - 1)
            stackView.addArrangedSubview(innerView)
        }
        
        let expandArrow = isExpanded ? UIImage(named: "bk_icon_arrow_up_solid_7_p.png") : UIImage(named: "bk_icon_arrow_down_solid_7_n.png")
        expandButton.setImage(expandArrow, for: .normal)
        
        if branch.cycleinfo.count <= 2 {
            expandButton.isHidden = true
            stackViewBottomAnchor.constant = 0
            expandButtonHeightAnchor.constant = 0
            expandButtonBottomAnchor.constant = 0
        } else {
            expandButton.isHidden = false
            stackViewBottomAnchor.constant = 8
            expandButtonHeightAnchor.constant = MIUIScaledSize(6)
            expandButtonBottomAnchor.constant = 2
        }
    }
    
    @objc func expandTouchAreaTapped() {
        routeHandler?(branch)
    }
    
    @IBAction func addButtonTapped() {
        addHandler?(branch)
    }
}
