class ClinicsListController < UIViewController
  

  attr_accessor :server_url


  def viewDidLoad

    @server_url = "https://raw.github.com/javadabadoo/clinicas-ile/master/external-resources"
    
    self.view.backgroundColor = UIColor.whiteColor
    
    @table = UITableView.alloc.initWithFrame(self.view.bounds, style: UITableViewStyleGrouped)
    @table.autoresizingMask = UIViewAutoresizingFlexibleHeight
    
    self.view.addSubview(@table)
    
    @table.dataSource = self
    @table.delegate = self
    
    getExternalInformation
    
  end
  
  
  
  def getExternalInformation
    
    @data = {}

    p "#{@server_url}/datos.json"
    
    BubbleWrap::HTTP.get("#{@server_url}/ile-clinics.json") do |response|
      json =  BubbleWrap::JSON.parse(response.body.to_s)

      json['clinic'].each do |clinic|
        @data[clinic['name'][0]] = [] if @data[clinic['name'][0]] == nil
        @data[clinic['name'][0]] << [clinic['name'].capitalize, clinic['id']]
      end
      
      @table.reloadData
    end
  end
  
  
  
  def tableView(tableView, numberOfRowsInSection: section)
    rows_for_section(section).count
  end
  
  
  
  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    @resourceIdentifier ||= "CELL_IDENTIFIER"
    
    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier)
    
    cell = UITableViewCell.alloc.initWithStyle(
      UITableViewCellStyleDefault,
      reuseIdentifier: @reuseIdentifier
    )
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
    
    cell ||= UITableViewCell.alloc.initWithStyle(
      UITableViewCellStyleDefault,
      reuseIdentifier:@reuseIdentifier
    )
    
    cell.textLabel.text = row_for_index_path(indexPath)[0]
    cell
  end
  
  
  
  def tableView(tableView, didSelectRowAtIndexPath: indexPath)
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    
    controller = UIViewController.alloc.initWithNibName(nil, bundle: nil)
    controller.view.backgroundColor = UIColor.whiteColor
    controller.title = "Detalle: #{row_for_index_path(indexPath)[0].to_s}"

    labels = {
      'name' => UILabel.alloc.initWithFrame([[10, 220], [controller.view.frame.size.width, 0]]),
      'address' => UILabel.alloc.initWithFrame([[10, 240], [controller.view.frame.size.width, 100]])
    }

    labels['name'].textColor = UIColor.blackColor
    labels['address'].textColor = UIColor.grayColor


    labels.each { |label, value|
      value.lineBreakMode = UILineBreakModeWordWrap
      value.numberOfLines = 0
      value.textAlignment = NSTextAlignmentLeft
    }


    BubbleWrap::HTTP.get("#{@server_url}/ile-clinics.json") do |response|
      json =  BubbleWrap::JSON.parse(response.body.to_s)

      clinic_information =  json['clinic'][row_for_index_path(indexPath)[1].to_i - 1]

      image_url =  clinic_information['picture'].nil? ? "#{@server_url}#{clinic_information['picture']}" :  "http://www.profem.com.mx/images/slideHome.jpg"

      data = NSData.dataWithContentsOfURL(NSURL.URLWithString(image_url))
      image = UIImageView.alloc.initWithFrame([[0, 35], [320, 199]])
      image.contentMode = UIViewContentModeScaleAspectFit
      image.image = UIImage.imageWithData(data)

      controller.view.addSubview(image)

      labels['name'].text = clinic_information['name']
      labels['address'].text = clinic_information['address']


      labels['name'].sizeToFit
      # clinic_address.sizeToFit
        
    end
    
    controller.view.addSubview(labels['name'])
    controller.view.addSubview(labels['address'])
    
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