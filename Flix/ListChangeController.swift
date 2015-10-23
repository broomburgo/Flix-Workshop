
import UIKit

class ListChangeController: UIViewController
{
  @IBOutlet weak var tableView: UITableView!
  
  private let cellIdentifier = "cellIdentifier"
  
  let future = Future<MovieListChange>()
  
  private var selectedReferences = [MovieListChangeIdentifier:MovieListChangeReference]()
  
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
    navigationItem.backBarButtonItem = UIBarButtonItem(
      title: "Cancel",
      style: .Plain,
      target: nil,
      action: nil
    )
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.setToolbarHidden(true, animated: animated)
  }
  
  func didTapDone()
  {
    let references = Array(selectedReferences.values)
    let change = movieListChange(
      filter: movieFilterWithReferences(references),
      comparator: movieComparatorWithReferences(references)
    )
    future.completeWith(change)
  }
}

extension ListChangeController: UITableViewDataSource
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
    let group = groups[indexPath.section][indexPath.row]
    
    cell.accessoryType = .DisclosureIndicator
    cell.textLabel?.text = group.title
    cell.detailTextLabel?.text = selectedReferences[group.identifier].map { $0.title }
    
    return cell
  }
}

extension ListChangeController: UITableViewDelegate
{
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
  {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    
    let group = groups[indexPath.section][indexPath.row]
    let controller = MovieChangeController(group: group)
    
    navigationController?.pushViewController(controller, animated: true)
    
    controller.future.onComplete { [unowned self] selectedReference in
      self.selectedReferences[group.identifier] = selectedReference
      self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
      self.navigationController?.popViewControllerAnimated(true)
    }
  }
}


