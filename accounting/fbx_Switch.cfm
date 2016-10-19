<!---
<fusedoc fuse="FBX_Switch.cfm">
	<responsibilities>
		I am the cfswitch statement that handles the fuseaction, delegating work to various fuses.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="15 December 2002" role="Architect">
	</properties>
	<io>
		<in>
			<structure name="fuxebox">
				<string name="fuseaction" />
				<string name="circuit" />
			</structure>
		</in>
	</io>
</fusedoc>
 --->

<cfswitch expression = "#fusebox.fuseaction#">
<!--- ----------------------------------------
MENU
----------------------------------------- --->
	<cfcase value="start,dsp_start,fusebox.defaultfuseaction">
		<!---This will be the value returned if someone types in "circuitname.", omitting the actual fuseaction request--->
		<cfscript>
			XFA.facilities = "accounting.dsp_facilities";
			XFA.coaches = "accounting.dsp_coaches";
			XFA.defaults = "accounting.dsp_defaults";
			XFA.practices = "accounting.dsp_practices";
			XFA.transactions = "accounting.dsp_transactions";
			XFA.transactionsUnconfirmed = "accounting.dsp_transactionsUnconfirmed";
			XFA.attendance_sheet = "accounting.dsp_attendance_sheet";
			XFA.balances = "accounting.dsp_balances";
			XFA.attendance_graph = "accounting.dsp_attendance_graph";
			XFA.coachingSummary = "accounting.dsp_coachingSummary";
			XFA.attendanceSummary = "accounting.dsp_attendanceSummary";
			XFA.membershipTransactions = "accounting.dsp_membershipTransactions";
			XFA.mergeUsers = "accounting.dsp_mergeUsersStart";
			XFA.addUserPass = "accounting.dsp_addUserPass";
			XFA.userSwimPasses = "accounting.dsp_userSwimPasses";

			Request.template = "dsp_start.cfm";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

