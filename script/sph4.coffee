imageArray =
[
	{
		"src":"./Images/sph4.svg",
		"id":"0"
	},
	{
		"src":"./Images/bsph4.svg",
		"id":"1"
	},
	{
		"src":"./Images/oct3.svg",
		"id":"2"
	},
	{
		"src":"./Images/sphi4.svg",
		"id":"3"
	},
	{
		"src":"./Images/rib.svg",
		"id":"4"
	},
	{
		"src":"./Images/carfilm.svg",
		"id":"5"
	},
	{
		"src":"./Images/em4.svg",
		"id":"6"
	}
]

random = Math.round( Math.random() *6)
imageName = imageArray[random].src #change 0 to 'random' for random images.
jsonPath = (imageName.substring(9)).replace("svg","JSON")
imageJSON = (imageName.substring(9)).replace("svg","JSON")
crossBtn = $(".CloseBtn")
$(".Composition_image").attr("src", imageName)

loadJSON = () ->
	xobj = new XMLHttpRequest();
	xobj.overrideMimeType("application/json");
	#xobj.open('GET', '/Users/kuma138/Desktop/Composition Practice/JSON/'+imageJSON, true);
	xobj.open('GET', '/Composition Practice/JSON/' + imageJSON, true);
	#xobj.open('GET', '/Users/kuma138/Desktop/Assignments/Composition Practice/JSON/' + imageJSON, true);
	xobj.onreadystatechange = () ->
		if xobj.readyState == 4 && xobj.status == 200
			CompositionData = xobj.responseText
			drawPoints(CompositionData)
			drawLines(CompositionData)
	xobj.send(null);

drawPoints = (JSONfile) ->
	data = JSON.parse(JSONfile)
	for components in data
		xPoint = components.x
		yPoint = components.y
		link = document.createElement('a')
		link.className = "Composition_pivot"
		link.setAttribute("style", "top:"+yPoint+"px;left:"+xPoint+"px;")
		pivotPointNo = document.createAttribute("pivotPointNo")
		pivotPointNo.value = components.pivotOrderNum
		link.setAttributeNode(pivotPointNo)
		document.getElementById("composition").appendChild(link)


drawLines = (JSONfile) ->
	canvas = document.getElementById("canvas")
	#console.log($(document).width())
	if $(document).width() > 400
		canvas.width = 500
		canvas.height = 300
	else
		canvas.width = 300
		canvas.height = 300

	ctx = canvas.getContext("2d")
	data = JSON.parse(JSONfile)
	ctx.beginPath()
	for points in data
		xPoint = points.x + 5
		yPoint = points.y + 5
		ctx.moveTo(xPoint , yPoint)
		if data.length > 1
			ctx.lineTo(250 ,  (points.id + 1)* 40)
		ctx.lineTo(300, (points.id + 1)* 40)
		fillPivotDetails(points.id + 1 , points.displayName)
		ComponentDetails(points.id + 1 , points.displayName, [points.itemType ,points.formula ,points.role])
	ctx.stroke()

fillPivotDetails = (pivotPointNo,pivotPointTitle) ->
	#create li
	listItem = document.createElement("li")
	listItem.className = "PivotList_item"

	#create anchor
	listItemLink = document.createElement("a")
	listItemLink.className = "PivotList_link"

	#add anchor to newly created list
	listItem.appendChild(listItemLink)

	#create span for mobile , desktop and title
	mobileCircle = document.createElement("span")
	mobileCircle.className = "PivotCount_MobileCount"
	mobileCircle.innerText = pivotPointNo


	desktopTitle = document.createElement("span")
	desktopTitle.className = "PivotCount_Title"
	#desktopTitle.innerText  = pivotPointTitle

	desktopCircle = document.createElement("span")
	desktopCircle.className = "PivotCount_DesktopCircle"

	#add all span to anchor
	listItemLink.appendChild(mobileCircle)
	listItemLink.appendChild(desktopTitle)
	listItemLink.appendChild(desktopCircle)

	#add all elements to 'ul'
	document.getElementById("PivotPointList").appendChild(listItem)
	#ComponentDetails(pivotPointNo , pivotPointTitle)

ComponentDetails = (id , name, properties) ->
	#create top div class="components_details Component--disable"
	componentDetails = document.createElement("div")
	# componentDetails.className = "components_details components_details--disable"
	componentDetails.className = "components_details"

	#create circle class="greyCircle"
	greyCircle = document.createElement("span")
	greyCircle.className = "greyCircle"
	greyCircle.innerText = id

	#create div class="Component_header"
	componentHeader = document.createElement("div")
	componentHeader.className = "Component_header"

	#add close button
	#create h3 -- attach it to	class="Component_header"
	headerValue= "<h3><span>"+name+"</span></h3> <a class='CloseBtn'>"
	componentHeader.innerHTML = headerValue

	componentDetails.appendChild(componentHeader)
	componentDetails.appendChild(greyCircle)



	#create div class="Component_bodyWrapper"
	componentBodyWrapper = document.createElement("div")
	componentBodyWrapper.className = "Component_bodyWrapper"

	propName = ["Type" , "Formula" , "Role"]


	for i in [0..2]
		if properties[i] == null
			properties[i] = "-"

		#create block for every property
		componentProperty = document.createElement("div")
		componentProperty.className = "Component_property Property"

		#Add property Names and values
		propertyName = document.createElement("strong")
		propertyName.className = "Property_name"
		propertyName.innerText = propName[i]
		componentProperty.appendChild(propertyName)

		propertyValue = document.createElement("span")
		propertyValue.className = "Property_value"
		propertyValue.innerHTML = properties[i]
		componentProperty.appendChild(propertyValue)

		componentBodyWrapper.appendChild(componentProperty)

	componentDetails.appendChild(componentBodyWrapper)
	document.getElementById("components").appendChild(componentDetails)

$('.Components').on 'click' ,".CloseBtn" , (e) ->
	$(e.target).parents(".components_details").removeClass("active")
	$(e.target).parents(".components_details").children(".greyCircle").removeClass("active")
	enablePivotPoint(parseInt($(e.target).parents(".components_details").children(".greyCircle").text()))

$('.Components').on 'click' , ".Component_header h3" , ".greyCircle" ,(el) ->
	componentNodes = document.getElementsByClassName("components_details");
	element = $(el.target)
	pivotPointNo = element.parents(".components_details").children(".greyCircle")
	element.parents(".components_details").toggleClass("active")
	$(pivotPointNo).toggleClass("active")

	for element in componentNodes
		if $(element).hasClass("active") and $(element).children("span.greyCircle").text() != $(pivotPointNo).text()
			$(element).children("span.greyCircle").removeClass("active")
			$(element).removeClass("active")

	enablePivotPoint(parseInt(pivotPointNo.text()))

enablePivotPoint = (pivotpointNumber)->
	console.log("here")
	pivotList = $(".PivotList_item")
	for pivotPoint in pivotList.children(".PivotList_link")
		if parseInt(pivotPoint.text) == pivotpointNumber
			$(pivotPoint).toggleClass("active")
		else
			$(pivotPoint).removeClass("active")


$(document).ready ->
	loadJSON()
