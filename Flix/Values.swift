
import UIKit

let flixColor = UIColor(red: 0.3, green: 0.1, blue: 0.6, alpha: 1)
let actionColor = UIColor(red: 0.95, green: 0.85, blue: 0.3, alpha: 1)
let cellTextColor = UIColor(white: 0.1, alpha: 1)

func movieListChangeGroupsWithMovies(movies: [Movie]) -> [[MovieListChangeGroup]]
{
  return [
    [
      MovieListChangeGroup(
        identifier: "orderBy",
        title: "Order by",
        multipleSelection: false,
        references: [
          MovieOrdering.Title(ascending: true).referenceWithIdentifier("orderByTitle1"),
          MovieOrdering.Title(ascending: false).referenceWithIdentifier("orderByTitle2"),
          MovieOrdering.Year(ascending: true).referenceWithIdentifier("orderByYear1"),
          MovieOrdering.Year(ascending: false).referenceWithIdentifier("orderByYear2"),
          MovieOrdering.Score(ascending: true).referenceWithIdentifier("orderByScore1"),
          MovieOrdering.Score(ascending: false).referenceWithIdentifier("orderByScore2")
        ]
      )
    ],
    [
      MovieListChangeGroup(
        identifier: "maxDuration",
        title: "Max duration",
        multipleSelection: false,
        references: []
      ),
      MovieListChangeGroup(
        identifier: "minYear",
        title: "Min year",
        multipleSelection: false,
        references: []
      )
    ],
    [
      MovieListChangeGroup(
        identifier: "genres",
        title: "Genres",
        multipleSelection: true,
        references: genresFromMovies(movies)
          .map { genre in
            MovieListChangeReference(
              identifier: genre,
              title: genre,
              filter: { $0.genres.contains(genre) },
              comparator: nil
            )
        }
      ),
      MovieListChangeGroup(
        identifier: "rated",
        title: "Rated",
        multipleSelection: true,
        references: []
      )
    ],
    [
      MovieListChangeGroup(
        identifier: "directors",
        title: "Directors",
        multipleSelection: true,
        references: []
      ),
      MovieListChangeGroup(
        identifier: "writers",
        title: "Writers",
        multipleSelection: true,
        references: []
      )
    ]
  ]
}
