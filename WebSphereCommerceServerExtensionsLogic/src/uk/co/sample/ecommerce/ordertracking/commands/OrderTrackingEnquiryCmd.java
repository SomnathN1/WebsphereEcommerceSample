package uk.co.Sample.ecommerce.ordertracking.commands;

import com.ibm.commerce.command.ControllerCommand;

/**
 * @see OrderTrackingEnquiryCmdImpl
 * 
 * @author <a href="ljensen@salmon.com">Lars Jensen</a>
 * @version $Revision: 1.1 $
 */
public interface OrderTrackingEnquiryCmd extends ControllerCommand {
    String defaultCommandClassName = "uk.co.Sample.ecommerce.ordertracking.commands.OrderTrackingEnquiryCmdImpl";
    java.lang.String NAME = "uk.co.Sample.ecommerce.ordertracking.commands.OrderTrackingEnquiryCmd";

}
