
import Foundation

typealias MovieFilter = Movie -> Bool
typealias MovieComparator = (Movie,Movie) -> Comparison
typealias MovieListChange = [Movie] -> [Movie]

func emptyMovieComparator() -> MovieComparator
{
  return { _ in .Same }
}

func movieComparatorFor (ascending: Bool, comparisonFunction: (Movie, Movie) -> Comparison) -> MovieComparator
{
  return {
    let comparison = comparisonFunction($0,$1)
    switch comparison {
    case .Same:
      return .Same
    case .Ascending:
      return ascending ? .Ascending : .Descending
    case .Descending:
      return ascending ? .Descending : .Ascending
    }
  }
}

func emptyMovieFilter() -> MovieFilter
{
  return { _ in true }
}

func emptyMovieListChange() -> MovieListChange
{
  return movieListChange(filter: emptyMovieFilter(), comparator: emptyMovieComparator())
}

func movieListChange (filter filter: MovieFilter, comparator: MovieComparator) -> MovieListChange
{
  return { $0.filter(filter).sort(isOrderedBefore•comparator) }
}

func movieListChange (filter: MovieFilter) -> MovieListChange
{
  return movieListChange(filter: filter, comparator: emptyMovieComparator())
}

func movieListChange (comparator: MovieComparator) -> MovieListChange
{
  return movieListChange (filter: emptyMovieFilter(), comparator: comparator)
}

func + (lhs: MovieListChange, rhs: MovieListChange) -> MovieListChange
{
  return { movies in
    lhs(rhs(movies))
  }
}

func movieListChangeGroupsReducerWithSelectedIdentifiers (selected: [MovieListChangeIdentifier:MovieListChangeIdentifier]) -> ([MovieListChangeReference],[MovieListChangeGroup]) -> [MovieListChangeReference]
{
  return { (var accumulatedReferences, currentGroups) in
    
    let newReferences = currentGroups.reduce([MovieListChangeReference]()) { (var currentReferences, currentGroup) in
      selected[currentGroup.identifier]
        .flatMap { referenceIdentifier in currentGroup.references.find { $0.identifier == referenceIdentifier } }
        .applyIfPossible { currentReferences.append($0) }
      return currentReferences
    }
    
    accumulatedReferences.appendContentsOf(newReferences)
    return accumulatedReferences
  }
}

func movieListChangeWithReferences (references: [MovieListChangeReference]) -> MovieListChange
{
  return references
    .map { $0.change }
    .reduce(emptyMovieListChange(), combine: +)
}

