
import UIKit

class ViewController: UIViewController
{
  @IBOutlet weak var tableView: UITableView!
  let cellIdentifier = "cellIdentifier"
  
  private let movies: [Movie]
  private var modifier: MovieListModifier
  private var moviesToShow: [Movie] {
    return movies.filter(modifier.filter).sort(isOrderedBefore•modifier.comparator)
  }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?)
  {
    do
    {
      movies = try getMoviesFromFileNamed("top250.json")
      modifier = MovieListModifier.empty()
    }
    catch let error as NSError
    {
      fatalError(error.description)
    }
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }

  required init?(coder aDecoder: NSCoder)
  {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    title = "Flix"
    tableView.reloadData()
  }
  
  func reloadWithModifier(newModifier: MovieListModifier)
  {
    modifier = newModifier
    tableView.reloadData()
  }
}

extension ViewController: UITableViewDataSource
{
  func numberOfSectionsInTableView(tableView: UITableView) -> Int
  {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return moviesToShow.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
  {
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier).getOrElse(UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier))
    let movie = moviesToShow[indexPath.row]
    cell.textLabel?.text = movie.title
    return cell
  }
}

extension ViewController: UITableViewDelegate
{
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
  {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
}

