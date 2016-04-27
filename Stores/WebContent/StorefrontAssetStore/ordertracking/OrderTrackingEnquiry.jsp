<%
//********************************************************************
//*
//* OrderTrackingEnquiry.jsp - page which prompts the user to
//* identify the order they wish to track
//*
//********************************************************************
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" %>
<% // All JSPs requires the first 4 packages for getResource.jsp which is used for multi language support %>
<head>
<Sample:workflow workflow="Sample_ORDER_TRACKING" workflowType="ORDER_TRACKING_ENQUIRY"/>	
	<meta http-equiv="Set-Cookie" content="<%="LastUrlCookie"%>=<c:out value="${returnURL}" />; path=/" />
	<jsp:useBean id="titleHelper" class="uk.co.Sample.ecommerce.common.utils.SampleTitleHelper"/>
	<c:set target="${titleHelper}" property="pageName" value="OrderTracking"/>
	<title><c:out value="${titleHelper.pageTitle}" /></title>
	<link rel="stylesheet" href="<c:out value="${fileDir}"/>base.css"type="text/css"/>
	<link rel="stylesheet" href="<c:out value="${imageDir}"/>p0/static.css"type="text/css"/>
	<link rel="stylesheet" href="<c:out value="${paletteDir}" />ordertracking.css"type="text/css"/>
	<script language="javascript" type="text/javascript" src="<c:out value="${imageDir}"/>nameAndAddressValidation.js"></script>
	<meta name="description" content="The official Sample catalogue website. UK catalogue shopping online for appliances, DIY, electronics, furniture, garden supplies, gifts, jewellery, sports goods, toys and watches." />
	<meta name="keywords" content="Sample, uk, catalogue, shop, home, shopping, stores, online, website, direct" />
	<script type="text/javascript" language="javascript" src="<c:out value="${imageDir}" />utils.js"></script>
	<script type="text/javascript" src="${siteAssets}js/customerServices/customerServices.js"></script>
	<script type="text/javascript">
	// <![CDATA[
		var sendForm=false;
		var autofill=false;
	
		function prepareSubmit(form) {
				
				if(!sendForm && !autofill ) validateBasicField(form.orderNumber,'order number');
				if(sendForm && !autofill ) validatePostcode(form.postcode);
				if(sendForm && !autofill ) validateOrderTrackingSurname(form.surname);
	
			return sendForm;
		}
		
		function validationError(field){
				
			highlightField(field);
			sendForm=false;
		}

	//]]>
	</script>
</head>
<body class="static ordertracking"> 
	<%@ include file="../include/header.jspf"%>  
	
	<script type="text/javascript">
	dojo.addOnLoad(function() {
		categoryDisplayJS.setCommonParameters('${WCParam.langId}','${WCParam.storeId}','${WCParam.catalogId}','${userType}');
		
		<fmt:message key="ERR_RESOLVING_SKU" bundle="${storeText}" var="ERR_RESOLVING_SKU" />
		<fmt:message key="QUANTITY_INPUT_ERROR" bundle="${storeText}" var="QUANTITY_INPUT_ERROR" />
		<fmt:message key="WISHLIST_ADDED" bundle="${storeText}" var="WISHLIST_ADDED" />
		<fmt:message key="SHOPCART_ADDED" bundle="${storeText}" var="SHOPCART_ADDED" />
		<fmt:message key="SHOPCART_REMOVEITEM" bundle="${storeText}" var="SHOPCART_REMOVEITEM" />
		<fmt:message key="ERROR_CONTRACT_EXPIRED_GOTO_ORDER" bundle="${storeText}" var="ERROR_CONTRACT_EXPIRED_GOTO_ORDER" />
		<fmt:message key="GENERICERR_MAINTEXT" bundle="${storeText}" var="ERROR_RETRIEVE_PRICE">                                     
			<fmt:param><fmt:message key="GENERICERR_CONTACT_US" bundle="${storeText}" /></fmt:param>
		</fmt:message>
		
		MessageHelper.setMessage("ERROR_RETRIEVE_PRICE", <wcf:json object="${ERROR_RETRIEVE_PRICE}"/>);
		MessageHelper.setMessage("ERR_RESOLVING_SKU", <wcf:json object="${ERR_RESOLVING_SKU}"/>);
		MessageHelper.setMessage("QUANTITY_INPUT_ERROR", <wcf:json object="${QUANTITY_INPUT_ERROR}"/>);
		MessageHelper.setMessage("WISHLIST_ADDED", <wcf:json object="${WISHLIST_ADDED}"/>);
		MessageHelper.setMessage("SHOPCART_ADDED", <wcf:json object="${SHOPCART_ADDED}"/>);
		MessageHelper.setMessage("SHOPCART_REMOVEITEM", <wcf:json object="${SHOPCART_REMOVEITEM}"/>);
		MessageHelper.setMessage("ERROR_CONTRACT_EXPIRED_GOTO_ORDER", <wcf:json object="${ERROR_CONTRACT_EXPIRED_GOTO_ORDER}"/>);
		
		ServicesDeclarationJS.setCommonParameters('${WCParam.langId}','${WCParam.storeId}','${WCParam.catalogId}');
	});
