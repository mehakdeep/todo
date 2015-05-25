class ListView < UIView
  attr_accessor :text_area, :task_list, :add_task_button, :tasks


  def initWithFrame frame
    super
    self.tasks = Task.all.sort { |a, b| b.created_at <=> a.created_at }
    @tap_count = 0
    add_text_area
    add_task_list
  end


  def add_text_area
    text_field_view = UITextField.alloc.initWithFrame(CGRectMake(0, 20, self.frame.size.width - 50, 40))
    text_field_view.delegate = self
    text_field_view.borderStyle = UITextBorderStyleRoundedRect

    text_field_view.textColor =UIColor.blackColor
    text_field_view.becomeFirstResponder

    text_field_view.placeholder = "new task"
    #text_field_view.setValue(UIColor.blackColor.colorWithAlphaComponent(0.3), forKeyPath: "_placeholderLabel.textColor")
    text_field_view.textAlignment = NSTextAlignmentLeft
    self.text_area = text_field_view
    self.addSubview(text_field_view)

    #add button
    add_task_button = UIButton.buttonWithType UIButtonTypeCustom
    add_task_button.setFrame(CGRectMake(self.frame.size.width - 40, 20, 35, 40))
    add_task_button.setTitleColor(UIColor.blackColor, forState: UIControlStateNormal)
    add_task_button.setTitle("Add", forState: UIControlStateNormal)
    #self.search_button.frame = [[15, 15], [30, 40]]
    add_task_button.addTarget(self,
                              action: :add_task,
                              forControlEvents: UIControlEventTouchUpInside)
    self.add_task_button = add_task_button
    self.addSubview add_task_button
  end

  def add_task
    NSLog("Task Added")
    return if self.text_area.text.nil? or self.text_area.text.empty?
    task = Task.create(:name => self.text_area.text, :created_at => Time.now, :completed => false)
    self.tasks.unshift(task)

    self.task_list.reloadData
    self.text_area.text = ""
    NSLog("I am Called 2")
  end

  def add_task_list
    table_view = UITableView.alloc.initWithFrame(CGRectMake(0, 70, self.frame.size.width, 200))
    table_view.dataSource = self
    table_view.delegate = self
    table_view.clipsToBounds = false
    self.task_list = table_view
    self.addSubview table_view
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)

    @reuseIdentifier ||= "cell"
    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier)
    cell ||= UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier: @reuseIdentifier)


    cell.textLabel.text = "#{self.tasks[indexPath.row].name}"
    task = Task.find(:name, NSFEqualTo, cell.textLabel.text).first
    line = cell.viewWithTag(2)
    NSLog("I am Called 1#{!line.nil? and !task.completed}")
    line.removeFromSuperview if !line.nil? and !task.completed
    add_black_line(cell) if task.completed
    cell
  end

  def tableView(tableView, numberOfRowsInSection: section)
    self.tasks.count
  end

  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    tableView.deselectRowAtIndexPath(indexPath, animated: true)

    cell = tableView.cellForRowAtIndexPath(indexPath)
    self.mark_as_done(cell)
  end

  def mark_as_done cell
    task = Task.find(:name, NSFEqualTo, cell.textLabel.text).first
    return if task.completed

    task.completed = true

    task.save
    add_black_line(cell)

  end

  def add_black_line cell
    line = UILabel.alloc.init
    line.frame = [[0, (cell.frame.size.height/2)], [(cell.frame.size.width), 2]]
    line.tag = 2
    line.backgroundColor = UIColor.blackColor
    cell.addSubview(line)
  end
end
