
import UIKit

class FilterController: UIViewController
{
  let future = Future<MovieListModifier>()
  
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
    let modifier = MovieListModifier(
      filter: { _ in true },
      comparator: { _ in .Same }
    )
    future.completeWith(modifier)
  }
  
}
