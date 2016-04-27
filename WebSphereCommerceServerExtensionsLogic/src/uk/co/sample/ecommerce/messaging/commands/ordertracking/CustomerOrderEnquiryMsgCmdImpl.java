package uk.co.Sample.ecommerce.messaging.commands.ordertracking;
import java.util.logging.Level;
import java.util.logging.Logger;

import uk.co.Sample.ecommerce.common.utils.SampleConstants;
import uk.co.Sample.ecommerce.common.utils.SampleViewNames;
import uk.co.Sample.ecommerce.messaging.commands.impl.SampleBaseMsgCmdImpl;
import uk.co.Sample.ecommerce.messaging.databean.ordertracking.CustomerOrderEnquiryResponseData;
import uk.co.Sample.ecommerce.messaging.parsers.ordertracking.CustomerOrderEnquiryResponseHandler;
import uk.co.Sample.ecommerce.messaging.utils.XMLMsgParsingException;

import com.ibm.commerce.datatype.TypedProperty;
import com.ibm.commerce.exception.ECApplicationException;
import com.ibm.commerce.exception.ECException;
import com.ibm.commerce.ras.ECMessage;
import com.ibm.commerce.ras.ECMessageHelper;

/**
 * Generates an outgoing Order Status Enquiry message.
 * 
 * Mandatory input parameters are: SampleOrderNumber
 * Optional input parameters are:
 *     enquiryBrand (defaults to "Sample")
 *     enquiryChannel (defaults to "Internet")
 * 
 * @author <a href="ljensen@salmon.com">Lars Jensen</a>
 * @version $Revision: 1.3 $
 */
public class CustomerOrderEnquiryMsgCmdImpl extends SampleBaseMsgCmdImpl implements CustomerOrderEnquiryMsgCmd {

    //command input params
    private String SampleOrderNumber;
    private String enquiryBrand = "Sample";
    private String enquiryChannel = "Internet";
    
    //command output
    private CustomerOrderEnquiryResponseData responseData;

    private boolean isSuccessful = false;
	private static final String CLASSNAME = CustomerOrderEnquiryMsgCmdImpl.class.getName();

	private static final Logger LOGGER = Logger.getLogger(CLASSNAME);


    /**
     * Check validity of parameters passed to command.
     */
    public void validateParameters() throws ECException {
    
        // Get and check parameters
        if(SampleOrderNumber == null || SampleOrderNumber.equals("")) {
            throw new ECApplicationException(ECMessage._ERR_CMD_MISSING_PARAM, this.getClass().getName(),
                "validateParameters", ECMessageHelper.generateMsgParms("SampleOrderNumber"));
        }
        
        // Set message type id for composition
        setMsgTypeId(new Integer(SampleConstants.Sample_MSG_TYPE_CUSTOMER_ORDER_ENQUIRY));
        // Set send type
        setSendMode(SampleConstants.MSG_SEND_RECEIVE_IMMEDIATE);
        // Set view name
        setViewName(SampleViewNames.Sample_CUSTOMER_ORDER_ENQUIRY_XML_VIEW);

        super.validateParameters();

    }

    /**
     * @see uk.co.Sample.ecommerce.messaging.commands.impl.SampleBaseMsgCmdImpl#beforeCompose()
     */
    protected void beforeCompose() throws ECException {
        // Set parameters for message composition JSP.  They are passed in TypedProperty jspProp
       jspProp = new TypedProperty();
       jspProp.put("SampleOrderNumber", SampleOrderNumber.toUpperCase()); //turn ad1234... into AD1234...
       jspProp.put("enquiryBrand", enquiryBrand);
       jspProp.put("enquiryChannel", enquiryChannel);
    }
    
    /**
     * @see uk.co.Sample.ecommerce.messaging.commands.impl.SampleBaseMsgCmdImpl#afterSend()
     */
    protected void afterSend() throws ECException {
        String method = "afterSend";
        CustomerOrderEnquiryResponseData responseData = null;
        if (responseMsg != null && responseMsg.length > 0) {
            try {
                // Parse the response and set-up the DeliverySlotsDatabeans
                CustomerOrderEnquiryResponseHandler responseHandler = new CustomerOrderEnquiryResponseHandler(responseMsg);
                responseData = responseHandler.getResponseData();
            } catch (XMLMsgParsingException e) {
                // We have failed to process the message, so PUT it onto the error queue
                LOGGER.logp(Level.SEVERE, this.getClass().getName(), method, "Failed to parse reponse message for customer order enquiry: "+e);
                outboundMessage.sendError(responseMsg);
            }
            
            setResponseData(responseData);

        }
        else
            LOGGER.logp(Level.WARNING, this.getClass().getName(), method, "No response to ECommerceADCustomerOrderEnquiry message sent.");
    }



        
    /**
     * @see uk.co.Sample.ecommerce.messaging.commands.stockavailability.DeliverySlotsEnquiryReqMsgCmd#isSuccessful()
     */
    public boolean isSuccessful() {
        return isSuccessful;
    }


    public String getSampleOrderNumber() {
        return SampleOrderNumber;
    }
    public void setSampleOrderNumber(String string) {
        SampleOrderNumber = string;
    }

    /**
     * @return messaging response
     */
    public CustomerOrderEnquiryResponseData getResponseData() {
        return responseData;
    }
    protected void setResponseData(CustomerOrderEnquiryResponseData data) {
        responseData = data;
    }

    public String getEnquiryBrand() {
        return enquiryBrand;
    }
    public String getEnquiryChannel() {
        return enquiryChannel;
    }
    public void setEnquiryBrand(String string) {
        enquiryBrand = string;
    }
    public void setEnquiryChannel(String string) {
        enquiryChannel = string;
    }

}