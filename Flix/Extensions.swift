
import Foundation

extension Optional {
	func getOrElse(_ elseValue: @autoclosure () -> Wrapped) -> Wrapped {
    switch self {
    case .none:
      return elseValue()
    case .some(let value):
      return value
    }
  }
  
  func applyIfPossible(_ apply: (Wrapped) -> ()) {
    switch self {
    case .none:
      return
    case .some(let value):
      return apply(value)
    }
  }
}

extension Dictionary {
  func value <T> (at key: Key, as type: T.Type) -> T? {
    return self[key] as? T
  }
}

extension String {
  func split(with separator: Character) -> [String] {
    return characters
      .split { $0 == separator }
      .map { String($0) }
  }
  
  func trim(_ stringToTrim: String) -> String {
    guard stringToTrim.characters.count > 0 else { return self }
    let stepsToAdvanceStartIndex = hasPrefix(stringToTrim) ? stringToTrim.characters.count : 0
    let stepsToAdvanceEndIndex = hasSuffix(stringToTrim) ? stringToTrim.characters.count : 0
    return String(characters[characters.index(startIndex, offsetBy: stepsToAdvanceStartIndex)..<characters.index(endIndex, offsetBy: -stepsToAdvanceEndIndex)])
  }
}

extension ComparisonResult {
  init(withComparison comparison: Comparison) {
    switch comparison {
    case .ascending:
      self = .orderedAscending
    case .same:
      self = .orderedSame
    case .descending:
      self = .orderedDescending
    }
  }
}

extension Comparison {
  init(withComparisonResult comparisonResult: ComparisonResult) {
    switch comparisonResult {
    case .orderedAscending:
      self = .ascending
    case .orderedSame:
      self = .same
    case .orderedDescending:
      self = .descending
    }
  }
}

extension Sequence {
  func find(_ predicate: (Self.Iterator.Element) -> Bool) -> Self.Iterator.Element? {
    for element in self {
      if predicate(element) {
        return element
      }
    }
    return nil
  }
}

extension Array {
  var head: Element? {
    return first
  }
  
  var tail: Array? {
    guard count > 1 else { return nil }
    return Array(self[1..<count])
  }
  
  func accumulate (with reducer: (Element, Element) -> Element) -> Element? {
    guard let head = head else { return nil }
    guard let tail = tail else { return head }
    return tail.reduce(head, reducer)
  }

	func appending (_ element: Element) -> Array {
		var m_self = self
		m_self.append(element)
		return m_self
	}
}

extension Array where Element: Comparable {
  func removeDuplicates() -> Array {
    return self
      .sorted { $0 < $1 }
      .reduce([]) { (accumulator, element) in
        if let last = accumulator.last, last == element {
          return accumulator
        } else {
          return accumulator.appending(element)
        }
    }
  }
}



