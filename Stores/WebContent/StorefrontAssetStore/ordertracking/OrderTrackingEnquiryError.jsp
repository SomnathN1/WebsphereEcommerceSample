<%
//********************************************************************
//*
//* OrderTrackingEnquiryError.jsp - page which displays an error
//* message to the user
//*
//********************************************************************
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" %>
<% // All JSPs requires the first 4 packages for getResource.jsp which is used for multi language support %>
<%@ page import="com.sample.ecommerce.common.utils.*" %>
<%@ page import="com.sample.ecommerce.browsing.beans.*" %>
<%@ page import="com.ibm.hursley.commerce.pa.*" %>
<%@ page import="com.sample.ecommerce.browse.databean.*" %>
<%@ taglib uri="/WEB-INF/Sample.tld" prefix="Sample" %>
<head>
<%@ include file="../include/getResource.jspf"%>
<Sample:workflow workflow="Sample_ORDER_TRACKING" workflowType="ORDER_TRACKING_ENQUIRY_ERROR"/>	
	<jsp:useBean id="titleHelper" class="com.sample.ecommerce.common.utils.SampleTitleHelper"/>
	<c:set target="${titleHelper}" property="pageName" value="OrderTracking"/>
	<title><c:out value="${titleHelper.pageTitle}" /></title>
	<link rel="stylesheet" href="<c:out value="${fileDir}"/>base.css"type="text/css"/>
	<link rel="stylesheet" href="<c:out value="${imageDir}"/>p0/static.css"type="text/css"/>
	<link rel="stylesheet" href="<c:out value="${paletteDir}" />ordertracking.css"type="text/css"/>
	<script language="javascript" type="text/javascript" src="<c:out value="${imageDir}"/>nameAndAddressValidation.js"></script>
	<meta name="description" content="The official Sample catalogue website. UK catalogue shopping online for appliances, DIY, electronics, furniture, garden supplies, gifts, jewellery, sports goods, toys and watches." />
	<meta name="keywords" content="Sample, uk, catalogue, shop, home, shopping, stores, online, website, direct" />
	<% response.addHeader(com.sample.ecommerce.common.utils.SampleConstants.CUSTOM_HTTP_ERROR_HEADER_NAME, com.sample.ecommerce.common.utils.SampleConstants.CUSTOM_HTTP_ERROR_HEADER_VALUE); %>
	<script type="text/javascript" language="javascript" src="<c:out value="${imageDir}" />utils.js"></script>
</head>
<body class="static ordertracking"> 
	<%@ include file="../include/header.jspf"%> 
	<div id="staticPage"> 
	  <%@ include file="../include/lefthandsideCustomerServicesTwo.jspf" %> 
	  <fmt:message var="wismoText" bundle="${SampleText}" key="WISMO_WHERE_IS_MY_ORDER"/>
	  <div id="ordertrackingcontent">
	
	    <h1><c:out value="${wismoText}"/><span></span></h1> 

		<div class="error"><Sample:accounterror /></div>

	  </div> 
	  
	  <%-- SiteCatalyst tags --%>
	  <c:set target="${siteCatalystHashtable}" property="area" value="registration"/>
	  <c:set target="${siteCatalystHashtable}" property="flow" value="wismo"/>
  	  <c:set target="${siteCatalystHashtable}" property="page" value="login:errorpage"/>
	  <c:set target="${siteCatalystHashtable}" property="s.prop6" value="${REG_ERROR_MSG}"/>
  	  
  	  <c:set target="${siteCatalystHelper}" property="siteCatalystHashtable" value="${siteCatalystHashtable}"/>
	  <%-- End SiteCatalyst tags --%>
	  
	</div> 
	<%@ include file="../include/footerSingle.jspf"%> 
</body>
</html>

