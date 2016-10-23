import Foundation

enum FutureState<T> {
  case incomplete
  case complete(T)
}

class Future<T> {
  fileprivate var state = FutureState<T>.incomplete
  fileprivate var callbacks: [(T)->()] = []
  
  @discardableResult func onComplete (_ callback: @escaping (T) -> ()) -> Future {
    switch state {
    case .incomplete:
      callbacks.append(callback)
      return self
    case .complete(let value):
      callback(value)
      return self
    }
  }
  
  @discardableResult func completeWith(_ value: T) -> Future {
    switch state {
    case .incomplete:
      state = .complete(value)
      for callback in callbacks {
        callback(value)
      }
      callbacks.removeAll()
      return self
    case .complete(_):
      return self
    }
  }
}
