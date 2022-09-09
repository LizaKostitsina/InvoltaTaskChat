//
//  ViewController.swift
//  TestTaskInvolta
//
//  Created by Liza Kostitsina on 9/7/22.
//

import UIKit

protocol ChatViewProtocol: AnyObject {
    /// Вызывается при получении ошибки с сервера
    func getError()
    /// Вызывается при успешном получении данных
    func updateState()
}

final class ChatViewController: UIViewController {

    // MARK: - Private properties
    private var canShowAlert: Bool = false
    private var presenter: ChatPresenterProtocol
    /// Таблица с сообщениями
    private lazy var mainTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: "MessageTableViewCell")
        tableView.separatorStyle = .none
        tableView.tableFooterView = activityIndicator
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        return tableView
    }()

    private lazy var activityIndicator: TableViewFooterViewWithActivityIndicator = {
        let view = TableViewFooterViewWithActivityIndicator()
        view.frame.size = CGSize(width: UIScreen.main.bounds.width,
                                 height: 40)
        return view
    }()

    private lazy var updateButton: UIButton = {
        let button = UIButton()
        button.frame.size = CGSize(width: 40,
                                   height: 40)
        button.setTitle("Try again", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapOnUpdateButton), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle methods
    init(presenter: ChatPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        setupInitialState()
    }

    // MARK: - Private methods
    /// Активирует констрейнты
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // mainTableView constraints
            mainTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    /// Добавляет сабвью на супервью
    private func addSubviews() {
        view.addSubview(mainTableView)
    }

    /// Уставнока настроек таблицы, назначение делегата и датасорса
    private func setupTableView() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
    }

    /// Установка начального состояния
    private func setupInitialState() {
        addSubviews()
        setupConstraints()
        setupTableView()
    }

    /// Установка состояния, когда данные не загрузились(только при первом запросе)
    private func setupUpdateState() {
        view.addSubview(updateButton)
        NSLayoutConstraint.activate([
            updateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            updateButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    /// Показывает алерт с ошибкой соединения
    private func showAlertWithError() {
        let alert = UIAlertController(title: "Error", message: "Connection problems. Try again later", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    /// Нотификация о нажатии на кнопку обновления
    @objc func didTapOnUpdateButton() {
        presenter.didTapOnUpdateButton()
    }
}


extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell", for: indexPath) as? MessageTableViewCell
        else { return UITableViewCell() }
        let message = presenter.messages[indexPath.row]
        let cellModel = MessageTableViewCellModel(message: message)
        cell.set(model: cellModel)
        cell.sizeToFit()
        cell.layoutIfNeeded()
        cell.transform = CGAffineTransform(scaleX: 1, y: -1)
        return cell
    }
}

extension ChatViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (mainTableView.contentSize.height - 10 - scrollView.frame.size.height) {
            canShowAlert = true
            mainTableView.tableFooterView?.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.mainTableView.tableFooterView?.isHidden = true
            }
        } else {
            canShowAlert = false
        }

        if scrollView.panGestureRecognizer.translation(in: scrollView.superview).y < 0 {
            mainTableView.tableFooterView?.isHidden = true
            return
        }

        if position > (mainTableView.contentSize.height - 300 - scrollView.frame.size.height) {
            mainTableView.tableFooterView?.isHidden = false
            presenter.viewDidScrollToEnd()
        }
    }
}

extension ChatViewController: ChatViewProtocol {
    func getError() {
        if presenter.messages.isEmpty {
            showAlertWithError()
            setupUpdateState()
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.mainTableView.tableFooterView?.isHidden = true
        }
        if canShowAlert {
            showAlertWithError()
        }
    }

    func updateState() {
        updateButton.isHidden = true
        mainTableView.tableFooterView?.isHidden = true
        mainTableView.reloadData()
    }
}
