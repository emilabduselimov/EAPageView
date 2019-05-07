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

    private let indicatorViewHeight: CGFloat = 4
    private let indicatorViewWidth: CGFloat = 120
    private let titleHeight: CGFloat = 44

    private var textLabels: [UILabel] = []

    private lazy var indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = indicatorViewHeight / 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var titleScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor(red: 66 / 255, green: 134 / 255, blue: 244 / 255, alpha: 1)
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.alwaysBounceHorizontal = true
        scrollView.alwaysBounceVertical = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
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
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
        configureLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        configure()
        configureLayout()
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
        addSubview(indicatorView)
        addSubview(contentScrollView)
    }

    // MARK: - Configure Layout

    private func configureLayout() {
        NSLayoutConstraint.activate([
            titleScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleScrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleScrollView.topAnchor.constraint(equalTo: topAnchor),
            titleScrollView.heightAnchor.constraint(equalToConstant: titleHeight),
            contentScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentScrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentScrollView.topAnchor.constraint(equalTo: titleScrollView.bottomAnchor),
            contentScrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            indicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            indicatorView.widthAnchor.constraint(equalToConstant: indicatorViewWidth),
            indicatorView.heightAnchor.constraint(equalToConstant: indicatorViewHeight),
            indicatorView.bottomAnchor.constraint(equalTo: titleScrollView.bottomAnchor)
        ])
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()

        layoutTitleScrollViewSubviews()
        layoutContentScrollViewSubviews()
    }

    private func layoutContentScrollViewSubviews() {
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

    private func layoutTitleScrollViewSubviews() {
        for (index, view) in textLabels.enumerated() {
            view.frame = CGRect(x: CGFloat(index) * titleScrollView.frame.width / 3,
                                y: 0,
                                width: titleScrollView.frame.width / 3,
                                height: titleScrollView.frame.height)
        }

        titleScrollView.contentInset.left = bounds.width / 3
        let width = CGFloat(textLabels.count) * titleScrollView.frame.width / 3 + titleScrollView.contentInset.left
        titleScrollView.contentSize = CGSize(width: width,
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
        currentIndex = Int(contentScrollView.contentOffset.x / contentScrollView.frame.width)
    }

}
