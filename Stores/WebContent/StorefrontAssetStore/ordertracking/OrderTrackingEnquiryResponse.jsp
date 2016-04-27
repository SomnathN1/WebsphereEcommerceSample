<%
//********************************************************************
//*
//* OrderTrackingEnquiryResponse.jsp - page which displays the status
//* of an order
//*
//********************************************************************
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" %>
<% // All JSPs requires the first 4 packages for getResource.jsp which is used for multi language support %>
<Sample:workflow workflow="Sample_ORDER_TRACKING" workflowType="ORDER_TRACKING_ENQUIRY_RESPONSE"/>	
<head>
	<jsp:useBean id="titleHelper" class="uk.co.Sample.ecommerce.common.utils.SampleTitleHelper"/>
	<c:set target="${titleHelper}" property="pageName" value="OrderTracking"/>
	<title><c:out value="${titleHelper.pageTitle}" /></title>
	<link rel="stylesheet" href="<c:out value="${fileDir}"/>base.css" type="text/css"/>
	<link rel="stylesheet" href="<c:out value="${imageDir}"/>p0/static.css" type="text/css"/>
	<link rel="stylesheet" href="<c:out value="${paletteDir}" />ordertracking.css" type="text/css"/>
	<script language="javascript" type="text/javascript" src="<c:out value="${imageDir}"/>nameAndAddressValidation.js"></script>
	<script language="javascript" type="text/javascript" src="<c:out value="${imageDir}"/>js/showhideswitch.js"></script>
	<meta name="description" content="The official Sample catalogue website. UK catalogue shopping online for appliances, DIY, electronics, furniture, garden supplies, gifts, jewellery, sports goods, toys and watches." />
	<meta name="keywords" content="Sample, uk, catalogue, shop, home, shopping, stores, online, website, direct" />
	<script type="text/javascript" language="javascript" src="<c:out value="${imageDir}" />utils.js"></script>
	<script type="text/javascript">
		// <![CDATA[
		//]]>
	</script>
</head>
<body class="static ordertracking"> 
	<%@ include file="../include/header.jspf"%> 
	
	<div id="staticPage"> 
	  <%@ include file="../include/lefthandsideCustomerServicesTwo.jspf" %> 
	  <fmt:message var="wismoText" bundle="${SampleText}" key="WISMO_WHERE_IS_MY_ORDER"/>
	  <div id="ordertrackingcontent">
	 
<h1><c:out value="${wismoText}"/><span></span></h1>
<div id="orderheader">
	<p class="ordernumber"><span class="ordersummary">Order summary for:</span><span class="summarydata"><c:out value="${OrderStatus.orderNumber}"/></span></p>
	<form action="OrderTracking" name="viewanotherorder" id="viewanotherorder" method="post">
		<fieldset> 
			<input type="image" value="view another order" src="<c:out value="${imageDir}" />p8/wismo_view_another_order.gif" class="viewanotherorder"/> 
	    	<input type="hidden" value="<c:out value="${respPostcode}"/>" name="respPostcode"/>
	    	<input type="hidden" value="<c:out value="${respSurname}"/>" name="respSurname"/>
		</fieldset>
		<input type="hidden" name="authToken" value="${authToken}" id="authtoken_1"/>
	</form> 
	<p><span class="ordersummary">Your order was placed on:</span><span class="summarydata"><c:out value="${OrderStatus.dateOrderPlaced}"/> (<c:out value="${OrderStatus.orderChannel}"/>)</span></p>
	<p><span class="ordersummary">Delivery method:</span><span class="summarydata"><c:out value="${OrderStatus.deliveryMethod}"/></span></p>

</div>