<!--- ----------------------------------------
SWIM PASSES
----------------------------------------- --->
	<cfcase value="dsp_userSwimPasses">
		<cfparam name="attributes.success" default="" type="string" />
		<cfparam name="attributes.reason" default="" type="string" />
		<cfparam name="attributes.startDate" default="#Month(Now())#/1/#Year(Now())#" type="string">
		<cfparam name="attributes.endDate" default="#DateFormat(Now(),"M/D/YYYY")#" type="string">

		<cfset request.qPurchases = Request.lookupCFC.getUsersSwimPassTransactionsByDate(request.dsn,attributes.startDate,attributes.endDate) />
		<cfset request.qEffective = Request.lookupCFC.getUsersSwimPassesByEffectiveDate(request.dsn,attributes.startDate,attributes.endDate) />

		<cfset XFA.next = "accounting.dsp_userSwimPasses" />

		<cfset Request.page_title = Request.page_title & " - User Swim Passes" />
		<cfset Request.template = "dsp_userSwimPasses.cfm" />
		<cfset Request.js_validate = "accounting/javascript/userSwimPasses.js" />

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="dsp_addUserPass">
		<cfparam name="attributes.success" default="" type="string" />
		<cfparam name="attributes.reason" default="" type="string" />
		<cfparam name="attributes.selectedUserID" default="0" type="numeric" />
		<cfparam name="attributes.swimPassID" default="0" type="numeric" />

		<cfset qUsers = Request.lookupCFC.getMembers(request.dsn,"users","userStatuses","practiceTransactions","transactionTypes",0,90,"MEMBER",false,false,"",false,Now(),false,"officers","officerTypes","",1) />
		<cfset request.qSwimPasses = Request.lookupCFC.getSwimPasses(request.dsn,0) />

		<cfset XFA.next = "accounting.dsp_addUserPassConfirmation" />

		<cfset Request.tableColumnHeaders = "key:last_name|text:Last Name|type:string,key:first_name|text:First Name|type:string,key:username|text:Username|type:string,key:email|text:E-mail|type:email,key:status|text:Status|type:string" />

		<!--- Yahoo library includes --->
		<cfset ArrayAppend(request.ssOther,"#Request.yahooLibrary#/datatable/assets/datatable.css") />
		<cfset ArrayAppend(request.jsOther,"#Request.yahooLibrary#/yahoo-dom-event/yahoo-dom-event.js") />
		<cfset ArrayAppend(request.jsOther,"#Request.yahooLibrary#/dragdrop/dragdrop-min.js") />
		<cfset ArrayAppend(request.jsOther,"#Request.jsonParser#") />
		<cfset ArrayAppend(request.jsOther,"#Request.yahooLibrary#/datasource/datasource-beta-min.js") />
		<cfset ArrayAppend(request.jsOther,"#Request.yahooLibrary#/datatable/datatable-beta-min.js") />
		<cfset ArrayAppend(request.jsOther,"#Request.yahooLibrary#/connection/connection-min.js") />

		<cfset Request.filterURL = "#Request.self#?fuseaction=accounting.act_filterUsers&filter=" />
		<cfset Request.userQueryYahooURL = Request.self />
		<cfset Request.userQueryYahooURLParameters = "?fuseaction=utilities.act_query2Yahoo&componentPath=cfc.lookup_queries&methodName=getMembers&argumentList=dsn|#Request.dsn#,usersTbl|users,user_statusTbl|userStatuses,transactionTbl|practiceTransactions,transaction_typeTbl|transactionTypes,user_id|0,activityDays|90,statusType|ALL,activitySort|true,getContactInfo|false,getVisibleOnly|false,balanceDate|#Now()#,mailingListOnly|false,officerTbl|officers,officerTypeTbl|officerTypes" />

		<cfset Request.page_title = Request.page_title & " - Add User Swim Pass" />
		<cfset Request.template = "dsp_addUserPass.cfm" />
		<cfset Request.js_validate = "accounting/javascript/addUserPass.js" />
		<cfset Request.onLoad = Request.onLoad & "checkForAjax();populateYahooData('#Request.tableColumnHeaders#','#JsStringFormat(Request.userQueryYahooURL)#','#JsStringFormat(Request.userQueryYahooURLParameters)#');" />

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="dsp_addUserPassConfirmation">
		<cfparam name="attributes.success" default="" type="string" />
		<cfparam name="attributes.reason" default="" type="string" />
		<cfparam name="attributes.selectedUserID" default="0" type="numeric" />
		<cfparam name="attributes.swimPassID" default="0" type="numeric" />
		<cfparam name="attributes.effectiveDate" default="#dateFormat(now(),"mm/dd/yyyy")#" type="string" />

		<cfset request.qMember = request.lookupCFC.getMembers(request.dsn,"users","userStatuses","practiceTransactions","transactionTypes",attributes.selectedUserID,90,"ALL",false,true,"",false,Now(),false,"officers","officerTypes","") />
		<cfset request.qSwimPass = request.lookupCFC.getSwimPasses(request.dsn,val(attributes.swimPassID)) />

		<cfset XFA.next = "accounting.act_addUserPass" />
		<cfset XFA.previous = "accounting.dsp_addUserPass" />

		<cfset Request.page_title = Request.page_title & " - Add Swim Pass Confirmation" />
		<cfset Request.template = "dsp_addUserPassConfirmation.cfm" />

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="act_addUserPass">
	<cfsilent>
		<cfparam name="attributes.selectedUserID" default="0" type="numeric" />
		<cfparam name="attributes.swimPassID" default="0" type="numeric" />
		<cfparam name="attributes.effectiveDate" default="#dateFormat(now(),"mm/dd/yyyy")#" type="string" />
		<cfscript>
			XFA.next = "accounting.dsp_addUserPassResults";
			Request.template = "act_addUserPass.cfm";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfsilent>
	</cfcase>

	<cfcase value="dsp_addUserPassResults">
		<cfparam name="attributes.success" default="" type="string" />
		<cfparam name="attributes.reason" default="" type="string" />
		<cfparam name="attributes.usersSwimPassID" default="0" type="numeric" />

		<cfset request.qSwimPass = request.lookupCFC.getUsersSwimPassesByID(request.dsn,val(attributes.usersSwimPassID)) />
		<cfset request.qMember = request.lookupCFC.getMembers(request.dsn,"users","userStatuses","practiceTransactions","transactionTypes",request.qSwimPass.userID,90,"ALL",false,true,"",false,Now(),false,"officers","officerTypes","") />

		<cfset XFA.next = "accounting.dsp_addUserPass" />

		<cfset Request.page_title = Request.page_title & " - User Swim Pass Added" />
		<cfset Request.template = "dsp_addUserPassResults.cfm" />

		<cfinclude template="#Request.template#">
	</cfcase>

