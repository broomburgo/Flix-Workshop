
import XCTest
@testable import Flix

let fileName = "top3.json"

class FlixTests: XCTestCase
{
  func testMovieCreation()
  {
    let optionalPath = NSBundle.mainBundle().pathForResource(fileName, ofType: nil)
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
    assertMovies(movies)
  }
  
  func testGetMoviesFromFileNamed()
  {
    do
    {
      let movies = try getMoviesFromFileNamed(fileName)
      assertMovies(movies)
    }
    catch let error as NSError
    {
      print(error)
      XCTAssertTrue(false)
    }
  }
  
  func testFuture()
  {
    let expectedValue = 3
    let wrongValue = 10
   
    let futureExpectation1 = expectationWithDescription("futureExpectation1")
    let futureExpectation2 = expectationWithDescription("futureExpectation2")
    let futureExpectation3 = expectationWithDescription("futureExpectation3")
    let futureExpectation4 = expectationWithDescription("futureExpectation4")
    
    let future1 = Future<Int>()
    
    future1
      .onComplete { value in
        XCTAssertEqual(value, expectedValue)
        futureExpectation1.fulfill()
      }
      .onComplete { value in
        XCTAssertEqual(value, expectedValue)
        futureExpectation2.fulfill()
    }
    
    future1.completeWith(expectedValue)
    
    future1.onComplete { value in
      XCTAssertEqual(value, expectedValue)
      futureExpectation3.fulfill()
    }
    
    future1.completeWith(wrongValue)

    future1.onComplete { value in
      XCTAssertEqual(value, expectedValue)
      futureExpectation4.fulfill()
    }
    
    waitForExpectationsWithTimeout(1, handler: nil)
  }
  
  func testTrimString()
  {
    let string1 = "abstring1ab"
    let string1Trimmed = string1.trim("ab")
    let expectedString1Trimmed = "string1"
    XCTAssertEqual(string1Trimmed, expectedString1Trimmed)
    
    let string2 = "abstring2"
    let string2Trimmed = string2.trim("ab")
    let expectedString2Trimmed = "string2"
    XCTAssertEqual(string2Trimmed, expectedString2Trimmed)
    
    let string3 = "string3ab"
    let string3Trimmed = string3.trim("ab")
    let expectedString3Trimmed = "string3"
    XCTAssertEqual(string3Trimmed, expectedString3Trimmed)
    
    let string4 = "string4"
    let string4Trimmed = string4.trim("ab")
    let expectedString4Trimmed = "string4"
    XCTAssertEqual(string4Trimmed, expectedString4Trimmed)
    
    let string5 = "string5"
    let string5Trimmed = string5.trim("")
    let expectedString5Trimmed = "string5"
    XCTAssertEqual(string5Trimmed, expectedString5Trimmed)
  }
  
  func testremoveDuplicates()
  {
    let array1 = ["a","n","g","a","z","b","c","h","d","d","d","l","p","a","z","z","n","g","b","c","h","l","s","x","f","e","g","e"]
    let array1NoDuplicatesWannabe = ["a","b","c","d","e","f","g","h","l","n","p","s","x","z"]
    let array1NoDuplicates = array1.removeDuplicates([])
    XCTAssertEqual(array1NoDuplicates, array1NoDuplicatesWannabe)
    
    let array2 = ["a","a","a"]
    let array2NoDuplicatesWannabe = ["a"]
    let array2NoDuplicates = array2.removeDuplicates([])
    XCTAssertEqual(array2NoDuplicates, array2NoDuplicatesWannabe)
    
    let array3 = [String]()
    let array3NoDuplicatesWannabe = [String]()
    let array3NoDuplicates = array3.removeDuplicates([])
    XCTAssertEqual(array3NoDuplicates, array3NoDuplicatesWannabe)
  }
}

func assertMovies(movies: [Movie])
{
  XCTAssertEqual(movies.count, 3)
  
  assertMovie(movies[0],
    title: "The Shawshank Redemption",
    directors: ["Frank Darabont"],
    writers: ["Stephen King","Frank Darabont"],
    year: 1994,
    genres: ["Crime","Drama"],
    plot: "Andy Dufresne is a young and successful banker whose life changes drastically when he is convicted and sentenced to life imprisonment for the murder of his wife and her lover. Set in the 1940s, the film shows how Andy, with the help of his friend Red, the prison entrepreneur, turns out to be a most unconventional prisoner.",
    score: 9.3
  )
  
  assertMovie(movies[1],
    title: "The Godfather",
    directors: ["Francis Ford Coppola"],
    writers: ["Mario Puzo","Francis Ford Coppola"],
    year: 1972,
    genres: ["Crime","Drama"],
    plot: "When the aging head of a famous crime family decides to transfer his position to one of his subalterns, a series of unfortunate events start happening to the family, and a war begins between all the well-known families leading to insolence, deportation, murder and revenge, and ends with the favorable successor being finally chosen.",
    score: 9.2
  )
  
  assertMovie(movies[2],
    title: "The Dark Knight",
    directors: ["Christopher Nolan"],
    writers: ["Jonathan Nolan","Christopher Nolan"],
    year: 2008,
    genres: ["Action","Crime","Drama"],
    plot: "Batman raises the stakes in his war on crime. With the help of Lieutenant Jim Gordon and District Attorney Harvey Dent, Batman sets out to dismantle the remaining criminal organizations that plague the city streets. The partnership proves to be effective, but they soon find themselves prey to a reign of chaos unleashed by a rising criminal mastermind known to the terrified citizens of Gotham as The Joker.",
    score: 9.0
  )
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
