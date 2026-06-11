@MainActor class UIViewController {}
struct CGImage {}
struct CGRect {}

// ---- Dummy RxSwift types -----
protocol ObservableConvertibleType {
    associatedtype Element
    func asObservable() -> any ObservableType
}
protocol ObservableType: ObservableConvertibleType {
}

class Observable<Element>: ObservableType {
    func asObservable() -> any ObservableType {
        fatalError()
    }
    static func empty() -> Observable<Element> {
        fatalError()
    }
}

class BehaviorSubject<Element>: Observable<Element> {
    init(value: Element) {}
}
class PublishSubject<Element>: Observable<Element> {
    override init() {}
}
class ReplaySubject<Element>: Observable<Element> {
    static func create(bufferSize: Int) -> ReplaySubject<Element> {
        fatalError()
    }
}
class BehaviorRelay<Element>: Observable<Element> {}
protocol Disposable {}
// ----

// ---- Dummy Combine types (Combine is unavailable on Linux) -----
struct AnyPublisher<Output, Failure: Error> {}
class PassthroughSubject<Output, Failure: Error> {
    init() {}
    func eraseToAnyPublisher() -> AnyPublisher<Output, Failure> {
        AnyPublisher()
    }
}
struct DummyPublisher<Output, Failure: Error> {
    func setFailureType<E: Error>(to: E.Type) -> DummyPublisher<Output, E> {
        DummyPublisher<Output, E>()
    }
    func eraseToAnyPublisher() -> AnyPublisher<Output, Failure> {
        AnyPublisher()
    }
}
@propertyWrapper struct Published<Value> {
    var wrappedValue: Value
    init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }
    var projectedValue: DummyPublisher<Value, Never> {
        DummyPublisher()
    }
}
