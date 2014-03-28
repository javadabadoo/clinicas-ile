class JDDClinicsListController < UIViewController
  

  attr_accessor :server_url


  def viewDidLoad

    @server_url = "https://raw.github.com/javadabadoo/clinicas-ile/master/external-resources"
    
    self.view.backgroundColor = UIColor.whiteColor
    
    @table = UITableView.alloc.initWithFrame(self.view.bounds, style: UITableViewStyleGrouped)
    @table.autoresizingMask = UIViewAutoresizingFlexibleHeight
    
    self.view.addSubview(@table)
    
    @table.dataSource = self
    @table.delegate = self

    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent
    
    getExternalInformation
    
  end
  
  
  
  def getExternalInformation
    
    @data = {}
    
    BubbleWrap::HTTP.get("#{@server_url}/ile-clinics.json") do |response|
      json =  BubbleWrap::JSON.parse(response.body.to_s)

      json['clinic'].each do |clinic|
        @data[clinic['name'][0]] = [] if @data[clinic['name'][0]] == nil
        @data[clinic['name'][0]] << [clinic['name'].capitalize, clinic['id'], clinic['sector']]
      end
      
      @table.reloadData
    end
  end
  
  
  
  def tableView(tableView, numberOfRowsInSection: section)
    rows_for_section(section).count
  end
  
  
  
  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    @reuseIdentifier ||= "ILE_CLINICS_TABLE"
    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier)
    cell ||= UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier: @reuseIdentifier)

    clinicNameLabel = cell.contentView.subviews[0]
    clinicSectorLabel = cell.contentView.subviews[1]

    if clinicNameLabel == nil
      clinicNameLabel = UILabel.alloc.init
      clinicNameLabel.textAlignment = UITextAlignmentLeft
      clinicNameLabel.text = row_for_index_path(indexPath)[0]
      clinicNameLabel.frame = CGRectMake(cell.contentView.bounds.origin.x + 10, 5, cell.contentView.frame.size.width - 20, 25)
    end
    
    if clinicSectorLabel == nil
      clinicSectorLabel = UILabel.alloc.init
      clinicSectorLabel.textAlignment = UITextAlignmentLeft
      clinicSectorLabel.font = UIFont.systemFontOfSize(12)
      clinicSectorLabel.text = "Sector: #{row_for_index_path(indexPath)[2].to_s}"
      clinicSectorLabel.textColor = UIColor.grayColor
      clinicSectorLabel.frame = CGRectMake(cell.contentView.bounds.origin.x + 10, 25, 100, 15)
    end

    cell.contentView.addSubview(clinicNameLabel)
    cell.contentView.addSubview(clinicSectorLabel)

    cell
  end
  
  
  
  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    
    controller = ClinicDetailController.new (row_for_index_path(indexPath), @server_url)

    self.navigationController.pushViewController(controller, animated: true)
    
  end
  
  
  
  def tableView(tableView, titleForHeaderInSection: section)
    sections[section]
  end
  
  
  
  def sections
    @data.keys.sort
  end
  
  
  
  def rows_for_section(section_index)
    @data[self.sections[section_index]]
  end
  
  
  
  def row_for_index_path(index_path)
    rows_for_section(index_path.section)[index_path.row]
  end
  
  
  
  def numberOfSectionsInTableView(tableView)
    self.sections.count
  end
  
  
  
  def sectionIndexTitlesForTableView(tableView)
    sections
  end
  
  
  
  def tableView(tableView, sectionForSectionIndexTitle: title, atIndex: index)
    sections.index title
  end

end