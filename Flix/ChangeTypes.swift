
import Foundation

typealias MovieFilter = Movie -> Bool
typealias MovieComparator = (Movie,Movie) -> Comparison
typealias MovieListChange = [Movie] -> [Movie]
typealias MovieListChangeIdentifier = String

struct MovieListChangeReference
{
  let identifier: MovieListChangeIdentifier
  let title: String
  let filter: MovieFilter
  let comparator: MovieComparator
    
  var change: MovieListChange {
    return movieListChange(filter: filter, comparator: comparator)
  }
  
  init(identifier: MovieListChangeIdentifier, title: String, filter: MovieFilter?, comparator: MovieComparator?)
  {
    self.identifier = identifier
    self.title = title
    
    if let filter = filter
    {
      self.filter = filter
    }
    else
    {
      self.filter = emptyMovieFilter()
    }
    
    if let comparator = comparator
    {
      self.comparator = comparator
    }
    else
    {
      self.comparator = emptyMovieComparator()
    }
  }
}

struct MovieListChangeGroup
{
  let identifier: MovieListChangeIdentifier
  let title: String
  let multipleSelection: Bool
  let references: [MovieListChangeReference]
  
  init(identifier: MovieListChangeIdentifier, title: String, multipleSelection: Bool, references: [MovieListChangeReference])
  {
    self.identifier = identifier
    self.title = title
    self.multipleSelection = multipleSelection
    self.references = references
  }
}

extension MovieOrdering
{
  var comparator: MovieComparator {
    switch self {
    
    case .None:
      return emptyMovieComparator()
    
    case .Title(ascending: let ascending):
      return movieComparatorFor(ascending) { Comparison(withComparisonResult:$0.title.compare($1.title)) }
    
    case .Year(ascending: let ascending):
      return movieComparatorFor(ascending) { Comparison(first: $0.year, second: $1.year) }
    
    case .Score(ascending: let ascending):
      return movieComparatorFor(ascending) { Comparison(first: $0.score, second: $1.score) }

    }
  }
  
  func referenceWithIdentifier(identifier: MovieListChangeIdentifier) -> MovieListChangeReference
  {
    return MovieListChangeReference(
      identifier: identifier,
      title: title,
      filter: nil,
      comparator: comparator
    )
  }
}
