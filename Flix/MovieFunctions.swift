
import Foundation

func movieComparatorSame() -> MovieComparator {
  return { _ in .same }
}

func movieComparatorFor (_ ascending: Bool, comparisonFunction: @escaping (Movie, Movie) -> Comparison) -> MovieComparator {
  return {
    let comparison = comparisonFunction($0,$1)
    switch comparison {
    case .same:
      return .same
    case .ascending:
      return ascending ? .ascending : .descending
    case .descending:
      return ascending ? .descending : .ascending
    }
  }
}

func && (lhs: @escaping MovieComparator, rhs: @escaping MovieComparator) -> MovieComparator {
  return { m1, m2 in
    let comparison = lhs(m1,m2)
    switch comparison {
    case .ascending:
      return comparison
    case .same:
      return rhs(m1,m2)
    case .descending:
      return comparison
    }
  }
}

func movieFilterAll() -> MovieFilter {
  return { _ in true }
}

func movieFilterNone() -> MovieFilter {
  return { _ in false }
}

func || (lhs: @escaping MovieFilter, rhs: @escaping MovieFilter) -> MovieFilter {
  return { lhs($0) || rhs($0) }
}

func && (lhs: @escaping MovieFilter, rhs: @escaping MovieFilter) -> MovieFilter {
  return { lhs($0) && rhs($0) }
}

func emptyMovieListChange() -> MovieListChange {
  return movieListChange(filter: nil, comparator: movieComparatorSame())
}

func movieListChange (filter: MovieFilter?, comparator: MovieComparator?) -> MovieListChange {
  let filterChange: MovieListChange = { movies in filter.map { movies.filter($0) }.getOrElse(movies) }
  let comparatorChange: MovieListChange = { movies in comparator.map { movies.sorted(by: isOrderedBefore•$0) }.getOrElse(movies) }
  return comparatorChange•filterChange
}

func movieListChange (_ filter: @escaping MovieFilter) -> MovieListChange {
  return movieListChange(filter: filter, comparator: nil)
}

func movieListChange (_ comparator: @escaping MovieComparator) -> MovieListChange {
  return movieListChange (filter: nil, comparator: comparator)
}

func movieFilterWithReferences (_ references: [MovieListChangeReference], reducer: (@escaping MovieFilter, @escaping MovieFilter) -> MovieFilter) -> MovieFilter? {
  return references
    .flatMap { $0.filter }
	.accumulate(with: reducer)
}

func movieComparatorWithReferences (_ references: [MovieListChangeReference], reducer: (@escaping MovieComparator, @escaping  MovieComparator) -> MovieComparator) -> MovieComparator? {
  return references
    .flatMap { $0.comparator }
	.accumulate(with: reducer)
}
