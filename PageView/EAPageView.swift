//
//  UIPageView.swift
//  PageView
//
//  Created by Emil Abduselimov on 06.10.2018.
//  Copyright © 2018 Emil Abduselimov. All rights reserved.
//

import UIKit

final class EAPageView: UIView, UIScrollViewDelegate {

    private(set) var currentIndex = 0

    private var items: [EAPageItem] = []

    private let indicatorHeight: CGFloat = 4
    private let titleHeight: CGFloat = 60

    private var textLabels: [UILabel] = []

    private lazy var indicator: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = indicatorHeight / 2
        return view
    }()

    private lazy var titleScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .blue
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

    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        configure()
    }

    func add(item: EAPageItem) {
        let textLabel = UILabel()
        textLabel.textColor = .white
        textLabel.font = .boldSystemFont(ofSize: 15)
        textLabel.textAlignment = .center
        textLabel.text = item.title
        textLabels.append(textLabel)
        titleScrollView.addSubview(textLabel)
        contentScrollView.addSubview(item.view)
        items.append(item)
    }

    // MARK: - Configuration

    private func configure() {
        addSubview(titleScrollView)
        addSubview(indicator)
        addSubview(contentScrollView)

        /*
        NSLayoutConstraint.activate([
            titleScrollView.topAnchor.constraint(equalTo: topAnchor),
            titleScrollView.heightAnchor.constraint(equalToConstant: titleHeight),
            titleScrollView.leftAnchor.constraint(equalTo: leftAnchor),
            titleScrollView.rightAnchor.constraint(equalTo: rightAnchor),
        ])*/
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()

        titleScrollView.frame = CGRect(origin: .zero, size: CGSize(width: bounds.width, height: titleHeight))

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
            item.view.frame = CGRect(x: CGFloat(index) * contentScrollView.frame.width,
                                     y: 0,
                                     width: contentScrollView.frame.width,
                                     height: contentScrollView.frame.height)
        }

        contentScrollView.contentOffset = CGPoint(x: CGFloat(currentIndex) * contentScrollView.frame.width, y: 0)
        contentScrollView.contentSize = CGSize(width: CGFloat(items.count) * contentScrollView.frame.width,
                                               height: contentScrollView.frame.height)
    }

    private func layoutTextLabelSubviews() {
        for (index, view) in textLabels.enumerated() {
            view.frame = CGRect(x: CGFloat(index) * titleScrollView.frame.width / 3,
                                y: 0,
                                width: titleScrollView.frame.width / 3,
                                height: titleScrollView.frame.height)
        }

        titleScrollView.contentInset.left = bounds.width / 3
        titleScrollView.contentSize = CGSize(width: CGFloat(textLabels.count) * titleScrollView.frame.width / 3 + titleScrollView.contentInset.left, height: titleScrollView.frame.height)

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
        currentIndex = Int(contentScrollView.contentOffset.x / contentScrollView.frame.width)
    }

}
