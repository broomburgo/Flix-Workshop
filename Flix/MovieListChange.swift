
import Foundation

typealias MovieFilter = Movie -> Bool
typealias MovieComparator = (Movie,Movie) -> Comparison
typealias MovieListChange = [Movie] -> [Movie]

func emptyMovieComparator() -> MovieComparator
{
  return { _ in .Same }
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

func movieListChangeGroupsWithMovieList(movieList: [Movie]) -> [[MovieListChangeGroup]]
{
  return [[MovieListChangeGroup(
    identifier: "orderBy",
    title: "Order by",
    references: []
    )],
    [MovieListChangeGroup(
      identifier: "maxDuration",
      title: "Max duration",
      references: []
      ),
      MovieListChangeGroup(
        identifier: "minYear",
        title: "Min year",
        references: []
      )],
    [MovieListChangeGroup(
      identifier: "genres",
      title: "Genres",
      references: []
      ),
      MovieListChangeGroup(
        identifier: "rated",
        title: "Rated",
        references: []
      )],
    [MovieListChangeGroup(
      identifier: "directors",
      title: "Directors",
      references: []
      ),
      MovieListChangeGroup(
        identifier: "writers",
        title: "Writers",
        references: []
      )]
  ]
}

