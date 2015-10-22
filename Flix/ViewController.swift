
import UIKit

class ViewController: UIViewController
{
  @IBOutlet weak var tableView: UITableView!
  
  private let movies: [Movie]
  private var change: MovieListChange = { $0 }
  private var moviesToShow: [Movie] {
    return change(movies)
  }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?)
  {
    do
    {
      movies = try getMoviesFromFileNamed("top250.json")
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
    navigationItem.backBarButtonItem = UIBarButtonItem(
      title: "Movies",
      style: .Plain,
      target: nil,
      action: nil
    )
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .Edit,
      target: self,
      action: Selector("didTapEdit")
    )
    tableView.reloadData()
  }
  
  func didTapEdit()
  {
    let filterController = FilterController(
      movieListChangeGroups: movieListChangeGroupsWithMovieList(movies)
    )
    
    navigationController?.pushViewController(filterController, animated: true)
    
    filterController.future.onComplete { [unowned self] newChange in
      self.reloadWithChange(newChange)
      self.navigationController?.popViewControllerAnimated(true)
    }
  }
    
  func reloadWithChange(newChange: MovieListChange)
  {
    change = newChange
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
    let cell = tableView
      .dequeueReusableCellWithIdentifier(MovieCell.defaultIdentifier)
      .getOrElse(MovieCell.cell(indentifier: MovieCell.defaultIdentifier))
      as! MovieCell
    
    return cell.setMovie(moviesToShow[indexPath.row])
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
  {
    return CGFloat(MovieCell.defaultHeight)
  }
}

extension ViewController: UITableViewDelegate
{
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
  {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
}