</script>
	<%--  2 of 2 needed for dojo auto suggest --%>
	<%@ include file="../Widgets/Search/ext/AutoSuggestJS.jspf"%>  
	
	<div id="staticPage"> 
	  <%@ include file="../include/lefthandsideCustomerServicesTwo.jspf" %> 
	  <fmt:message var="wismoText" bundle="${SampleText}" key="WISMO_WHERE_IS_MY_ORDER"/>
	  <div id="ordertrackingcontent">

	    <h1><c:out value="${wismoText}"/><span></span></h1> 

	    <form action="OrderTrackingEnquiry" method="post" class="ordertracking" id="ordertrackingentry" onsubmit="return prepareSubmit(this)"> 
	      <h2>View your order status</h2>
	      
			<wcbase:useBean id="errorBean" classname="com.ibm.commerce.beans.ErrorDataBean"/>
			
			<c:if test="${! empty errorBean && ! empty errorBean.messageKey}">
				<div class="error"><Sample:accounterror /></div>
			</c:if>

	      <fieldset class="formentry"> 
	      <label for="orderNumber">Order number: </label> 
	      <input type="text" class="regulartext" id="orderNumber" name="orderNumber" value="<c:out value="${respOrderNumber}"/>" maxlength="20" />
	      <br /> 
	      <label for="postcode">Billing postcode: </label> 
	      <input type="text" class="regulartext" id="postcode" name="postcode" value="<c:out value="${WCParam.respPostcode}"/>" maxlength="20" /> 
	      <br /> 
	      <label for="surname">Surname: </label> 
	      <input type="text" class="regulartext" id="surname" name="surname" value="<c:out value="${WCParam.respSurname}"/>" maxlength="40" /> 
	      <input type="image" value="view order" src="<c:out value="${imageDir}" />p8/b_view_order.gif" class="vieworder"/> 
	      </fieldset> 
	      <input type="hidden" name="authToken" value="${authToken}" id="authtoken_1"/>
	    </form>
		    </div>	    

	<%-- SiteCatalyst tags --%>
	<c:set target="${siteCatalystHashtable}" property="area" value="registration"/>
	<c:set target="${siteCatalystHashtable}" property="flow" value="wismo"/>
	<c:set target="${siteCatalystHashtable}" property="page" value="login"/>
	<c:if test="${not empty REG_ERROR_MSG}">
		<c:set target="${siteCatalystHashtable}" property="page" value="login:errorpage"/>
		<c:set target="${siteCatalystHashtable}" property="s.prop6" value="${REG_ERROR_MSG}"/>
	</c:if>
	<c:set target="${siteCatalystHelper}" property="siteCatalystHashtable" value="${siteCatalystHashtable}"/>
	<%-- End SiteCatalyst tags --%>
	  
	</div> 
	<%@ include file="../include/footerSingle.jspf"%> 
</body>
</html>
