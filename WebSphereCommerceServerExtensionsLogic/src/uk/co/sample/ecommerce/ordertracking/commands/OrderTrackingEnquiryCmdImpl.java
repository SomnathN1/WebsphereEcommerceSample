package uk.co.Sample.ecommerce.ordertracking.commands;
import java.util.logging.Level;
import java.util.logging.Logger;

import uk.co.Sample.ecommerce.common.classes.SamplePostcode;
import uk.co.Sample.ecommerce.common.classes.OrderNumberValidationHelper;
import uk.co.Sample.ecommerce.common.utils.SampleConstants;
import uk.co.Sample.ecommerce.common.utils.SampleMessage;
import uk.co.Sample.ecommerce.common.utils.SampleStringHelper;
import uk.co.Sample.ecommerce.messaging.commands.ordertracking.CustomerOrderEnquiryMsgCmd;
import uk.co.Sample.ecommerce.messaging.databean.ordertracking.CustomerOrderEnquiryResponseData;
import uk.co.Sample.ecommerce.ordertracking.view.SampleOrderTrackingView;
import uk.co.Sample.ecommerce.ordertracking.view.SampleOrderTrackingViewBuilder;

import com.ibm.commerce.command.CommandFactory;
import com.ibm.commerce.command.ControllerCommandImpl;
import com.ibm.commerce.datatype.TypedProperty;
import com.ibm.commerce.exception.ECApplicationException;
import com.ibm.commerce.exception.ECException;
import com.ibm.commerce.exception.ECSystemException;
import com.ibm.commerce.server.ECConstants;

/**
 * Controller Command - validates that the order details a user has entered are correct
 * before performing a query to the bank end to retrieve the order's delivery status.
 * 
 * @author <a href="ljensen@salmon.com">Lars Jensen</a>
 * @version $Revision: 1.5 $
 */
public class OrderTrackingEnquiryCmdImpl extends ControllerCommandImpl implements OrderTrackingEnquiryCmd {

	private static final String CLASSNAME = ControllerCommandImpl.class.getName();
	private static final Logger LOGGER = Logger.getLogger(CLASSNAME);

    
    private static final String ERROR_VIEW = "SampleOrderTrackingEnquiryView";
    
    private String orderNumber;
    private String postcode;
    private String surname;
    
    public void validateParameters() throws com.ibm.commerce.exception.ECException {
        String methodName = "validateParameters";
        LOGGER.entering(this.getClass().getName(), methodName);

        TypedProperty request = getRequestProperties();

        //Get request params
        if (request != null) {
            setOrderNumber(request.getString("orderNumber").trim());
            setPostcode(request.getString("postcode").trim());
            setSurname(request.getString("surname").trim());
        }

        //Initialise response properties as empty
        if (getResponseProperties() == null) {
            TypedProperty responseProperties = new TypedProperty();
            setResponseProperties(responseProperties);
        }

        //Validate Order Number
        OrderNumberValidationHelper ov = new OrderNumberValidationHelper(orderNumber);
        boolean orderNumberValid = ov.validate();
        if (!orderNumberValid) {
            
            if (SampleMessage._ERR_ORDERNUMBER_FORMAT.equals(ov.getErrorMessage())) {
                throw new ECApplicationException(SampleMessage.ORDERTRACKING_MESSAGING_INVALID, this.getClass().getName(), methodName, ERROR_VIEW);                
            } else {
                throw new ECApplicationException(ov.getErrorMessage(), this.getClass().getName(), methodName, ERROR_VIEW);    
            }
        }
        
        //Validate Postcode
        SamplePostcode postCodeValidator = new SamplePostcode(postcode);
        boolean postcodeValid = postCodeValidator.validateFull();
        if (!postcodeValid) {
            throw new ECApplicationException(postCodeValidator.getErrorMessage(), this.getClass().getName(), methodName, ERROR_VIEW);
        }
        
        //Validate Surname
        if (surname == null || surname.trim().length() == 0) {
            throw new ECApplicationException(SampleMessage._ERR_SURNAME_MISSING, this.getClass().getName(), methodName, ERROR_VIEW);
        } else if (! SampleStringHelper.validateString(surname, null, SampleConstants.VALID_SURNAME_SPECIAL_CHARS) ) {
            throw new ECApplicationException(SampleMessage._ERR_SURNAME_INVALID, this.getClass().getName(), methodName, ERROR_VIEW);            
        }


        LOGGER.exiting(this.getClass().getName(), methodName);
    }


