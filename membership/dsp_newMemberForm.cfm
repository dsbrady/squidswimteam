<!---
<fusedoc
	fuse = "dsp_newMemberForm.cfm"
	version = "1.0"
	language="ColdFusion">
	<responsibilities>
		I display the new member form.
	</responsibilities>
	<properties>
		<history author="Scott Brady" date="10 December 2012" type="Create">
	</properties>
</fusedoc>
--->
<cfsilent>
	<cfparam name="attributes.email" default="" type="string" />
	<cfparam name="attributes.firstName" default="" type="string" />
	<cfparam name="attributes.middleName" default="" type="string" />
	<cfparam name="attributes.lastName" default="" type="string" />
	<cfparam name="attributes.preferredName" default="" type="string" />
	<cfparam name="attributes.address1" default="" type="string" />
	<cfparam name="attributes.address2" default="" type="string" />
	<cfparam name="attributes.city" default="" type="string" />
	<cfparam name="attributes.stateID" default="CO" type="string" />
	<cfparam name="attributes.zip" default="" type="string" />
	<cfparam name="attributes.country" default="US" type="string" />
	<cfparam name="attributes.phone1" default="" type="string" />
	<cfparam name="attributes.phoneType1" default="cell" type="string" />
	<cfparam name="attributes.phone2" default="" type="string" />
	<cfparam name="attributes.phoneType2" default="daytime" type="string" />
	<cfparam name="attributes.mailingList" default="true" type="boolean" />
	<cfparam name="attributes.emergencyName" default="" type="string" />
	<cfparam name="attributes.emergencyPhone" default="" type="string" />
	<cfparam name="attributes.emergencyRelation" default="" type="string" />
<!---
	<cfparam name="attributes.isVisitor" default="false" type="boolean" />
	<cfparam name="attributes.visitingTeam" default="" type="string" />
	<cfparam name="attributes.visitingCityState" default="" type="string" />
--->
	<cfparam name="attributes.liabilitySignature" default="" type="string" />
	<cfparam name="attributes.numSwims" default="0" type="numeric" />

	<cfparam name="attributes.success" default="true" type="boolean" />
	<cfparam name="attributes.reason" default="" type="string" />
</cfsilent>

<cfoutput>
<cfif NOT attributes.success>
	<h2>There were problems with your submission:</h2>
	<ul class="errorText">
		<cfloop list="#attributes.reason#" index="variables.theItem" delimiters="*">
			<li>#variables.theItem#</li>
		</cfloop>
	</ul>
	<p>Please make corrections below and re-submit the information.</p>
</cfif>

<h2 class="pageTitle">
	#Request.page_title#
</h2>
<div id="welcomeText">
	<p>
		Thank you for your interest in SQUID, Denver’s premier and primarily LGBT-friendly Swim Team!
	</p>
	<p>
		Since we practice at facilities operated by Denver Parks & Recreation, we require every participant to provide emergency contact information and sign the Liability 
		statement below. Please fill out the rest of the form so we can understand your interests and how you heard about the team.
	</p>
	<p>
		<span class="required">*</span> = required field
	</p>