<!--- ----------------------------------------
MERGE USERS
----------------------------------------- --->
	<cfcase value="dsp_mergeUsersStart">
		<cfparam name="attributes.success" default="" type="string" />
		<cfparam name="attributes.reason" default="" type="string" />

		<cfset qUsers = Request.lookupCFC.getMembers(request.dsn,"users","userStatuses","practiceTransactions","transactionTypes",0,90,"ALL",false,false,"",false,Now(),false,"officers","officerTypes","") />

		<cfset XFA.next = "accounting.dsp_mergeUsersStep2" />

		<cfset Request.tableColumnHeaders = "key:last_name|text:Last Name|type:string,key:first_name|text:First Name|type:string,key:username|text:Username|type:string,key:email|text:E-mail|type:email,key:status|text:Status|type:string" />

		<!--- Yahoo library includes --->
		<cfset ArrayAppend(request.ssOther,"#Request.yahooLibrary#/datatable/assets/datatable.css") />
		<cfset ArrayAppend(request.jsOther,"#Request.yahooLibrary#/yahoo-dom-event/yahoo-dom-event.js") />
		<cfset ArrayAppend(request.jsOther,"#Request.yahooLibrary#/dragdrop/dragdrop-min.js") />
		<cfset ArrayAppend(request.jsOther,"#Request.jsonParser#") />
		<cfset ArrayAppend(request.jsOther,"#Request.yahooLibrary#/datasource/datasource-beta-min.js") />
		<cfset ArrayAppend(request.jsOther,"#Request.yahooLibrary#/datatable/datatable-beta-min.js") />
		<cfset ArrayAppend(request.jsOther,"#Request.yahooLibrary#/connection/connection-min.js") />

		<cfset Request.filterURL = "#Request.self#?fuseaction=accounting.act_filterUsers&filter=" />
		<cfset Request.userQueryYahooURL = Request.self />
		<cfset Request.userQueryYahooURLParameters = "?fuseaction=utilities.act_query2Yahoo&componentPath=cfc.lookup_queries&methodName=getMembers&argumentList=dsn|#Request.dsn#,usersTbl|users,user_statusTbl|userStatuses,transactionTbl|practiceTransactions,transaction_typeTbl|transactionTypes,user_id|0,activityDays|90,statusType|ALL,activitySort|true,getContactInfo|false,getVisibleOnly|false,balanceDate|#Now()#,mailingListOnly|false,officerTbl|officers,officerTypeTbl|officerTypes" />

		<cfset Request.page_title = Request.page_title & " - Merge User Accounts" />
		<cfset Request.template = "dsp_mergeUsersStart.cfm" />
		<cfset Request.js_validate = "accounting/javascript/mergeUsersStart.js" />
		<cfset Request.onLoad = Request.onLoad & "checkForAjax();populateYahooData('#Request.tableColumnHeaders#','#JsStringFormat(Request.userQueryYahooURL)#','#JsStringFormat(Request.userQueryYahooURLParameters)#');" />

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="dsp_mergeUsersStep2">
		<cfparam name="attributes.success" default="" type="string" />
		<cfparam name="attributes.reason" default="" type="string" />
		<cfparam name="attributes.primaryUserID" default="0" type="numeric" />
		<cfparam name="attributes.secondaryUsers" default="" type="string" />

		<cfset qPrimaryUser = Request.lookupCFC.getMembers(request.dsn,"users","userStatuses","practiceTransactions","transactionTypes",attributes.primaryUserID,90,"ALL",false,true,"",false,Now(),false,"officers","officerTypes","") />
		<cfset qSecondaryUsers = Request.lookupCFC.getMembers(request.dsn,"users","userStatuses","practiceTransactions","transactionTypes",0,90,"ALL",false,true,attributes.secondaryUsers,false,Now(),false,"officers","officerTypes","") />

		<cfset XFA.next = "accounting.dsp_mergeUsersConfirm" />

		<cfset Request.page_title = Request.page_title & " - Merge User Accounts Step 2" />
		<cfset Request.template = "dsp_mergeUsersStep2.cfm" />
		<cfset Request.js_validate = "accounting/javascript/mergeUsersStep2.js" />

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="dsp_mergeUsersConfirm">
		<cfparam name="attributes.success" default="" type="string" />
		<cfparam name="attributes.reason" default="" type="string" />
		<cfparam name="attributes.primaryUserID" default="0" type="numeric" />
		<cfparam name="attributes.secondaryUsers" default="" type="string" />
		<cfparam name="attributes.last_name" default="" type="string" />
		<cfparam name="attributes.first_name" default="" type="string" />
		<cfparam name="attributes.middle_name" default="" type="string" />
		<cfparam name="attributes.preferred_name" default="" type="string" />
		<cfparam name="attributes.username" default="" type="string" />
		<cfparam name="attributes.email" default="" type="string" />
		<cfparam name="attributes.phone_cell" default="" type="string" />
		<cfparam name="attributes.phone_day" default="" type="string" />
		<cfparam name="attributes.phone_night" default="" type="string" />
		<cfparam name="attributes.fax" default="" type="string" />
		<cfparam name="attributes.address1" default="" type="string" />
		<cfparam name="attributes.address2" default="" type="string" />
		<cfparam name="attributes.city" default="" type="string" />
		<cfparam name="attributes.state_id" default="" type="string" />
		<cfparam name="attributes.zip" default="" type="string" />
		<cfparam name="attributes.country" default="" type="string" />
		<cfparam name="attributes.status" default="" type="string" />
		<cfparam name="attributes.date_expiration" default="" type="string" />

		<cfset XFA.next = "accounting.act_mergeUsers" />
		<cfset XFA.cancel = "accounting.dsp_mergeUsersStart" />

		<cfset Request.page_title = Request.page_title & " - Merge User Accounts Confirmation" />
		<cfset Request.template = "dsp_mergeUsersConfirm.cfm" />

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="act_mergeUsers">
		<cfsilent>
			<cfparam name="attributes.primaryUserID" default="0" type="numeric" />
			<cfparam name="attributes.secondaryUsers" default="" type="string" />
			<cfparam name="attributes.last_name" default="" type="string" />
			<cfparam name="attributes.first_name" default="" type="string" />
			<cfparam name="attributes.middle_name" default="" type="string" />
			<cfparam name="attributes.preferred_name" default="" type="string" />
			<cfparam name="attributes.username" default="" type="string" />
			<cfparam name="attributes.email" default="" type="string" />
			<cfparam name="attributes.phone_cell" default="" type="string" />
			<cfparam name="attributes.phone_day" default="" type="string" />
			<cfparam name="attributes.phone_night" default="" type="string" />
			<cfparam name="attributes.fax" default="" type="string" />
			<cfparam name="attributes.address1" default="" type="string" />
			<cfparam name="attributes.address2" default="" type="string" />
			<cfparam name="attributes.city" default="" type="string" />
			<cfparam name="attributes.state_id" default="" type="string" />
			<cfparam name="attributes.zip" default="" type="string" />
			<cfparam name="attributes.country" default="" type="string" />
			<cfparam name="attributes.status" default="" type="string" />
			<cfparam name="attributes.date_expiration" default="" type="string" />

			<cfset Request.suppressLayout = true />

			<cfset XFA.success = "accounting.dsp_mergeUsersStart" />

			<cfset qStatus = Request.lookupCFC.getUserStatuses(request.dsn,"userStatuses",attributes.status,0) />
			<cfset Request.results = Request.membersCFC.mergeUsers(Request.dsn,attributes,qStatus.user_status_id) />

			<cfset success = Request.results.success />
			<cfset reason = Request.results.reason />

			<cfset Request.template = "../act_next.cfm" />

			<cfinclude template="#Request.template#" />
		</cfsilent>
	</cfcase>

	<cfcase value="act_filterUsers">
		<cfsilent>
		<!--- Filters Users --->
			<cfparam name="attributes.filter" default="" type="string" />

			<cfset qUsers = Request.lookupCFC.getMembers(request.dsn,"users","userStatuses","practiceTransactions","transactionTypes",0,90,"ALL",true,false,"",false,Now(),false,"officers","officerTypes",attributes.filter) />
			<cfset jsonObject = request.jsonCFC.encode(qUsers,"query") />
		</cfsilent>
		<cfset Request.template = "act_filterUsers.cfm" />

		<cfinclude template="#Request.template#" />
	</cfcase>

