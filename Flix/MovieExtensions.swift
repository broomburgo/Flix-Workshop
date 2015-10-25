
import Foundation

protocol StringRepresetable
{
  var stringValue: String { get }
}

extension String: StringRepresetable
{
  var stringValue: String { return self }
}

extension Array where Element: StringRepresetable
{
  func getFilterReferences(filter: (Movie, String) -> Bool) -> [MovieListChangeReference]
  {
    return self
      .map { element in
        MovieListChangeReference(
          identifier: element.stringValue,
          title: element.stringValue,
          filter: { filter($0,element.stringValue) },
          comparator: nil
        )
    }
  }
}

