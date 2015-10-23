
import UIKit

let flixColor = UIColor(red: 0.3, green: 0.1, blue: 0.6, alpha: 1)
let cellTextColor = UIColor(white: 0.1, alpha: 1)

func movieListChangeGroupsWithMovies(movieList: [Movie]) -> [[MovieListChangeGroup]]
{
  return [
    [
      MovieListChangeGroup(
        identifier: "orderBy",
        title: "Order by",
        multipleSelection: false,
        references: [
          MovieOrdering.Title(ascending: true).referenceWithIdentifier("orderBy1"),
          MovieOrdering.Title(ascending: false).referenceWithIdentifier("orderBy2"),
          MovieOrdering.Year(ascending: true).referenceWithIdentifier("orderBy3"),
          MovieOrdering.Year(ascending: false).referenceWithIdentifier("orderBy4"),
          MovieOrdering.Score(ascending: true).referenceWithIdentifier("orderBy5"),
          MovieOrdering.Score(ascending: false).referenceWithIdentifier("orderBy6")
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
        references: []
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