<!--- ----------------------------------------
BALANCES
----------------------------------------- --->
	<cfcase value="dsp_balances">
	<!--- Displays balances --->
		<cfparam name="attributes.squidDebug" default="false" type="boolean" />
		<cfparam name="attributes.activityLevel" default="active" type="string" />
		<cfscript>
			Request.page_title = Request.page_title & " - Swim Balances";
			Request.template = "dsp_balances.cfm";
			Request.js_validate = "accounting/javascript/balances.js";

			XFA.print = "accounting.dsp_balances_print";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="dsp_balances_print">
	<!--- Prints balances --->
		<cfparam name="attributes.activityLevel" default="active" type="string" />
		<cfscript>
			Request.page_title = "Swim Balances";
			Request.template = "dsp_balances_print.cfm";
			Request.ss_print = Request.theServer & "/styles/print.css";
			Request.onLoad = "parent.printFrame();";

			Request.suppressLayout = true;
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

<!--- ----------------------------------------
ATTENDANCE SHEETS/GRAPHS
----------------------------------------- --->
	<cfcase value="dsp_attendance_graph">
	<!--- Displays attendance graph --->
		<cfscript>
			Request.page_title = Request.page_title & " - Attendance Graph";
			Request.template = "dsp_attendance_graph.cfm";

			XFA.practice = "accounting.dsp_practices_edit";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="dsp_attendance_sheet">
	<!--- Displays attendance sheet form --->
		<cfscript>
			Request.page_title = Request.page_title & " - Attendance Sheet";
			Request.template = "dsp_attendance_sheet.cfm";
			Request.js_validate = "accounting/javascript/attendance_sheet.js";
			Request.onLoad = Request.onLoad & "document.forms['printForm'].elements['date_practice'].focus();document.forms['printForm'].elements['date_practice'].select();";

			XFA.print = "accounting.dsp_attendance_sheet_print";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="dsp_attendance_sheet_print">
	<!--- Prints blank attendance sheet --->
		<cfscript>
			Request.page_title = "Attendance Sheet";
			Request.template = "dsp_attendance_sheet_print.cfm";
			Request.js_validate = "accounting/javascript/attendance_sheet.js";
			Request.ss_print = Request.theServer & "/styles/print.css";
			Request.onLoad = "parent.printFrame();";

			Request.suppressLayout = true;
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="dsp_attendanceSummary">
	<!--- Displays Summary of Past Practices --->
		<cfparam name="attributes.monthFrom" default="#Month(Now())#" type="numeric" />
		<cfparam name="attributes.monthTo" default="#Month(Now())#" type="numeric" />
		<cfparam name="attributes.yearFrom" default="#Year(Now())#" type="numeric" />
		<cfparam name="attributes.yearTo" default="#Year(Now())#" type="numeric" />

		<cfscript>
			Request.page_title = Request.page_title & "<br />Attendance Summary";
			Request.template = "dsp_attendanceSummary.cfm";
			Request.js_validate = "accounting/javascript/attendanceSummary.js";

			firstYear = 2000;

			// Get query
			fromDate = CreateDate(attributes.yearFrom,attributes.monthFrom,1);
			toDate = CreateDate(attributes.yearTo,attributes.monthTo,DaysInMonth(CreateDate(attributes.yearTo,attributes.monthTo,1)));
			Request.accountingCFC = CreateObject("component",Request.accounting_cfc);
			qSummary = Request.accountingCFC.getAttendanceData(Request.dsn,Request.practice_transactionTbl,Request.transaction_typeTbl,variables.fromDate,variables.toDate,"ALL",true);
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

