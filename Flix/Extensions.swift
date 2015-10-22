
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
      self = NSComparisonResult.OrderedAscending
    case .Same:
      self = NSComparisonResult.OrderedSame
    case .Descending:
      self = NSComparisonResult.OrderedDescending
    }
  }
}