<table id="orderdetails">
	<tr>
		<th class="empty"></th>
		<th class="catno">Cat No.</th>
		<th class="trackingProduct">Product</th>
		<th class="quantity">Qty</th>
		<th class="price">Price</th>
		<th class="emptyexpand"></th>
		<th class="status">Status</th>
	</tr>
	
	<Sample:getPropertyAsString propertyName="DELIVERY_CHARGE_STANDARD_PARTNUMBER" varName="standardId" storeId="${storeId}" defaultValue="" />
	<Sample:getPropertyAsString propertyName="DELIVERY_CHARGE_FREE_PARTNUMBER" varName="freeStandardId" storeId="${storeId}" defaultValue="" />
	<Sample:getPropertyAsString propertyName="DELIVERY_CHARGE_NEXT_DAY_PARTNUMBER" varName="nextDayId" storeId="${storeId}" defaultValue="" />
	<Sample:getPropertyAsString propertyName="DELIVERY_CHARGE_FREE_NEXT_DAY_PARTNUMBER" varName="freeNextDayId" storeId="${storeId}" defaultValue="" />
	<Sample:getPropertyAsString propertyName="DELIVERY_CHARGE_SAT_MORNING_PARTNUMBER" varName="satMorningId" storeId="${storeId}" defaultValue="" />
	<Sample:getPropertyAsString propertyName="DELIVERY_CHARGE_FREE_SAT_MORNING_PARTNUMBER" varName="freeSatMorningId" storeId="${storeId}" defaultValue="" />

	<c:set var="invalidProductName" value="Product Description not available" />
	
	<c:forEach items="${OrderStatus.orderStatusGroups}" var="statusGroup" varStatus="groupStatus">
		
		<c:set var="nextStatus" value="0" />
		
		<%
			java.util.List lines = ((uk.co.Sample.ecommerce.ordertracking.view.SampleOrderTrackingStatusGroup) pageContext.getAttribute("statusGroup")).getOrderTrackingLines();
			pageContext.setAttribute("linesSize", Integer.toString(lines.size()));
		%>

		<c:forEach items="${statusGroup.orderTrackingLines}" var="orderLine" varStatus="status">
			
			<tr <c:if test="${status.last}">rel="orderpart<c:out value="${groupStatus.index}"/>" class="lastitem"</c:if> >
				<td class="empty" height="30"></td>
				<td class="catno" height="30"><Sample:formatPartNumber partNumber="${orderLine.catNo}"/></td>
				<td class="trackingProduct" height="30">
					
					
					<c:choose>
						<%-- If the product is a delivery charge or the product name is invalid, do not create a link --%>
						<c:when test="${orderLine.catNo == standardId || orderLine.catNo == freeStandardId 
										|| orderLine.catNo == nextDayId || orderLine.catNo == freeNextDayId
										|| orderLine.catNo == satMorningId || orderLine.catNo == freeSatMorningId
										|| orderLine.productName == invalidProductName}">
										
							<c:out value="${orderLine.productName}" escapeXml="false"/>
						</c:when>
						<c:otherwise>
							<a href="<Sample:optimiseProductURL partNumber="${orderLine.catNo}" />">
								<c:out value="${orderLine.productName}" escapeXml="false"/>
							</a>						
						</c:otherwise>
					</c:choose>

				</td>
				<td class="quantity" height="30"><c:out value="${orderLine.orderedQuantity}"/></td>
				<td class="price" height="30"><c:out value="${orderLine.linePrice}" escapeXml="false"/></td>
				<td class="emptyexpand"></td>
				<c:if test="${status.index == nextStatus}">
					<%-- We only output one 'status' cell for each 'group' of orderLines with the same status --%>
					<%-- Backend TODO: We need to bold up the datae and time data in the status message also. Can this be wrapped in a <span>xxxx</span> please!  --%>
					
					<c:set var="nextStatus" value="${nextStatus + orderLine.numLinesSharingStatus}" /> 
					
					<c:set var="rowspanLength" value="${orderLine.numLinesSharingStatus}" />
					<c:set var="classValue" value="status" />
					
					<c:if test="${nextStatus == linesSize}">
						<c:set var="rowspanLength" value="${orderLine.numLinesSharingStatus + 1}" />
						<c:set var="classValue" value="status laststatus" />
					</c:if>
					
					<td rel="orderpart<c:out value="${groupStatus.index}"/>" class="<c:out value="${classValue}"/>" rowspan="<c:out value="${rowspanLength}"/>"><c:out value="${orderLine.statusMessage}" escapeXml="false"/></td>
					
				</c:if>
			</tr>
			
		</c:forEach>
		
		<tr rel="orderpart<c:out value="${groupStatus.index}"/>">
			<td  class="orderpartdetails" colspan="6">
			
				<c:if test="${not empty statusGroup.deliveryAddress}" >
					<div class="orderpartdetailsdata">
						<p><span class="deliverysummary">Name:</span> <span class="summarydata"><c:out value="${statusGroup.deliveryName}"/></span></p>
						<p><span class="deliverysummary">Delivery address:</span> <span class="summarydata"><c:out value="${statusGroup.deliveryAddress}"/>.</span></p>
						<p><span class="deliverysummary">Contact number:</span> <span class="summarydata"><c:out value="${statusGroup.contactPhoneNumbers}"/></span></p>
						
						<c:if test="${not empty statusGroup.deliveryInstructions}" >
							<p><span class="deliverysummary">Delivery Instruction:</span> <span class="summarydata"><c:out value="${statusGroup.deliveryInstructions}"/></span></p>
						</c:if>
					</div>
					<script type/text="javascript">
					//	jQuery("div.orderpartdetailsdata").css({display:"none"});
					</script>
				</c:if>
				
			</td>
		</tr>
	
	</c:forEach>
	
	<tr class="totalrow">
		<td class="totaltext" colspan="4"><p class="additionaltext">Total shown may not include any discount vouchers used when you paid for your order</p>Total:</td>
		<td class="totalprice" class="price"><c:out value="${OrderStatus.orderTotalPrice}" escapeXml="false"/></td>
		<td class="emptyexpand"></td>
		<td class="empty"></td>
	</tr>
	