<!--- ----------------------------------------
MEMBERSHIP TRANSACTIONS
----------------------------------------- --->
	<cfcase value="dsp_membershipTransactions">
	<!--- Displays List of Past Transactions --->
		<cfparam name="attributes.date_start" default="#Month(Now())#/1/#Year(Now())#" type="string">
		<cfparam name="attributes.date_end" default="#DateFormat(Now(),"M/D/YYYY")#" type="string">

		<cfscript>
			Request.page_title = Request.page_title & "<br />Update Membership Transactions";
			Request.template = "dsp_membershipTransactions.cfm";
			Request.js_validate = "accounting/javascript/transactions.js";

			XFA.edit = "accounting.dsp_transactions_edit";
			XFA.delete = "accounting.act_transactions_delete";
			XFA.returnFA = attributes.fuseaction;

			qMembers = Request.lookupCFC.getMembers(Request.dsn,Request.usersTbl,Request.user_StatusTbl,Request.practice_transactionTbl,Request.transaction_typeTbl,0);
			qTransactions = Request.lookupCFC.getMembershipTransactions2(Request.dsn,0,attributes.date_start,attributes.date_end,-1);
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

<!--- ----------------------------------------
OTHER TRANSACTIONS
----------------------------------------- --->
	<cfcase value="dsp_transactions">
	<!--- Displays List of Past Transactions --->
		<cfscript>
			Request.page_title = Request.page_title & "<br />View/Update Transactions";
			Request.template = "dsp_transactions.cfm";
			Request.js_validate = "accounting/javascript/transactions.js";

			XFA.edit = "accounting.dsp_transactions_edit";
			XFA.export = "members.act_transactions_export";
			XFA.delete = "accounting.act_transactions_delete";
			XFA.practice_edit = "accounting.dsp_practices_edit";
			XFA.practice_delete = "accounting.act_practices_delete";
			XFA.buySwims = "members.dsp_buySwims";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="dsp_transactions_edit">
		<cfparam name="attributes.transaction_id" default="0" type="numeric">
	<!--- Displays Transaction Edit form--->
		<cfscript>
			if (VAL(attributes.transaction_id))
			{
				Request.page_title = Request.page_title & "<br />Update Transaction";
			}
			else
			{
				Request.page_title = Request.page_title & "<br />Add Transaction";
			}
			Request.js_validate = "accounting/javascript/transactions_edit.js";
			Request.template = "dsp_transactions_edit.cfm";

			XFA.next = "accounting.act_transactions_edit";
			XFA.transactions = "accounting.dsp_transactions";

			Request.onLoad = Request.onLoad & "document.transactionForm.date_transaction.focus();document.transactionForm.date_transaction.select();";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="act_transactions_edit">
	<cfsilent>
	<!--- Submits info --->
		<cfscript>
			XFA.success = "accounting.dsp_transactions";
			XFA.failure = "accounting.dsp_transactions_edit";

			Request.suppressLayout = true;

			Request.validation_template = "val_transactions_edit.cfm";
			Request.template = "act_next.cfm";
		</cfscript>

		<cfinclude template="#Request.validation_template#">
		<cfinclude template="#Request.template#">
	</cfsilent>
	</cfcase>

	<cfcase value="act_transactions_delete">
	<cfsilent>
	<!--- Deletes transaction --->
		<cfparam name="attributes.returnFA" default="accounting.dsp_transactions" type="string" />
		<cfscript>
			XFA.success = attributes.returnFA;
			XFA.failure = attributes.returnFA;

			Request.suppressLayout = true;

			Request.validation_template = "val_transactions_delete.cfm";
			Request.template = "act_next.cfm";
		</cfscript>

		<cfinclude template="#Request.validation_template#">
		<cfinclude template="#Request.template#">
	</cfsilent>
	</cfcase>

	<cfcase value="dsp_transactionsUnconfirmed">
	<!--- Displays List of Unconfirmed PayPal Transactions --->
		<cfscript>
			Request.page_title = Request.page_title & "<br />Confirm PayPal Transactions";
			Request.template = "dsp_transactionsUnconfirmed.cfm";

			XFA.edit = "accounting.dsp_transactionsUnconfirmedEdit";
			XFA.delete = "accounting.act_transactionsUnconfirmedDelete";

			qTrans = cfcAccounting.getUnconfirmedTransactions(Request.dsn,Request.practice_transactionTbl,Request.membershipTransactionTbl,Request.transaction_typeTbl,Request.usersTbl,0,0);
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="dsp_transactionsUnconfirmedEdit">
		<cfparam name="attributes.transaction_id" default="0" type="numeric" />
		<cfparam name="attributes.transaction_type_id" default="0" type="numeric" />
	<!--- Displays Transaction Edit form--->
		<cfscript>
			Request.page_title = Request.page_title & "<br />Confirm PayPal Transaction";
			Request.template = "dsp_transactionsUnconfirmedEdit.cfm";

			XFA.next = "accounting.act_transactionsUnconfirmedEdit";
			XFA.transactions = "accounting.dsp_transactionsUnconfirmed";

			Request.onLoad = Request.onLoad & "document.transactionForm.notes.focus();document.transactionForm.notes.select();";

			qTrans = cfcAccounting.getUnconfirmedTransactions(Request.dsn,Request.practice_transactionTbl,Request.membershipTransactionTbl,Request.transaction_typeTbl,Request.usersTbl,attributes.transaction_id,attributes.transaction_type_id);
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="act_transactionsUnconfirmedEdit">
	<cfsilent>
	<!--- Submits info --->
		<cfscript>
			XFA.success = "accounting.dsp_transactionsUnconfirmed";
			XFA.failure = "accounting.dsp_transactionsUnconfirmedEdit";

			Request.suppressLayout = true;

			stSuccess = cfcAccounting.confirmTransaction(attributes,Request.dsn,Request.practice_transactionTbl,Request.membershipTransactionTbl,Request.usersTbl,Request.user_statusTbl,Request.squid.user_id,CreateObject("component",Request.lookup_cfc),CreateObject("component",Request.members_cfc));

			variables.success = stSuccess.success;
			variables.reason = stSuccess.reason;
			Request.template = "../act_next.cfm";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfsilent>
	</cfcase>

	<cfcase value="act_transactionsUnconfirmedDelete">
	<cfsilent>
	<!--- Deletes transaction --->
		<cfscript>
			XFA.success = "accounting.dsp_transactionsUnconfirmed";
			XFA.failure = "accounting.dsp_transactionsUnconfirmed";

			Request.suppressLayout = true;

			if (VAL(attributes.transaction_type_id) GT 0)
			{
				transactionTbl = Request.practice_transactionTbl;
			}
			else
			{
				transactionTbl = Request.membershipTransactionTbl;
			}

			stSuccess = cfcAccounting.deleteTransaction(attributes,Request.dsn,variables.transactionTbl,Request.squid.user_id);

			variables.success = true;
			variables.reason = "Transaction Deleted";

			Request.template = "../act_next.cfm";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfsilent>
	</cfcase>

