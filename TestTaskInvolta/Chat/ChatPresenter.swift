//
//  ChatPresenter.swift
//  TestTaskInvolta
//
//  Created by Liza Kostitsina on 9/7/22.
//

import Foundation

protocol ChatPresenterProtocol {
    /// Сообщает о загрузке вью
    func viewDidLoad()
    /// Сообщает о том, что пользователь доскроллил до конца таблицы
    func viewDidScrollToEnd()
    /// Сообщает о том, что пользователь нажал на кнопку обновления
    func didTapOnUpdateButton()
    /// Массив для хранения сообщений
    var messages: [String] { get }
}

final class ChatPresenter: ChatPresenterProtocol {
    weak var view: ChatViewProtocol?
    var messages: [String] = []
    private var networkManager: NetworkManager
    private var offset = 0
    private var countOfTryings = 5

    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }

    func viewDidLoad() {
        fetchMessages()
    }

    func viewDidScrollToEnd() {
        guard !networkManager.isPaginating else { return }
        fetchMessages(pagination: true)
    }

    func didTapOnUpdateButton() {
        fetchMessages()
    }

    /// Запрос сообщений с сервера и обработка ответа
    private func fetchMessages(pagination: Bool = false) {
        if pagination {
            offset += 20
        }
        networkManager.fetchMessages(offset: offset,
                                     pagination: pagination) { [weak self] result in
            guard let self = self,
                  let view = self.view else { return }
            switch result {
            case .error:
                self.countOfTryings -= 1
                if self.countOfTryings < 1 {
                    view.getError()
                    self.offset -= 20
                    return
                }

                if pagination {
                    self.offset -= 20
                } else {
                    self.fetchMessages()
                }

            case .data(let arrayOfMessages):
                self.messages.append(contentsOf: arrayOfMessages)
                view.updateState()
                self.countOfTryings = 5
            }
        }
    }
}