</table>

 
	  </div> 

	<%-- SiteCatalyst tags --%>
	<c:set target="${siteCatalystHashtable}" property="area" value="registration"/>
	<c:set target="${siteCatalystHashtable}" property="flow" value="wismo"/>
	<c:set target="${siteCatalystHashtable}" property="page" value="orderdetail"/>

	<c:set target="${siteCatalystHelper}" property="siteCatalystHashtable" value="${siteCatalystHashtable}"/>
	<%-- End SiteCatalyst tags --%>

	  
	</div> 
	<%@ include file="../include/footerSingle.jspf"%> 
	
	
	<script type/text="javascript">
	
	function prepareLoginRequest(eventSrc){
		// Need to create a value that can be checked when a user has logged in.
		if (eventSrc == "loginLink") {
			return "&loginReturnAction=redirectToOrderTracking";
		}
	}
		
	function processLoginResponse(json){
		// Once a user has been logged in, we need to redirect them to the OrderTrackingEnquiry page.
		if (json.loginReturnAction == "redirectToOrderTracking") {
			document.viewanotherorder.submit();
		}
	}
	
	jQuery(document).ready(function(){
	
		var SampleOrderPartDetailsShowHide = new(function(){
			
			//toggle text values
			var toggleShowLinkText = "+ see full order details";
			var toggleHideLinkText = "- hide full order details";
			
			//target containers
			var toggleContainers = jQuery("tr.lastitem td.trackingProduct"); 
			var toggleDisplayContainers = jQuery("td.orderpartdetails"); 
			var toggleDisplayPanels = "div.orderpartdetailsdata";
			
			//toggle markup
			var toggleHTML = "<p class=\"orderpartdetailslink\"><a href=\"#\" class=\"showhidelink\"></a></p>";
			
			//loop through page for containers
			for(var i = 0; i<toggleContainers.length;i++ ) {	
			
				//insert toggle
				jQuery(toggleContainers[i]).append(toggleHTML);	
				
				//create key objects
				var toggleLink = jQuery(toggleContainers[i]).find("a.showhidelink")[0];
				var toggleDisplay = jQuery(toggleDisplayContainers[i]).find(toggleDisplayPanels)[0];
				
				//defensive
				if (toggleLink != null && toggleDisplay !=null) {
					new Sample.showhide.showhideswitch.toggleswitch(toggleLink,toggleDisplay,{
						//options
						toggleShowLinkText: toggleShowLinkText,
						toggleHideLinkText: toggleHideLinkText, 
						toggleActive: false
					});
					
				}
			}
		});	
		
		
	});
	</script>
</body>
</html>
