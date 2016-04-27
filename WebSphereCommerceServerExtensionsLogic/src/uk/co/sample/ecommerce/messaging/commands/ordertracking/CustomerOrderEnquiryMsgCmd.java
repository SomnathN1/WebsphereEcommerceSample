package uk.co.Sample.ecommerce.messaging.commands.ordertracking;

import uk.co.Sample.ecommerce.messaging.commands.SampleBaseMsgCmd;
import uk.co.Sample.ecommerce.messaging.databean.ordertracking.CustomerOrderEnquiryResponseData;

/**
 * Generates an outgoing Order Status Enquiry message.
 * 
 * @author <a href="ljensen@salmon.com">Lars Jensen</a>
 * @version $Revision: 1.1 $
 */
public interface CustomerOrderEnquiryMsgCmd extends SampleBaseMsgCmd {

    java.lang.String defaultCommandClassName = "uk.co.Sample.ecommerce.messaging.commands.ordertracking.CustomerOrderEnquiryMsgCmdImpl";
    java.lang.String NAME = "uk.co.Sample.ecommerce.messaging.commands.ordertracking.CustomerOrderEnquiryMsgCmd";

    //Possible values for enquiry status
    String STATUS_OK = "OK";
    String STATUS_FAULT = "Fault";
    String STATUS_INVALID_ORDER = "InvalidOrder";
    String STATUS_UNKNOWN_ORDER = "UnknownOrder";

    /**
     * @param userOrder sets the order number of the enquiry
     */
    public void setSampleOrderNumber(String userOrder);         

    /**
     * @return true if message was correctly sent and received
     */
    public boolean isSuccessful();
    
    /**
     * @return messaging response
     */
    public CustomerOrderEnquiryResponseData getResponseData();

}
