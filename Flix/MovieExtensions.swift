
import Foundation

protocol StringRepresetable
{
  var stringValue: String { get }
}

extension String: StringRepresetable
{
  var stringValue: String { return self }
}

extension Int: StringRepresetable
{
  var stringValue: String { return String(self) }
}

extension Array where Element: StringRepresetable
{
  func getFilterReferences (filter: (Movie, Element) -> Bool) -> [MovieListChangeReference]
  {
    return self
      .map { element in
        MovieListChangeReference(
          identifier: element.stringValue,
          title: element.stringValue,
          filter: { filter($0,element) },
          comparator: nil
        )
    }
  }
}

