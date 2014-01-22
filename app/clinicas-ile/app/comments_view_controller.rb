class JDDCommentsViewController < UIViewController


  attr_accessor :server_url



	def viewDidLoad
		super

    	@server_url = "https://raw.github.com/javadabadoo/clinicas-ile/master/external-resources"

		self.title = "Comments"
		self.view.backgroundColor = UIColor.grayColor

		@table = UITableView.alloc.initWithFrame(
			[
				[0, 0],
				[self.view.frame.size.width, self.view.frame.size.height]
			]
		)

		@table.autoresizingMask = UIViewAutoresizingFlexibleHeight
		self.view.addSubview(@table)

		@table.dataSource = self
		@table.delegate = self

		getExternalInformation
	end




	def getExternalInformation

		@data = []

		BubbleWrap::HTTP.get("#{@server_url}/clinic-commens.json") do |response|
			json =  BubbleWrap::JSON.parse(response.body.to_s)

			json['comments'].each do |comment|
			@data << [comment['title'].capitalize, comment['text'].capitalize, comment['user']]
		end

		@table.reloadData
		end
	end



	def tableView(tableView, numberOfRowsInSection: section)
		@data.count
	end



	def tableView(tableView, cellForRowAtIndexPath: indexPath)
		@reuseIdentifier ||= "ILE_CLINICS_COMMENTS"
		cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier)
		cell ||= JDDCommentCellView.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier: @reuseIdentifier)

		if (!cell.hasViews)
			cell.frame = [[0, 0], [320, 90]]
			cell.set_information(@data[indexPath.row][0], @data[indexPath.row][1], @data[indexPath.row][2])
		end

		cell
	end



	def tableView(tableView, heightForRowAtIndexPath: indexPath)
		80
	end


end