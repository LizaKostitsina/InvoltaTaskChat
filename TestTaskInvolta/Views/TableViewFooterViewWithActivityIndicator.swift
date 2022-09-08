//
//  TableViewFooterViewWithActivityIndicator.swift
//  TestTaskInvolta
//
//  Created by Liza Kostitsina on 9/8/22.
//

import UIKit

final class TableViewFooterViewWithActivityIndicator: UIView {

    private var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()

    init() {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(activityIndicator)

        NSLayoutConstraint.activate([     activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor)])

        activityIndicator.startAnimating()
    }
}