<!--- ----------------------------------------
PRACTICES
----------------------------------------- --->
	<cfcase value="dsp_practices">
	<!--- Displays List of Past Practices --->
		<cfscript>
			Request.page_title = Request.page_title & "<br />Update Attendance";
			Request.template = "dsp_practices.cfm";
			Request.js_validate = "accounting/javascript/practices.js";

			XFA.edit = "accounting.dsp_practices_edit";
			XFA.delete = "accounting.act_practices_delete";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="dsp_practices_edit">
		<cfparam name="attributes.practiceDate" default="" type="string">
		<cfparam name="attributes.practice_id" default="0" type="numeric">
	<!--- Displays Practice Edit form--->
			<cfif (LEN(attributes.practiceDate))>
				<cfinvoke
					component="#Request.lookup_cfc#"
					method="getPractices"
					returnvariable="qID"
					dsn=#Request.DSN#
					usersTbl=#Request.usersTbl#
					practicesTbl=#Request.practicesTbl#
					facilityTbl=#Request.facilityTbl#
					practiceDate=#ListFirst(attributes.practiceDate,"+")#
				>
				<cfset attributes.practice_id = qID.practice_id>
			</cfif>
		<cfscript>
			if (VAL(attributes.practice_id))
			{
				Request.page_title = Request.page_title & "<br />Update Practice";
			}
			else
			{
				Request.page_title = Request.page_title & "<br />Add Practice";
			}
			Request.js_validate = "accounting/javascript/practices_edit.js";
			Request.template = "dsp_practices_edit.cfm";

			XFA.next = "accounting.act_practices_edit";
			XFA.practices = "accounting.dsp_practices";

			Request.onLoad = Request.onLoad & "document.practiceForm.date_practice.focus();document.practiceForm.date_practice.select();";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="act_practices_edit">
	<cfsilent>
	<!--- Submits info --->
		<cfscript>
			XFA.success = "accounting.dsp_practices";
			XFA.failure = "accounting.dsp_practices_edit";

			Request.suppressLayout = true;

			Request.validation_template = "val_practices_edit.cfm";
			Request.template = "act_next.cfm";
		</cfscript>

		<cfinclude template="#Request.validation_template#">
		<cfinclude template="#Request.template#">
	</cfsilent>
	</cfcase>

	<cfcase value="act_practices_delete">
	<cfsilent>
	<!--- Deletes practice --->
		<cfscript>
			XFA.success = "accounting.dsp_practices";
			XFA.failure = "accounting.dsp_practices";

			Request.suppressLayout = true;

			Request.validation_template = "val_practices_delete.cfm";
			Request.template = "act_next.cfm";
		</cfscript>

		<cfinclude template="#Request.validation_template#">
		<cfinclude template="#Request.template#">
	</cfsilent>
	</cfcase>

