
import UIKit

class FilterController: UIViewController
{
  @IBOutlet weak var tableView: UITableView!
  
  private let cellIdentifier = "cellIdentifier"
  
  let future = Future<MovieListChange>()
  
  private var selectedIdentifiers = [MovieListChangeIdentifier:MovieListChangeIdentifier]()
  
  private let groups: [[MovieListChangeGroup]]
  required init(movieListChangeGroups: [[MovieListChangeGroup]])
  {
    self.groups = movieListChangeGroups
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder)
  {
      fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    title = "Order & Filter"
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .Done,
      target: self,
      action: Selector("didTapDone")
    )
  }
  
  func didTapDone()
  {
    let modifier: MovieListChange = { $0 }
    future.completeWith(modifier)
  }
}

extension FilterController: UITableViewDataSource
{
  func numberOfSectionsInTableView(tableView: UITableView) -> Int
  {
    return groups.count
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return groups[section].count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
  {
    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier).getOrElse(UITableViewCell(style: .Value1, reuseIdentifier: cellIdentifier))
    let reference = groups[indexPath.section][indexPath.row]
    
    cell.accessoryType = .DisclosureIndicator
    cell.textLabel?.text = reference.title
    
    cell.detailTextLabel?.text = selectedIdentifiers[reference.identifier]
      .flatMap { identifier in reference.references.find { $0.identifier == identifier } }
      .map { $0.title }
    
    return cell
  }
}

extension FilterController: UITableViewDelegate
{
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
  {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
}