</div>
<form name="inputForm" action="#variables.baseHREF##Request.self#?fuseaction=#XFA.next#" method="post" onsubmit="return validate();">
	<fieldset>
		<legend>Dues Info</legend>
		<div class="duesContainer">
			<div class="duesLabel">
				Pay Dues Through:
			</div>
			<div class="duesInfo">
				#session.squid.stDues.membershipYear[session.squid.stDues.duesIndex]#
			</div>
		</div>
		<div class="duesContainer">
			<div class="duesLabel">
				Dues:
			</div>
			<div class="duesInfo">
				#DollarFormat(session.squid.stDues.fee[session.squid.stDues.duesIndex])#
			</div>
		</div>
		<span id="additionalFeesClick" class="clickable" onclick="showAdditionalFees();">Additional Fees</span>
	</fieldset>
	<fieldset>
		<legend>Buy Swims</legend>
		<div class="duesContainer">
			<cfmodule template="/lib/buySwims.cfm" numSwims="#attributes.numSwims#" displayZeroSwims=true>
		</div>
	</fieldset>
	<fieldset>
		<legend>Contact Info</legend>
		<div class="contactContainer">
			<div class="contactLabel">
				<label for="email" class="contact"><span class="required">*</span> E-mail Address:</label>
			</div>
			<div class="contactInput">
				<input type="text" name="email" id="email" size="25" maxlength="255" value="#attributes.email#" />
			</div>
		</div>

		<div class="contactContainer">
			<div class="contactLabel">
				<label for="password" class="contact"><span class="required">*</span> Password:</label>
			</div>
			<div class="contactInput">
				<input type="password" name="password" id="password" size="25" maxlength="255" value="" />
				<br />
				<em>(#Request.validPasswordDescription#)</em>
			</div>
		</div>

		<div class="contactContainer">
			<div class="contactLabel">
				<label for="passwordConfirmation" class="contact"><span class="required">*</span> Confirm Password:</label>
			</div>
			<div class="contactInput">
				<input type="password" name="passwordConfirmation" id="passwordConfirmation" size="25" maxlength="255" value="" />
			</div>
		</div>

		<div class="contactContainer">
			<div class="contactLabel">
				<label for="firstName"><span class="required">*</span> First Name:</label>
			</div>
			<div class="contactInput">
				<input type="text" name="firstName" id="firstName" size="20" maxlength="50" value="#attributes.firstName#" />
			</div>
		</div>

		<div class="contactContainer">
			<div class="contactLabel">
				<label for="middleName">Middle Name:</label>
			</div>
			<div class="contactInput">
				<input type="text" name="middleName" id="middleName" size="20" maxlength="50" value="#attributes.middleName#" />
			</div>
		</div>

		<div class="contactContainer">
			<div class="contactLabel">
				<label for="lastName"><span class="required">*</span> Last Name:</label>
			</div>
			<div class="contactInput">
				<input type="text" name="lastName" id="lastName" size="20" maxlength="50" value="#attributes.lastName#" />
			</div>
		</div>

		<div class="contactContainer">
			<div class="contactLabel">
				<label for="preferredName">Preferred Name:</label>
			</div>
			<div class="contactInput">
				<input type="text" name="preferredName" id="preferredName" size="20" maxlength="50" value="#attributes.preferredName#" />
			</div>
		</div>

		<div class="contactContainer">
			<div class="contactLabel">
				<label for="address1">Address:</label>
			</div>
			<div class="contactInput">
				<input type="text" name="address1" id="address1" size="20" maxlength="50" value="#attributes.address1#" />
				<br />
				<input type="text" name="address2" id="address2" size="20" maxlength="50" value="#attributes.address2#" />
			</div>
		</div>

		<div class="contactContainer">
			<div class="contactLabel">
				<label for="city">City:</label>
			</div>
			<div class="contactInput">
				<input type="text" name="city" id="city" size="15" maxlength="50" value="#attributes.city#" />
			</div>
		</div>

		<div class="contactContainer">
			<div class="contactLabel">
				<label for="stateID">State:</label>
			</div>
			<div class="contactInput">
				<select name="stateID" id="stateID" size="1">
					<option value="" <cfif attributes.stateID IS 0>selected="true"</cfif>>(non-US)</option>
				<cfloop query="application.qStates">
					<option value="#application.qStates.state_id#" <cfif attributes.stateID IS application.qStates.state_id>selected="true"</cfif>>#application.qStates.state#</option>
				</cfloop>
				</select>
			</div>
		</div>

		<div class="contactContainer">
			<div class="contactLabel">
				<label for="zip">ZIP/Postal Code:</label>
			</div>
			<div class="contactInput">
				<input type="text" name="zip" id="zip" size="10" maxlength="10" value="#attributes.zip#" />
			</div>
		</div>

		<div class="contactContainer">
			<div class="contactLabel">
				<label for="country">Country:</label>
			</div>
			<div class="contactInput">
				<select name="country" id="country" size="1">
				<cfloop query="application.qCountries">
					<option value="#application.qCountries.countryCode#" <cfif attributes.country IS application.qCountries.countryCode>selected="true"</cfif>>#application.qCountries.country#</option>
				</cfloop>
				</select>
			</div>
		</div>

		<div class="contactContainer">
			<div class="contactLabel">
				<label for="phone1">Phone:</label>
			</div>
			<div class="contactInput">
				<input type="text" name="phone1" id="phone1" size="15" maxlength="50" value="#attributes.phone1#" />
				<input type="radio" name="phoneType1" id="phoneType1_cell" value="cell" <cfif attributes.phoneType1 EQ "cell">checked="true"</cfif> /> Cell
				<input type="radio" name="phoneType1" id="phoneType1_daytime" value="daytime" <cfif attributes.phoneType1 EQ "daytime">checked="true"</cfif> /> Daytime
				<input type="radio" name="phoneType1" id="phoneType1_evening" value="evening" <cfif attributes.phoneType1 EQ "evening">checked="true"</cfif> /> Evening
			</div>
		</div>

		<div class="contactContainer">
			<div class="contactLabel">
				<label for="phone2">Phone:</label>
			</div>
			<div class="contactInput">
				<input type="text" name="phone2" id="phone2" size="15" maxlength="50" value="#attributes.phone2#" />
				<input type="radio" name="phonetype2" id="phonetype2_cell" value="cell" <cfif attributes.phonetype2 EQ "cell">checked="true"</cfif> /> Cell
				<input type="radio" name="phonetype2" id="phonetype2_daytime" value="daytime" <cfif attributes.phonetype2 EQ "daytime">checked="true"</cfif> /> Daytime
				<input type="radio" name="phonetype2" id="phonetype2_evening" value="evening" <cfif attributes.phonetype2 EQ "evening">checked="true"</cfif> /> Evening
			</div>
		</div>

		<div class="contactContainer">
			<div class="mailingListInput">
				<input type="checkbox" name="mailingList" id="mailingList" value="true" <cfif attributes.mailingList>checked="true"</cfif> /> 
			</div>
			<div class="mailingListLabel">
				<label for="mailingList">
					Join the SQUID e-mail list
				</label>
				<br />
				<span class="moreInfo">
					(All of our communications are electronic)
				</span>
			</div>
		</div>
	</fieldset>

	<fieldset>
		<legend>Emergency Contact</legend>

		<div class="contactContainer">
			<div class="contactLabel">
				<label for="emergencyName"><span class="required">*</span> Name:</label>
			</div>
			<div class="contactInput">
				<input type="text" name="emergencyName" id="emergencyName" size="20" maxlength="120" value="#attributes.emergencyName#" />
			</div>
		</div>

		<div class="contactContainer">
			<div class="contactLabel">
				<label for="emergencyPhone"><span class="required">*</span> Phone:</label>
			</div>
			<div class="contactInput">
				<input type="text" name="emergencyPhone" id="emergencyPhone" size="15" maxlength="50" value="#attributes.emergencyPhone#" />
			</div>
		</div>

		<div class="contactContainer">
			<div class="contactLabel">
				<label for="emergencyRelation">Relationship:</label>
			</div>
			<div class="contactInput">
				<input type="text" name="emergencyRelation" id="emergencyRelation" size="15" maxlength="50" value="#attributes.emergencyRelation#" />
			</div>
		</div>
	</fieldset>
<!--- 1/9/2013: removing this, but only commenting it out in case they change their minds
	<fieldset>
		<legend>Visitor Information</legend>
		
		<div class="visitorContainer">
			Are you visiting from another USMS and/or GLBT swim team?
			<br />
			<input type="radio" name="isVisitor" id="isVisitor_yes" value="true" <cfif attributes.isVisitor>checked="true"</cfif> /> Yes
			<input type="radio" name="isVisitor" id="isVisitor_no" value="false" <cfif NOT attributes.isVisitor>checked="true"</cfif> /> No
		</div>

		<div class="visitorContainer">
			If so,
			<br />
			<div class="contactLabel">
				<label for="visitingTeam">What team?</label>
			</div>
			<div class="contactInput">
				<input type="text" name="visitingTeam" id="visitingTeam" size="15" maxlength="50" value="#attributes.visitingTeam#" />
			</div>
			<div class="contactLabel">
				<label for="visitingTeam">What city/state?</label>
			</div>
			<div class="visitingCityState">
				<input type="text" name="visitingCityState" id="visitingCityState" size="15" maxlength="100" value="#attributes.visitingCityState#" />
			</div>
		</div>
	</fieldset>
--->

	<fieldset>
		<legend>Liability Waiver</legend>
		<div class="liabilityContainer">
			I, the undersigned participant, intending to be legally bound, hereby certify that I am physically fit and have not been otherwise informed by a physician. 
			I ackowledge that I am aware of all the risks inherent in Masters swimming (training and competition), including possible permanent disability or death, 
			and agree to assume all of those risks. As a condition of my participation in the Masters Swimming Program or any activities hereto, I hereby waive any 
			and all rights to claims for loss or damages, including all claims for loss or damages caused by the negligence, active or passive, of Colorado 
			SQUID Swim Team, or any individuals supervising such activities.
		</div>
		<div class="liabilityContainer">
			<span class="required">*</span> Please acknowledge that you agree to the above waiver by entering your initials below.
			<br />
			<input type="text" name="liabilitySignature" id="liabilitySignature" size="3" maxlength="10" value="#attributes.liabilitySignature#" />
			<br />
			#dateFormat(now(),"mmm. d, yyyy")#
			<input type="hidden" name="liabilitySignatureDate" id="liabilitySignatureDate" value="#dateFormat(now(),"mmm. d, yyyy")#" />
		</div>
	</fieldset>
	<div id="nextStepButtonContainer">
		<button type="submit" id="nextStepButton" name="nextStepButton" value="Next Step">Next Step</button>
	</div>
</form>
<cfinclude template="/lib/additionalFees.cfm" />
</cfoutput>
