
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
    let stepsToAdvanceStartIndex = hasPrefix(stringToTrim) ? stringToTrim.characters.count : 0
    let stepsToAdvanceEndIndex = hasSuffix(stringToTrim) ? stringToTrim.characters.count : 0
    return String(characters[startIndex.advancedBy(stepsToAdvanceStartIndex)..<endIndex.advancedBy(-stepsToAdvanceEndIndex)])
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

extension Array
{
  var head: Element? {
    return first
  }
  
  var tail: Array? {
    guard count > 1 else { return nil }
    return Array(self[1..<count])
  }
  
  func reduce (@noescape reducer: (Element, Element) -> Element) -> Element?
  {
    guard let head = head else { return nil }
    guard let tail = tail else { return head }
    return tail.reduce(head, combine: reducer)
  }
}

extension Array where Element: Comparable
{
  func removeDuplicates() -> Array
  {
    return self
      .sort { $0 < $1 }
      .reduce([]) { (var accumulator, element) in
        if let
          last = accumulator.last
          where last == element
        {
          return accumulator
        }
        else
        {
          accumulator.append(element)
          return accumulator
        }
    }
  }
}



