//
//  CoinDetailsSegmentControlViewController.swift
//  BPI
//
//  Created by Admin on 6/22/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class CoinDetailsSegmentControlViewController: UIViewController {
        
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    public var selectedTab: ((ChartDateType) -> ())?
    
    private let dateTypes: [ChartDateType] = [.week, .month, .year]

    private lazy var segmentedControl: UISegmentedControl = {
        let items = dateTypes.map { $0.title }
        let result = UISegmentedControl(items: items)
        result.addTarget(self, action: #selector(valueSelected), for: .valueChanged)
        return result
    }()
    
    override func loadView() {
        super.loadView()
        view = segmentedControl
        segmentedControl.selectedSegmentIndex = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func valueSelected(_ sender: UISegmentedControl) {
        selectedTab?(dateTypes[sender.selectedSegmentIndex])
    }
    
}

fileprivate extension ChartDateType {
    var title: String {
        switch self {
        case .week: return "Неделя"
        case .month: return "Месяц"
        case .year: return "Год"
        }
    }
}
