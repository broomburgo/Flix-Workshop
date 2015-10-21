
import Foundation

enum FutureState<T>
{
  case Incomplete
  case Complete(T)
}

class Future<T>
{
  private var state = FutureState<T>.Incomplete
  private var callbacks: [T->()] = []
  
  func onComplete (callback: T -> ()) -> Future
  {
    switch state {
    case .Incomplete:
      callbacks.append(callback)
      return self
    case .Complete(let value):
      callback(value)
      return self
    }
  }
  
  func completeWith(value: T) -> Future
  {
    switch state {
    case .Incomplete:
      state = .Complete(value)
      for callback in callbacks
      {
        callback(value)
      }
      callbacks.removeAll()
      return self
    case .Complete(_):
      return self
    }
  }
}
