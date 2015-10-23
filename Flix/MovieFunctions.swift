
import Foundation

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

func && (lhs: MovieComparator, rhs: MovieComparator) -> MovieComparator
{
  return { m1, m2 in
    let comparison = lhs(m1,m2)
    switch comparison {
    case .Ascending:
      return comparison
    case .Same:
      return rhs(m1,m2)
    case .Descending:
      return comparison
    }
  }
}

func emptyMovieFilter() -> MovieFilter
{
  return { _ in true }
}

func || (lhs: MovieFilter, rhs: MovieFilter) -> MovieFilter
{
  return { lhs($0) || rhs($0) }
}

func && (lhs: MovieFilter, rhs: MovieFilter) -> MovieFilter
{
  return { lhs($0) && rhs($0) }
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

func movieListChangeWithReferences (references: [MovieListChangeReference]) -> MovieListChange
{
  return references
    .map { $0.change }
    .reduce(emptyMovieListChange(), combine: +)
}

