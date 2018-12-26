//
//  UIPageView.swift
//  PageView
//
//  Created by Emil Abduselimov on 06.10.2018.
//  Copyright © 2018 Emil Abduselimov. All rights reserved.
//

import UIKit

final class EAPageView: UIView, UIScrollViewDelegate {

    private var items: [EAPageItem] = []

    private let indicatorHeight: CGFloat = 3
    private let titleHeight: CGFloat = 60

    private var textLabels: [UILabel] = []
    private var lastBounds: CGRect = .zero

    private lazy var indicator: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = indicatorHeight / 2
        return view
    }()

    private lazy var titleScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .black
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.alwaysBounceHorizontal = true
        scrollView.alwaysBounceVertical = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()

    private lazy var contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.alwaysBounceHorizontal = true
        scrollView.alwaysBounceVertical = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = true
        return scrollView
    }()

    // MARK: - Initialization

    convenience init(items: [EAPageItem]) {
        self.init(frame: .zero)
        self.items = items
        configureView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration

    private func configureView() {
        addSubview(titleScrollView)
        addSubview(indicator)
        addSubview(contentScrollView)

        items.forEach {
            let textLabel = UILabel()
            textLabel.textColor = .white
            textLabel.font = .boldSystemFont(ofSize: 15)
            textLabel.textAlignment = .center
            textLabel.text = $0.title
            textLabels.append(textLabel)
            titleScrollView.addSubview(textLabel)
            contentScrollView.addSubview($0.view)
        }
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()

        titleScrollView.frame = CGRect(x: 0,
                                       y: 0,
                                       width: bounds.width,
                                       height: titleHeight)

        contentScrollView.frame = CGRect(x: 0,
                                         y: titleScrollView.frame.maxY,
                                         width: bounds.width,
                                         height: bounds.height - titleHeight)

        indicator.frame = CGRect(x: bounds.width / 3,
                                 y: titleScrollView.frame.maxY - indicatorHeight,
                                 width: bounds.width / 3,
                                 height: indicatorHeight)

        layoutContentSubviews()
        layoutTextLabelSubviews()
    }

    private func layoutContentSubviews() {
        for (index, item) in items.enumerated() {
            let isViewVisible = lastBounds.origin.x == item.view.frame.origin.x
            item.view.frame = CGRect(x: CGFloat(index) * contentScrollView.frame.width,
                                     y: 0,
                                     width: contentScrollView.frame.width,
                                     height: contentScrollView.frame.height)
            if isViewVisible {
                contentScrollView.setContentOffset(item.view.frame.origin, animated: false)
            }
        }

        contentScrollView.contentSize = CGSize(width: CGFloat(items.count) * contentScrollView.frame.width,
                                               height: contentScrollView.frame.height)
        lastBounds = contentScrollView.bounds
    }

    private func layoutTextLabelSubviews() {
        for (index, view) in textLabels.enumerated() {
            view.frame = CGRect(x: CGFloat(index) * titleScrollView.frame.width / 3,
                                y: 0,
                                width: titleScrollView.frame.width / 3,
                                height: titleScrollView.frame.height)
        }

        titleScrollView.contentInset = UIEdgeInsets(top: 0, left: bounds.width / 3, bottom: 0, right: 0)

        titleScrollView.contentSize = CGSize(width: CGFloat(textLabels.count) * titleScrollView.frame.width / 3 + titleScrollView.contentInset.left,
            height: titleScrollView.frame.height)

        scrollTitleScrollView()
    }

    private func scrollTitleScrollView() {
        titleScrollView.contentOffset = CGPoint(x: contentScrollView.bounds.origin.x / 3 - titleScrollView.contentInset.left, y: 0)
    }

    // MARK: - UIScrollViewDelegate

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView === self.contentScrollView {
            scrollTitleScrollView()
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        lastBounds = scrollView.bounds
    }

}
