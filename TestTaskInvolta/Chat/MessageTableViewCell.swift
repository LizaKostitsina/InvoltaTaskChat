//
//  MessageTableViewCell.swift
//  TestTaskInvolta
//
//  Created by Liza Kostitsina on 9/7/22.
//

import UIKit

struct MessageTableViewCellModel {
    let message: String
}

final class MessageTableViewCell: UITableViewCell {
    struct Appearance {
        let verticalOffset: CGFloat  = 15
        let horizontalOffset: CGFloat  = 20
        let messageFont = UIFont.systemFont(ofSize: 14, weight: .medium)
        let bubbleViewBackgroundColor = UIColor.systemGray2
        let messageLabelTextColor = UIColor.white
        var doubleVerticalOffset: CGFloat { verticalOffset * 2 }
        var doubleHorizontalOffset: CGFloat { horizontalOffset * 2 }
    }
    // MARK: - Private properties
    private let appearance = Appearance()
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = appearance.messageLabelTextColor
        label.font = appearance.messageFont
        return label
    }()

    private lazy var bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = appearance.bubbleViewBackgroundColor
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()

    // MARK: - Lifecycle methods
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupInitialState()
    }

    required init?(coder: NSCoder) {
        assertionFailure()
        return nil
    }

    // MARK: - Overriden methods
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        return CGSize(width: contentView.frame.width,
                      height: bubbleView.bounds.height + appearance.doubleVerticalOffset)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        messageLabel.text = nil
    }

    // MARK: - Internal methods
    /// Устанавливает данные в лэйблы
    func set(model: MessageTableViewCellModel) {
        messageLabel.text = model.message
        setupFrameSize()

        messageLabel.sizeToFit()
        messageLabel.layoutIfNeeded()

        bubbleView.sizeToFit()
        bubbleView.layoutIfNeeded()
    }

    // MARK: - Private methods
    /// Установка начального состояния
    private func setupInitialState() {
        selectionStyle = .none
        addSubviews()
        setupFrameOrigin()
    }

    /// Добавление сабвью на их супервью
    private func addSubviews() {
        contentView.addSubview(bubbleView)
        bubbleView.addSubview(messageLabel)
    }

    /// Установка положения вью
    private func setupFrameOrigin() {
        messageLabel.frame.origin = CGPoint(x: appearance.horizontalOffset,
                                            y: appearance.verticalOffset)
        bubbleView.frame.origin = CGPoint(x: appearance.horizontalOffset,
                                          y: appearance.verticalOffset)
    }

    /// Установка размеров вью
    private func setupFrameSize() {
        guard let text = messageLabel.text else { return }
        let width = UIScreen.main.bounds.width - (appearance.doubleHorizontalOffset * 2)
        let height = text.height(withConstrainedWidth: width, font: appearance.messageFont)


        messageLabel.frame.size = CGSize(width: width,
                                         height: height)


        bubbleView.frame.size = CGSize(width: width + appearance.doubleHorizontalOffset,
                                       height: height + appearance.doubleVerticalOffset)
    }
}