<!--- ----------------------------------------
DEFAULTS
----------------------------------------- --->
	<cfcase value="dsp_defaults">
	<!--- Displays Practice Defaults --->
		<cfscript>
			Request.page_title = Request.page_title & "<br />Update Practice Defaults";
			Request.template = "dsp_defaults.cfm";
			Request.js_validate = "accounting/javascript/defaults.js";

			XFA.next = "accounting.act_defaults";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="act_defaults">
	<cfsilent>
	<!--- Submits info --->
		<cfscript>
			XFA.success = "accounting.dsp_defaults";
			XFA.failure = "accounting.dsp_defaults";

			Request.suppressLayout = true;

			Request.validation_template = "val_defaults.cfm";
			Request.template = "act_next.cfm";
		</cfscript>

		<cfinclude template="#Request.validation_template#">
		<cfinclude template="#Request.template#">
	</cfsilent>
	</cfcase>

<!--- ----------------------------------------
COACHES
----------------------------------------- --->
	<cfcase value="dsp_coaches">
	<!--- Displays Coaches --->
		<cfscript>
			Request.page_title = Request.page_title & "<br />Update Coaches";
			Request.template = "dsp_coaches.cfm";

			XFA.add = "accounting.dsp_coaches_add";
			XFA.delete = "accounting.act_coaches_delete";
			XFA.activation = "accounting.act_coaches_activation";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="dsp_coachingSummary">
	<!--- Displays Summary of Past Practices --->
		<cfparam name="attributes.monthFrom" default="#Month(Now())#" type="numeric" />
		<cfparam name="attributes.monthTo" default="#Month(Now())#" type="numeric" />
		<cfparam name="attributes.yearFrom" default="#Year(Now())#" type="numeric" />
		<cfparam name="attributes.yearTo" default="#Year(Now())#" type="numeric" />

		<cfscript>
			Request.page_title = Request.page_title & "<br />Coaching Summary";
			Request.template = "dsp_coachingSummary.cfm";
			Request.js_validate = "accounting/javascript/coachingSummary.js";

			firstYear = 2000;

			// Get query
			fromDate = CreateDate(attributes.yearFrom,attributes.monthFrom,1);
			toDate = CreateDate(attributes.yearTo,attributes.monthTo,DaysInMonth(CreateDate(attributes.yearTo,attributes.monthTo,1)));
			Request.lookupCFC = CreateObject("component",Request.lookup_cfc);
			qSummary = Request.lookupCFC.getCoachingSummary(Request.dsn,Request.practicesTbl,Request.usersTbl,variables.fromDate,variables.toDate);
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="dsp_coaches_add">
	<!--- Displays Coach Add form--->
		<cfscript>
			Request.page_title = Request.page_title & "<br />Add Coach";
			Request.js_validate = "accounting/javascript/coaches_add.js";
			Request.template = "dsp_coaches_add.cfm";

			XFA.next = "accounting.act_coaches_add";
			XFA.coaches = "accounting.dsp_coaches";

			Request.onLoad = Request.onLoad & "document.coachForm.coach_id.focus();";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="act_coaches_add">
	<cfsilent>
	<!--- Submits info --->
		<cfscript>
			XFA.success = "accounting.dsp_coaches";
			XFA.failure = "accounting.dsp_coaches_add";

			Request.suppressLayout = true;

			Request.validation_template = "val_coaches_add.cfm";
			Request.template = "act_next.cfm";
		</cfscript>

		<cfinclude template="#Request.validation_template#">
		<cfinclude template="#Request.template#">
	</cfsilent>
	</cfcase>

	<cfcase value="act_coaches_delete">
	<cfsilent>
	<!--- Deletes coach --->
		<cfscript>
			XFA.success = "accounting.dsp_coaches";
			XFA.failure = "accounting.dsp_coaches";

			Request.suppressLayout = true;

			Request.validation_template = "val_coaches_delete.cfm";
			Request.template = "act_next.cfm";
		</cfscript>

		<cfinclude template="#Request.validation_template#">
		<cfinclude template="#Request.template#">
	</cfsilent>
	</cfcase>

	<cfcase value="act_coaches_activation">
	<cfsilent>
	<!--- Switches coach status --->
		<cfscript>
			XFA.success = "accounting.dsp_coaches";
			XFA.failure = "accounting.dsp_coaches";

			Request.suppressLayout = true;

			Request.validation_template = "val_coaches_activation.cfm";
			Request.template = "act_next.cfm";
		</cfscript>

		<cfinclude template="#Request.validation_template#">
		<cfinclude template="#Request.template#">
	</cfsilent>
	</cfcase>

