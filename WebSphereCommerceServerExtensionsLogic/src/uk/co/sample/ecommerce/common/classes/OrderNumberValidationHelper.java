package uk.co.Sample.ecommerce.common.classes;

import uk.co.Sample.ecommerce.common.utils.SampleMessage;

/**
 * Provides validation for an Sample order number formats.
 * 
 ** 
 *
 */
public class OrderNumberValidationHelper {
    private java.lang.String orderNumber;
    private com.ibm.commerce.ras.ECMessage errorMessage = null;

    public OrderNumberValidationHelper(String orderNumber) {
        if (orderNumber != null) {
            this.orderNumber = orderNumber.trim();
        }
    }

    /** @return false if invalid - call getErrorMessage() for error. */
    public boolean validate() {
        if (validateAsJda()) {
            return true;
        } else if (validateAsYantra()) {
            setErrorMessage(null);
            return true;
        } else if (validateAsSterling()) {
            setErrorMessage(null);
            return true;
        } else {
            return false;
        }
    }
    
    /** @return false if invalid - call getErrorMessage() for error. */
    public boolean validateAsJda() {
        if (this.orderNumber == null || this.orderNumber.trim().length() == 0) {
            setErrorMessage(SampleMessage._ERR_ORDERNUMBER_MISSING);
            return false;
        }

        if (orderNumber.length() == 8) {
            try {
                Long l = new Long(orderNumber);
                return true;
            } catch (NumberFormatException e) {
                //ignore
            }
        }
        setErrorMessage(SampleMessage._ERR_ORDERNUMBER_FORMAT);
        return false;
    }

    /** @return false if invalid - call getErrorMessage() for error. */
    public boolean validateAsYantra() {
        if (this.orderNumber == null || this.orderNumber.trim().length() == 0) {
            setErrorMessage(SampleMessage._ERR_ORDERNUMBER_MISSING);
            return false;
        }

        if (orderNumber.length() == 11) {
            if (!orderNumber.substring(0, 2).equalsIgnoreCase("AD")) {
                setErrorMessage(SampleMessage._ERR_ORDERNUMBER_FORMAT);
                return false;
            }
            
            try {
                Long l = new Long(orderNumber.substring(2));
                return true;
            } catch (NumberFormatException e) {
                //ignore
            }
        }
        setErrorMessage(SampleMessage._ERR_ORDERNUMBER_FORMAT);
        return false;
    }

    /** @return false if invalid - call getErrorMessage() for error. */
    public boolean validateAsSterling() {
        if (this.orderNumber == null || this.orderNumber.trim().length() == 0) {
            setErrorMessage(SampleMessage._ERR_ORDERNUMBER_MISSING);
            return false;
        }

        if (orderNumber.length() == 9) {
            if (!orderNumber.substring(0, 1).equalsIgnoreCase("2")) {
                setErrorMessage(SampleMessage._ERR_ORDERNUMBER_FORMAT);
                return false;
            }
            
            try {
                Long l = new Long(orderNumber);
                return true;
            } catch (NumberFormatException e) {
                //ignore
            }
        }
        setErrorMessage(SampleMessage._ERR_ORDERNUMBER_FORMAT);
        return false;
    }

    protected void setErrorMessage(com.ibm.commerce.ras.ECMessage message) {
        errorMessage = message;
    }

    public com.ibm.commerce.ras.ECMessage getErrorMessage() {
        return errorMessage;
    }
    public java.lang.String getOrderNumber() {
        return orderNumber;
    }

}
