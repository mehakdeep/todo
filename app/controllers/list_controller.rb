class ListController < UIViewController
  def viewDidLoad
    super
    self.view.backgroundColor = UIColor.whiteColor
    list_view = ListView.alloc.initWithFrame(self.view.frame)
    self.view.addSubview(list_view)
  end
end