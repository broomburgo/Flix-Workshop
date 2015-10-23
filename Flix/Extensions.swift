
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
  
  func applyIfPossible(@noescape apply: Wrapped -> ())
  {
    switch self {
    case .None:
      return
    case .Some(let value):
      return apply(value)
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
  
  func trim(stringToTrim: String) -> String
  {
    guard stringToTrim.characters.count > 0 else { return self }
    let stepsToAdvanceStartIndex = self.hasPrefix(stringToTrim) ? stringToTrim.characters.count : 0
    let stepsToAdvanceEndIndex = self.hasSuffix(stringToTrim) ? stringToTrim.characters.count : 0
    return self.substringWithRange(Range(start: self.startIndex.advancedBy(stepsToAdvanceStartIndex), end: self.endIndex.advancedBy(-stepsToAdvanceEndIndex)))
  }
}

extension NSComparisonResult
{
  init(withComparison comparison: Comparison)
  {
    switch comparison {
    case .Ascending:
      self = .OrderedAscending
    case .Same:
      self = .OrderedSame
    case .Descending:
      self = .OrderedDescending
    }
  }
}

extension Comparison
{
  init(withComparisonResult comparisonResult: NSComparisonResult)
  {
    switch comparisonResult
    {
    case .OrderedAscending:
      self = .Ascending
    case .OrderedSame:
      self = .Same
    case .OrderedDescending:
      self = .Descending
    }
  }
}

extension SequenceType
{
  func find(predicate: Self.Generator.Element -> Bool) -> Self.Generator.Element?
  {
    for element in self
    {
      if predicate(element)
      {
        return element
      }
    }
    return nil
  }
}