<!--- ----------------------------------------
FACILITIES
----------------------------------------- --->
	<cfcase value="dsp_facilities">
	<!--- Displays Facilities --->
		<cfscript>
			Request.page_title = Request.page_title & "<br />Update Facilities";
			Request.template = "dsp_facilities.cfm";

			XFA.edit = "accounting.dsp_facilities_edit";
			XFA.delete = "accounting.act_facilities_delete";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="dsp_facilities_edit">
		<cfparam name="attributes.facility_id" default="0" type="numeric">
	<!--- Displays Facility Edit form--->
		<cfscript>
			if (VAL(attributes.facility_id))
			{
				Request.page_title = Request.page_title & "<br />Update Facility";
			}
			else
			{
				Request.page_title = Request.page_title & "<br />Add Facility";
			}
			Request.js_validate = "accounting/javascript/facilities_edit.js";
			Request.template = "dsp_facilities_edit.cfm";

			XFA.next = "accounting.act_facilities_edit";
			XFA.facilities = "accounting.dsp_facilities";
			XFA.defaults = "accounting.dsp_defaults";

			Request.onLoad = Request.onLoad & "document.facilityForm.facility.focus();document.facilityForm.facility.select();";
		</cfscript>

		<cfinclude template="#Request.template#">
	</cfcase>

	<cfcase value="act_facilities_edit">
	<cfsilent>
	<!--- Submits info --->
		<cfscript>
			XFA.success = "accounting.dsp_facilities";
			XFA.failure = "accounting.dsp_facilities_edit";

			Request.suppressLayout = true;

			Request.validation_template = "val_facilities_edit.cfm";
			Request.template = "act_next.cfm";
		</cfscript>

		<cfinclude template="#Request.validation_template#">
		<cfinclude template="#Request.template#">
	</cfsilent>
	</cfcase>

	<cfcase value="act_facilities_delete">
	<cfsilent>
	<!--- Deletes facility --->
		<cfscript>
			XFA.success = "accounting.dsp_facilities";
			XFA.failure = "accounting.dsp_facilities";

			Request.suppressLayout = true;

			Request.validation_template = "val_facilities_delete.cfm";
			Request.template = "act_next.cfm";
		</cfscript>

		<cfinclude template="#Request.validation_template#">
		<cfinclude template="#Request.template#">
	</cfsilent>
	</cfcase>

	<cfdefaultcase>
		<!---This will just display an error message and is useful in catching typos of fuseaction names while developing--->
		<cfoutput><p>This is the cfdefaultcase tag. I received a fuseaction called <strong>"#attributes.fuseaction#"</strong> and I don't know what to do with it.</p></cfoutput>
	</cfdefaultcase>

</cfswitch>
