<cfsilent>
	<cfset request.memberCFC = createObject("component",request.members_cfc)  />
	<!--- Get transaction type --->
	<cfset qTransaction = request.lookupCFC.getTransactionTypes(request.dsn,request.transaction_typeTbl,0,false,"Swim Pass Purchase") />
	<cfset request.qMember = request.lookupCFC.getMembers(request.dsn,request.usersTbl,request.user_statusTbl,request.practice_transactionTbl,request.transaction_typeTbl,attributes.selectedUserID) />
	<!--- "Buy" swim pass --->
	<cfset stSuccess = request.memberCFC.buySwimPass(request.dsn,request.practice_transactionTbl,qTransaction.transaction_type_id,attributes.selectedUserID,0,Request.squid.user_id,request.qMember.balance,attributes.swimPassID,request.lookupCFC,attributes.effectiveDate) />
	<!--- Activate it --->
	<cfset request.memberCFC.activateSwimPass(request.dsn,stSuccess.usersSwimPassID,request.squid.user_id) />
</cfsilent>

<!--- Redirect --->
<cflocation addtoken="No" url="#Request.self#?fuseaction=#XFA.next#&usersSwimPassID=#stSuccess.usersSwimPassID#">

