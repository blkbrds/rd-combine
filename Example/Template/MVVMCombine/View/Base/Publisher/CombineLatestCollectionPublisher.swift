//
//  CombineLatesCollection.swift
//  MVVMCombine
//
//  Created by Trin Nguyen X on 5/11/21.
//  Copyright © 2021 Monstar Lab VietNam Co., Ltd. All rights reserved.
//

import Foundation
import Combine

class CombineLatestCollection<Publishers>: Publisher where Publishers: Collection, Publishers.Element: Publisher {

    typealias Output = [Publishers.Element.Output]

    typealias Failure = Publishers.Element.Failure

    private let publishers: Publishers

    init(publishers: Publishers) {
        self.publishers = publishers
    }

    func receive<S>(subscriber: S) where S: Subscriber,
                                         Publishers.Element.Failure == S.Failure,
                                         [Publishers.Element.Output] == S.Input {
        let subscription = Subscription(publishers: publishers,
                                        subscriber: subscriber)
        subscriber.receive(subscription: subscription)
    }
}

extension CombineLatestCollection {
    final class Subscription<Subscriber>: Combine.Subscription where Subscriber: Combine.Subscriber,
                                                                     Subscriber.Failure == Failure,
                                                                     Subscriber.Input == Output {

        private let subscribers: [AnyCancellable]

        fileprivate init(publishers: Publishers, subscriber: Subscriber) {
            var values: [Publishers.Element.Output?] = Array(repeating: nil, count: publishers.count)
            var completions = 0
            var hasCompleted = false
            var lock = pthread_mutex_t()

            subscribers = publishers.enumerated().map { index, publisher in

                publisher
                    .sink(receiveCompletion: { completion in

                        pthread_mutex_lock(&lock)
                        defer { pthread_mutex_unlock(&lock) }

                        guard case .finished = completion else {
                            // One failure in any of the publishers cause a
                            // failure for this subscription.
                            subscriber.receive(completion: completion)
                            hasCompleted = true
                            return
                        }

                        completions += 1

                        if completions == publishers.count {
                                subscriber.receive(completion: completion)
                                hasCompleted = true
                        }

                    }, receiveValue: { value in

                        pthread_mutex_lock(&lock)
                        defer { pthread_mutex_unlock(&lock) }

                        guard !hasCompleted else { return }

                        values[index] = value

                        // Get non-optional array of values and make sure we
                        // have a full array of values.
                        let current = values.compactMap { $0 }
                        if current.count == publishers.count {
                             _ = subscriber.receive(current)
                        }
                    })
            }
        }

        func request(_ demand: Subscribers.Demand) { }

        func cancel() {
            subscribers.forEach { $0.cancel() }
        }
    }
}

// Customize operator
extension Collection where Element: Publisher {

    func combineLatestMany() -> CombineLatestCollection<Self> {
        CombineLatestCollection(publishers: self)
    }
}
