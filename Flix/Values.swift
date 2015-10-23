
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
        references: []
      )
    ],
    [
      MovieListChangeGroup(
        identifier: "maxDuration",
        title: "Max duration",
        references: []
      ),
      MovieListChangeGroup(
        identifier: "minYear",
        title: "Min year",
        references: []
      )
    ],
    [
      MovieListChangeGroup(
        identifier: "genres",
        title: "Genres",
        references: []
      ),
      MovieListChangeGroup(
        identifier: "rated",
        title: "Rated",
        references: []
      )
    ],
    [
      MovieListChangeGroup(
        identifier: "directors",
        title: "Directors",
        references: []
      ),
      MovieListChangeGroup(
        identifier: "writers",
        title: "Writers",
        references: []
      )
    ]
  ]
}
