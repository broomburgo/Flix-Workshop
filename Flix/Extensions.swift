
import Foundation

extension Optional
{
  func getOrElse(@autoclosure elseValue: () -> Wrapped) -> Wrapped
  {
    switch self {
    case .None:
      return elseValue()
    case .Some(let value):
      return value
    }
  }
}

extension Dictionary
{
  func valueForKey <T> (key: Key, asType: T.Type) -> T?
  {
    return self[key] as? T
  }
}

extension String
{
  func splitWithSeparator(separator: Character) -> [String]
  {
    return characters
      .split { $0 == separator }
      .map { String($0) }
  }
}

extension NSComparisonResult
{
  init(withComparison comparison: Comparison)
  {
    switch comparison {
    case .Ascending:
      self = NSComparisonResult.OrderedAscending
    case .Same:
      self = NSComparisonResult.OrderedSame
    case .Descending:
      self = NSComparisonResult.OrderedDescending
    }
  }
}