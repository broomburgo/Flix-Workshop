
import UIKit

let flixColor = UIColor(red: 0.3, green: 0.1, blue: 0.6, alpha: 1)
let actionColor = UIColor(red: 0.95, green: 0.85, blue: 0.3, alpha: 1)
let cellTextColor = UIColor(white: 0.1, alpha: 1)

func movieListChangeGroupsWithMovies(_ movies: [Movie]) -> [[MovieListChangeGroup]] {
  return [
    [
      MovieListChangeGroup(
        identifier: "orderBy",
        title: "Order by",
        multipleSelection: false,
        references: [
          MovieOrdering.byTitle(ascending: true).referenceWithIdentifier("orderByTitle1"),
          MovieOrdering.byTitle(ascending: false).referenceWithIdentifier("orderByTitle2"),
          MovieOrdering.byYear(ascending: true).referenceWithIdentifier("orderByYear1"),
          MovieOrdering.byYear(ascending: false).referenceWithIdentifier("orderByYear2"),
          MovieOrdering.byScore(ascending: true).referenceWithIdentifier("orderByScore1"),
          MovieOrdering.byScore(ascending: false).referenceWithIdentifier("orderByScore2")
        ]
      )
    ],
    [
      MovieListChangeGroup(
        identifier: "maxDuration",
        title: "Max duration (minutes)",
        multipleSelection: false,
        references: runtimeMinutesFromMovies(movies)
          .getFilterReferences { movie, runtimeMinutes in movie.runtimeMinutes <= runtimeMinutes }
      ),
      MovieListChangeGroup(
        identifier: "minYear",
        title: "Min year",
        multipleSelection: false,
        references: yearsFromMovies(movies)
          .sorted { $0 > $1 }
          .getFilterReferences { movie, year in movie.year >= year }
      )
    ],
    [
      MovieListChangeGroup(
        identifier: "genres",
        title: "Genres",
        multipleSelection: true,
        references: genresFromMovies(movies)
          .getFilterReferences { movie, genre in movie.genres.contains(genre) }
      ),
      MovieListChangeGroup(
        identifier: "rated",
        title: "Rated",
        multipleSelection: true,
        references: ratedFromMovies(movies)
          .getFilterReferences { movie, rated in movie.rated == rated }
      )
    ],
    [
      MovieListChangeGroup(
        identifier: "directors",
        title: "Directors",
        multipleSelection: true,
        references: directorsFromMovies(movies)
          .getFilterReferences { movie, director in movie.directors.contains(director) }
      ),
      MovieListChangeGroup(
        identifier: "writers",
        title: "Writers",
        multipleSelection: true,
        references: writersFromMovies(movies)
          .getFilterReferences { movie, writer in movie.writers.contains(writer) }
      )
    ]
  ]
}