    public void performExecute() throws ECException {
        String methodName = "performExecute";
        LOGGER.entering(this.getClass().getName(), methodName);

        CustomerOrderEnquiryResponseData data;    
        try {
            data = performMessaging();
            if (data == null) {
                displayOrderTrackingErrorPage();
                return;
            }
        } catch (ECException e) {
            LOGGER.logp(Level.SEVERE, this.getClass().getName(), methodName, e.getMessage(), e);
            displayOrderTrackingErrorPage();
            return;
        }
                
        // Redisplay WISMO enquiry form page if the order number enquiryStatus message 
        // response is anything other than "OK", which implies the order number is
        // unknown. 
        if( !CustomerOrderEnquiryMsgCmd.STATUS_OK.equalsIgnoreCase( data.getEnquiryStatus() ) ) {
            
            if (CustomerOrderEnquiryMsgCmd.STATUS_INVALID_ORDER.equalsIgnoreCase( data.getEnquiryStatus() )) {
                
                throw new ECApplicationException(SampleMessage.ORDERTRACKING_MESSAGING_INVALID, this.getClass().getName(), methodName, ERROR_VIEW, getResponseProperties() );
                
            } else if (CustomerOrderEnquiryMsgCmd.STATUS_UNKNOWN_ORDER.equalsIgnoreCase( data.getEnquiryStatus() )) {
                
                throw new ECApplicationException(SampleMessage.ORDERTRACKING_MESSAGING_UNKNOWN, this.getClass().getName(), methodName, ERROR_VIEW, getResponseProperties() );
                
            } else {
                throw new ECApplicationException(SampleMessage.ORDERTRACKING_MESSAGING_FAULT, this.getClass().getName(), methodName, ERROR_VIEW, getResponseProperties() );
            }
            
        } else {
            
            // Need to validate the order returned matches the data requested (Postcode & Surname)
            if (getPostcode() == null || getSurname() == null ||
                !SampleStringHelper.removeSpaces(getPostcode()).equalsIgnoreCase(SampleStringHelper.removeSpaces(data.getDeliveryAddressPostcode())) ||
                !getSurname().equalsIgnoreCase(data.getDeliveryNameLast())) {

                throw new ECApplicationException(SampleMessage.ORDERTRACKING_MESSAGING_INVALID, this.getClass().getName(), methodName, ERROR_VIEW, getResponseProperties() );

            } else {
                getResponseProperties().put( "respPostcode", getPostcode() );
                getResponseProperties().put( "respSurname", getSurname() );    
            }
        }
        
        
        SampleOrderTrackingViewBuilder viewBuilder = new SampleOrderTrackingViewBuilder();
        SampleOrderTrackingView view = viewBuilder.build(data, getCommandContext());
        getResponseProperties().put("OrderStatus", view);

        redirectToOrderTrackingResponsePage();

        LOGGER.exiting(this.getClass().getName(), methodName);
    }

    /** Executes CustomerOrderEnquiryMsgCmd */
    protected CustomerOrderEnquiryResponseData performMessaging() throws ECException {
        CustomerOrderEnquiryMsgCmd msgCmd =
                (CustomerOrderEnquiryMsgCmd)
                CommandFactory.createCommand(CustomerOrderEnquiryMsgCmd.NAME, getStoreId());
            
        msgCmd.setCommandContext(getCommandContext());
        msgCmd.setRequestProperties(commandContext.getRequestProperties());
            
        msgCmd.setSampleOrderNumber(orderNumber);
        msgCmd.execute();
            
        return msgCmd.getResponseData();
    }
    
    /** Creates and stores a view of the response data for display on the JSP */
    protected void storeResponseView(CustomerOrderEnquiryResponseData data) {
        
    }

    /** Redirect the browser to the Order Tracking Response view. */
    protected void redirectToOrderTrackingResponsePage() throws ECSystemException, ECException {
        getResponseProperties().put(ECConstants.EC_VIEWTASKNAME, "SampleOrderTrackingEnquiryResponseView");
        
        // Add this property to override the returnURL once the user has signed in. (JS Off)
        getResponseProperties().put("signInReturnURLOverride", "OrderTracking?storeId=10001&langId=-1");
    }

    /** Redirect the browser to the Order Tracking Error view. */
    protected void displayOrderTrackingErrorPage() throws ECSystemException, ECException {
        getResponseProperties().put(ECConstants.EC_ERROR_CODE, SampleMessage.ORDERTRACKING_MESSAGING_ERROR);
        getResponseProperties().put(ECConstants.EC_VIEWTASKNAME, "SampleOrderTrackingEnquiryErrorView");
    }
    
    
    public String getOrderNumber() {
        return orderNumber;
    }
    public void setOrderNumber(String string) {
        orderNumber = string;
    }
    public String getPostcode() {
        return postcode;
    }
    public String getSurname() {
        return surname;
    }
    public void setPostcode(String string) {
        postcode = string;
    }
    public void setSurname(String string) {
        surname = string;
    }

}
