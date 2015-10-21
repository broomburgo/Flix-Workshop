
import XCTest
@testable import Flix

class FlixTests: XCTestCase
{
  func testMovieCreation()
  {
    let optionalPath = NSBundle.mainBundle().pathForResource("top3.json", ofType: nil)
    XCTAssertNotNil(optionalPath)
    
    let optionalData = NSData(contentsOfFile: optionalPath!)
    XCTAssertNotNil(optionalData)
    
    let optionalElements = { (data: NSData) -> [[String:AnyObject]]? in
      do {
        return try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as? [[String : AnyObject]]
      }
      catch let error as NSError {
        print(error)
        return []
      }
    }(optionalData!)
    XCTAssertNotNil(optionalElements)
    
    let elements = optionalElements!
    XCTAssertEqual(elements.count, 3)
    
    let movies = elements.map { Movie(dict: $0) }
    XCTAssertEqual(elements.count, 3)
    
    assertMovie(movies[0],
      title: "The Shawshank Redemption",
      directors: ["Frank Darabont"],
      writers: ["Stephen King","Frank Darabont"],
      year: 1994,
      genres: ["Crime","Drama"],
      plot: "Andy Dufresne is a young and successful banker whose life changes drastically when he is convicted and sentenced to life imprisonment for the murder of his wife and her lover. Set in the 1940s, the film shows how Andy, with the help of his friend Red, the prison entrepreneur, turns out to be a most unconventional prisoner.",
      score: 8
    )
    
    assertMovie(movies[1],
      title: "The Godfather",
      directors: ["Francis Ford Coppola"],
      writers: ["Mario Puzo","Francis Ford Coppola"],
      year: 1972,
      genres: ["Crime","Drama"],
      plot: "When the aging head of a famous crime family decides to transfer his position to one of his subalterns, a series of unfortunate events start happening to the family, and a war begins between all the well-known families leading to insolence, deportation, murder and revenge, and ends with the favorable successor being finally chosen.",
      score: 10
    )
    
    assertMovie(movies[2],
      title: "The Dark Knight",
      directors: ["Christopher Nolan"],
      writers: ["Jonathan Nolan","Christopher Nolan"],
      year: 2008,
      genres: ["Action","Crime","Drama"],
      plot: "Batman raises the stakes in his war on crime. With the help of Lieutenant Jim Gordon and District Attorney Harvey Dent, Batman sets out to dismantle the remaining criminal organizations that plague the city streets. The partnership proves to be effective, but they soon find themselves prey to a reign of chaos unleashed by a rising criminal mastermind known to the terrified citizens of Gotham as The Joker.",
      score: 8.2
    )
  }
}

func assertMovie(
  movie: Movie,
  title: String,
  directors: [String],
  writers: [String],
  year: Int,
  genres: [String],
  plot: String,
  score: Float
  )
{
  XCTAssertEqual(movie.title, title)
  XCTAssertEqual(movie.directors, directors)
  XCTAssertEqual(movie.writers, writers)
  XCTAssertEqual(movie.year, year)
  XCTAssertEqual(movie.genres, genres)
  XCTAssertEqual(movie.plot, plot)
  XCTAssertEqual(movie.score, score)
}
