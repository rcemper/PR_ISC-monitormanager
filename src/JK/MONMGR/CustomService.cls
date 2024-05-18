Class JK.MONMGR.CustomService Extends Ens.BusinessService
{

/*
*****************************************************
*                 ** N O T I C E **                 *
*               - TEST/DEMO SOFTWARE -              *
* This and related items are not supported by       *
* InterSystems as part of any released product.     *
* It is supplied by InterSystems as a demo/test     *
* tool for a specific product and version.          *
* The user or customer is fully responsible for     *
* the maintenance of this software after delivery,  *
* and InterSystems shall bear no responsibility nor *
* liabilities for errors or misuse of this item.    *
*                                                   *
*****************************************************
*/
Parameter ADAPTER = "Ens.InboundAdapter";

/*
This class uses the Ens.InboundAdapter for its call interval
Be sure to set ^lasttimestamp with the starting date in format "MM/DD/YYYY HH:MM:SS"
i.e. set ^lasttimestamp = "08/01/2020 00:00:00"
*/
Method OnTask() As %Status
{
	if '$d(^lasttimestamp) set ^lasttimestamp=$zdt($h)
	// Set location of messages.log and open it
	set tLogFile = ##class(%File).%New($system.Util.ManagerDirectory()_"messages.log")
	// do tLogFile.Close()
	set tSC = tLogFile.Open("RH",5)
	
	// Quit if error
	if $$$ISERR(tSC) {
		
		// Line to debug as necessary
		// write $SYSTEM.Status.GetErrorText(tSC)
		
		quit +tSC
	}
	
	// Read in the tLogFile from top to bottom, line by line
	while 'tLogFile.AtEnd {
		
		set tLine = tLogFile.ReadLine()
		// set tLine = "08/04/20-05:41:40:875 (97946) 2 MirrorServer: Mirror primary entered permanent trouble state (reason 131072/0)"
		
		// if tLine doesn't contain a date/time stamp, skip over to next line
		if '((tLine [ "/") && (tLine [ "-") && (tLine [ ":") && (tLine [ "(")) || (tLine = "") {
			continue
		}
		
		// Parse the timestamp
		set tTimestamp = $piece(tLine,":",1,3)			// i.e. "08/04/20-05:41:40"
		set tTimestamp = $piece(tTimestamp,"-",1)_" "_$piece(tTimestamp,"-",2)		// i.e. "08/04/20 05:41:40"
		set tTimestamp = $piece(tTimestamp,"/",1,2)_"/20"_$piece(tTimestamp,"/",3)		// i.e. "08/04/2020 05:41:40"
		// Convert to horolog format
		set tTimestampH = $zdatetimeh(tTimestamp)
		
		
		//write "^lasttimestamp: "_^lasttimestamp,!
		//write "tTimestamp: "_tTimestamp,!
		//write " ",!
		
		// Check the previously recorded timestamp in ^lasttimestamp
		// Skip to next line if current line's timestamp is before ^lasttimestamp
		if ..CompareDates($zdatetimeh(^lasttimestamp), tTimestampH) {
			set ^lasttimestamp(1) = $zdatetimeh(^lasttimestamp)
			set ^lasttimestamp(2) = tTimestampH
			set ^lasttimestamp(3) = "working"
			
			// Skip over to the next line if current timestamp is before the ^lasttimestamp
			continue
		}
		
		
		// For debugging: Print the line if it contains date/timestamp and is after ^lasttimestamp
		// write "new line: "_tLine,!
		
		// Set current line's timestamp as ^lasttimestamp
		set ^lasttimestamp = tTimestamp // storing readable date format for convenience
		
		
		// Create an instance of AlertRequest
		set tAlertRequest = ##class(Ens.AlertRequest).%New()
			
		set tAlertRequest.AlertDestination = "Ens.Alert"
		set tAlertRequest.AlertText = $piece(tLine,") ",2)
		set tAlertRequest.AlertTime = tTimestamp
		set tAlertRequest.SessionId = ""
		set tAlertRequest.SourceConfigName = ""
			
		// Send tAlertRequest to Ens.Alert component
		do ..SendAlert(tAlertRequest)
	}
	
	// Set ^lasttimestamp to current time
	set ^lasttimestamp = $zdatetime($horolog)
	
	// Close the tLogFile
	do tLogFile.Close()
	
	Quit $$$OK
}

/// Returns 1 if pDate1 > pDate2
/// pDate1, pDate2 in Horolog format
Method CompareDates(pDate1 As %String, pDate2 As %String) As %Boolean
{
	// Convert horolog to seconds
	// 86400 seconds in a day
	set tDate1 = $piece(pDate1,",",1)*86400+$piece(pDate1,",",2)
	set tDate2 = $piece(pDate2,",",1)*86400+$piece(pDate2,",",2)
	
	// write "tDate1: "_tDate1_" , pDate1: "_pDate1,!
	// write "tDate2: "_tDate2_" , pDate2: "_pDate2,!
	
	return tDate1 > tDate2
}

}
