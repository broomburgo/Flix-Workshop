
import Foundation

func movieComparatorSame() -> MovieComparator
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

func movieFilterAll() -> MovieFilter
{
  return { _ in true }
}

func movieFilterNone() -> MovieFilter
{
  return { _ in false }
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
  return movieListChange(filter: nil, comparator: movieComparatorSame())
}

func movieListChange (filter filter: MovieFilter?, comparator: MovieComparator?) -> MovieListChange
{
  let filterChange: MovieListChange = { movies in filter.map { movies.filter($0) }.getOrElse(movies) }
  let comparatorChange: MovieListChange = { movies in comparator.map { movies.sort(isOrderedBefore•$0) }.getOrElse(movies) }
  return comparatorChange•filterChange
}

func movieListChange (filter: MovieFilter) -> MovieListChange
{
  return movieListChange(filter: filter, comparator: nil)
}

func movieListChange (comparator: MovieComparator) -> MovieListChange
{
  return movieListChange (filter: nil, comparator: comparator)
}

func movieFilterWithReferences (references: [MovieListChangeReference], @noescape reducer: (MovieFilter, MovieFilter) -> MovieFilter) -> MovieFilter?
{
  return references
    .flatMap { $0.filter }
    .reduce(reducer)
}

func movieComparatorWithReferences (references: [MovieListChangeReference], @noescape reducer: (MovieComparator, MovieComparator) -> MovieComparator) -> MovieComparator?
{
  return references
    .flatMap { $0.comparator }
    .reduce(reducer)
}









