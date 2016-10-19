<cfcomponent displayname="SurveyCFC" hint="Component for SQUID Surveys">
	<cffunction name="getUserSurveys" access="public" displayname="getUserSurveys" hint="Gets query of surveys available to user" output="No" returntype="query">
		<cfargument name="dsn" required="yes" type="string" />
		<cfargument name="surveyTbl" required="yes" type="string" />
		<cfargument name="surveyUserTbl" required="yes" type="string" />
		<cfargument name="updatingUser" required="yes" type="numeric" />
		<cfargument name="surveyID" required="yes" type="numeric" />
		<cfargument name="surveyUntaken" required="no" default="0" type="boolean" />

		<cfset var qData = "" />

		<cfquery name="qData" datasource="#dsn#">
			SELECT
				s.surveyID,
				s.surveyName,
				s.surveyDescription,
				s.startDate,
				s.endDate,
				s.resultsPublic,
				CASE WHEN
					su.surveyTaken IS NULL
				THEN
					0
				ELSE
					su.surveyTaken
				END AS surveyTaken,
				su.takenDate,
				CASE WHEN
					s.allUsersYN = 1 OR su.userID IS NOT NULL
				THEN
					1
				ELSE
					0
				END AS isEligible
			FROM
				#surveyTbl# s 
				LEFT OUTER JOIN #surveyUserTbl# su
				ON 
				(
					s.surveyID = su.surveyID
					AND su.userID = <cfqueryparam value="#VAL(arguments.updatingUser)#" cfsqltype="CF_SQL_INTEGER" />
					AND su.active_Code = 1
				)
			WHERE
				s.activeCode = 1
				AND s.isLive = 1
			<cfif VAL(arguments.surveyID)>
				AND s.surveyID = <cfqueryparam value="#VAL(arguments.surveyID)#" cfsqltype="CF_SQL_INTEGER" />
			</cfif>
			<cfif arguments.surveyUntaken>
				AND su.surveyTaken = 0
				AND s.startDate <= GetDate()
				AND 
				(
					s.endDate >= GetDate()
					OR s.endDate IS NULL
				)
			</cfif>
				AND s.activeCode = 1
			ORDER BY
				s.startDate DESC,
				s.endDate DESC
		</cfquery>

		<cfreturn qdata />
	</cffunction>

	<cffunction name="getSurveyQuestions" access="public" displayname="getSurveyQuestions" hint="Gets query of survey questions" output="No" returntype="query">
		<cfargument name="dsn" required="yes" type="string" />
		<cfargument name="questionTbl" required="yes" type="string" />
		<cfargument name="questionChoiceTbl" required="yes" type="string" />
		<cfargument name="questionTypeTbl" required="yes" type="string" />
		<cfargument name="surveyID" required="yes" type="numeric" />

		<cfset var qData = "" />
	
		<cfquery name="qData" datasource="#dsn#">
			SELECT
				q.surveyQuestionID,
				q.surveyID,
				q.questionText,
				q.questionTypeID,
				q.numChoices,
				qt.questionTypeID,
				qt.questionType,
				qc.choiceVal,
				qc.choiceText
			FROM
				(
					#questionTbl# q
					INNER JOIN #questionTypeTbl# qt
					ON q.questionTypeID = qt.questionTypeID
				)
				LEFT OUTER JOIN #questionChoiceTbl# qc
				ON q.surveyQuestionID = qc.questionID
			WHERE
				q.activeCode = 1
				AND q.surveyID = <cfqueryparam value="#VAL(surveyID)#" cfsqltype="CF_SQL_INTEGER" />
			ORDER BY
				q.displayOrder
		</cfquery>

		<cfreturn qdata />
	</cffunction>

	<cffunction name="getQuestionTypes" access="public" displayname="getQuestionTypes" hint="Gets query of survey question types" output="No" returntype="query">
		<cfargument name="dsn" required="yes" type="string" />
		<cfargument name="questionTypeTbl" required="yes" type="string" />

		<cfset var qData = "" />
	
		<cfquery name="qData" datasource="#dsn#">
			SELECT
				qt.questionTypeID,
				qt.questionType
			FROM
					#questionTypeTbl# qt
			ORDER BY
				qt.questionType
		</cfquery>

		<cfreturn qdata />
	</cffunction>

	<cffunction name="takeSurvey" access="public" displayname="takeSurvey" hint="Processes User's Submission of a Survey" output="No" returntype="struct">
		<cfargument name="formfields" required="yes" type="struct" />
		<cfargument name="dsn" required="yes" type="string" />
		<cfargument name="surveyTbl" required="yes" type="string" />
		<cfargument name="surveyUserTbl" required="yes" type="string" />
		<cfargument name="responseTbl" required="yes" type="string" />
		<cfargument name="updatingUser" required="yes" type="numeric" />

		<cfset var uniqueResponseID = CreateUUID() />

		<cfset var qSurvey = getUserSurveys(arguments.dsn,arguments.surveyTbl,arguments.surveyUserTbl,arguments.updatingUser,arguments.formfields.surveyID) />
		<cfset var stSuccess = StructNew() />
		<cfset stSuccess.success = true />
		<cfset stSuccess.reason = "Survey Submitted." />

		<!--- Make sure they're submitting the right survey --->
		<cfif qSurvey.RecordCount AND VAL(qSurvey.isEligible) AND NOT VAL(qSurvey.surveyTaken)>
			<cftransaction isolation="SERIALIZABLE">
				<!--- Loop along formfields --->
				<cfloop collection="#formfields#" item="i">
					<cfif ListFirst(i,"_") IS "Response">
						<cfset questionID = ListLast(i,"_") />
	
						<!--- If there can be multiple answers, loop --->
						<cfif formfields["type_" & questionID] IS "Choose One or More">
							<cfloop list="#formfields[i]#" index="j">
								<!--- Insert Into DB --->
								<cfquery name="qInsert" datasource="#dsn#">
									INSERT INTO
										#responseTbl#
									(
										surveyID,
										questionID,
										response,
										uniqueResponseID
									)
									VALUES
									(
										<cfqueryparam value="#VAL(formfields.surveyID)#" cfsqltype="CF_SQL_INTEGER" />,
										<cfqueryparam value="#VAL(questionID)#" cfsqltype="CF_SQL_INTEGER" />,
										<cfqueryparam value="#j#" cfsqltype="CF_SQL_VARCHAR" />,
										<cfqueryparam value="#uniqueResponseID#" cfsqltype="CF_SQL_VARCHAR" />
									)
								</cfquery>
							</cfloop>
						<cfelse>
							<!--- Insert Into DB --->
							<cfquery name="qInsert" datasource="#dsn#">
								INSERT INTO
									#responseTbl#
								(
									surveyID,
									questionID,
								<cfif formfields["type_" & questionID] IS "Long-Answer">
									responseLong,
								<cfelse>
									response,
								</cfif>
									uniqueResponseID
								)
								VALUES
								(
									<cfqueryparam value="#VAL(formfields.surveyID)#" cfsqltype="CF_SQL_INTEGER" />,
									<cfqueryparam value="#VAL(questionID)#" cfsqltype="CF_SQL_INTEGER" />,
								<cfif formfields["type_" & questionID] IS "Long-Answer">
									<cfqueryparam value="#formfields[i]#" cfsqltype="CF_SQL_CLOB" />,
								<cfelse>
									<cfqueryparam value="#formfields[i]#" cfsqltype="CF_SQL_VARCHAR" />,
								</cfif>
									<cfqueryparam value="#uniqueResponseID#" cfsqltype="CF_SQL_VARCHAR" />
								)
							</cfquery>
						</cfif>
					</cfif>
				</cfloop>	
				
				<!--- See if user is already in the table --->
				<cfquery name="qUser" datasource="#dsn#">
					SELECT
						surveyUsersID
					FROM
						#surveyUserTbl#
					WHERE
						surveyID = <cfqueryparam value="#VAL(formfields.surveyID)#" cfsqltype="CF_SQL_INTEGER" />
						AND userID = <cfqueryparam value="#VAL(updatingUser)#" cfsqltype="CF_SQL_INTEGER" />
				</cfquery>
	
				<cfif qUser.RecordCount>
					<!--- Update surveyUser table --->
					<cfquery name="qUserUpdate" datasource="#dsn#">
						UPDATE
							#surveyUserTbl#
						SET
							surveyTaken = 1,
							takenDate = GetDate()
						WHERE
							surveyID = <cfqueryparam value="#VAL(formfields.surveyID)#" cfsqltype="CF_SQL_INTEGER" />
							AND userID = <cfqueryparam value="#VAL(updatingUser)#" cfsqltype="CF_SQL_INTEGER" />
							AND active_code = 1
					</cfquery>
				<cfelse>
					<!--- Insert into surveyUser table --->
					<cfquery name="qUserInsert" datasource="#dsn#">
						INSERT INTO
							#surveyUserTbl#
						(
							surveyID,
							userID,
							surveyTaken,
							takenDate
						)
						VALUES
						(
							<cfqueryparam value="#VAL(formfields.surveyID)#" cfsqltype="CF_SQL_INTEGER" />,
							<cfqueryparam value="#VAL(updatingUser)#" cfsqltype="CF_SQL_INTEGER" />,
							1,
							GetDate()
						)
					</cfquery>
				</cfif>
			</cftransaction>
		<cfelse>
			<cfset stSuccess.success = false />
			<cfset stSuccess.reason = "You are not eligible to submit this survey at this time." />
		</cfif>

		<cfreturn stSuccess />
	</cffunction>

	<cffunction name="getSurveys" access="public" displayname="getSurveys" hint="Gets query of surveys" output="No" returntype="query">
		<cfargument name="dsn" required="yes" type="string" />
		<cfargument name="surveyTbl" required="yes" type="string" />
		<cfargument name="surveyUserTbl" required="yes" type="string" />
		<cfargument name="surveyResponseTbl" required="yes" type="string" />
		<cfargument name="userTbl" required="yes" type="string" />
		<cfargument name="surveyID" required="yes" type="numeric" />

		<cfset var qData = "" />

		<cfquery name="qData" datasource="#dsn#">
			SELECT
				s.surveyID,
				s.surveyName,
				s.startDate,
				s.endDate,
				s.isLive,
				s.resultsPublic,
				s.allUsersYN,
				u.email AS creatorEmail,
				CASE 
					WHEN u.preferred_name IS NOT NULL
				THEN
					u.preferred_name
				ELSE
					u.first_name
				END + ' ' + u.last_name AS creatorName,
				COUNT(su.userID) AS numRespondents,
				CAST(s.surveyDescription AS varchar(4000)) AS surveyDescription
			FROM
				(
					#surveyTbl# s
					LEFT OUTER JOIN #surveyUserTbl# su
					ON (s.surveyID = su.surveyID AND su.surveyTaken = 1 AND su.active_code = 1)
				)
				INNER JOIN #userTbl# u
				ON s.createdUser = u.user_id
			WHERE
				s.activeCode = 1
			<cfif VAL(surveyID)>
				AND s.surveyID = <cfqueryparam value="#VAL(surveyID)#" cfsqltype="CF_SQL_INTEGER" />
			</cfif>
			GROUP BY
				s.surveyID,
				s.surveyName,
				s.startDate,
				s.endDate,
				s.allUsersYN,
				s.isLive,
				s.resultsPublic,
				u.email,
				u.last_name,
				u.first_name,
				u.preferred_name,
				CAST(s.surveyDescription AS varchar(4000))
			ORDER BY
				s.startDate DESC,
				s.endDate DESC
		</cfquery>

		<cfreturn qdata />
	</cffunction>

	<cffunction name="setSurvey" access="public" displayname="setSurvey" hint="Updates Survey" output="No" returntype="struct">
		<cfargument name="formfields" required="yes" type="struct" />
		<cfargument name="dsn" required="yes" type="string" />
		<cfargument name="surveyTbl" required="yes" type="string" />
		<cfargument name="updatingUser" required="yes" type="numeric" />

		<cfset var stSuccess = StructNew() />
		<cfset stSuccess.success = true />
		<cfset stSuccess.reason = "" />

		<!--- Validate Info --->
		<cfset stSuccess = validateSurvey(formfields) />

		<cfif stSuccess.success>
			<cfif VAL(formfields.surveyID)>
				<cfset stSuccess = updateSurvey(formfields,dsn,surveyTbl,updatingUser) />
			<cfelse>
				<cfset stSuccess = insertSurvey(formfields,dsn,surveyTbl,updatingUser) />
			</cfif>
		</cfif>		
		<cfreturn stSuccess />
	</cffunction>

	<cffunction name="validateSurvey" access="private" displayname="validateSurvey" hint="Updates Survey" output="No" returntype="struct">
		<cfargument name="formfields" required="yes" type="struct" />

		<cfset var stSuccess = StructNew() />
		<cfset stSuccess.success = true />
		<cfset stSuccess.reason = "" />

		<!--- Validate Info --->
		<cfscript>
			if (NOT LEN(trim(formfields.surveyName)))
			{
				stSuccess.success = false;
				stSuccess.reason = ListAppend(stSuccess.reason,"Please enter the survey name.","*");
			}
			if (NOT LEN(trim(formfields.startDate)) OR (NOT isDate(formfields.startDate)))
			{
				stSuccess.success = false;
				stSuccess.reason = ListAppend(stSuccess.reason,"Please enter a valid date for the start date.","*");
			}
			if (LEN(trim(formfields.endDate)) AND (NOT isDate(formfields.endDate)))
			{
				stSuccess.success = false;
				stSuccess.reason = ListAppend(stSuccess.reason,"Please enter a valid date for the end date.","*");
			}
			if (NOT LEN(trim(formfields.surveyDescription)))
			{
				stSuccess.success = false;
				stSuccess.reason = ListAppend(stSuccess.reason,"Please enter the survey description.","*");
			}
		</cfscript>
		
		<cfreturn stSuccess />
	</cffunction>

	<cffunction name="updateSurvey" access="private" displayname="updateSurvey" hint="Updates Survey" output="No" returntype="struct">
		<cfargument name="formfields" required="yes" type="struct" />
		<cfargument name="dsn" required="yes" type="string" />
		<cfargument name="surveyTbl" required="yes" type="string" />
		<cfargument name="updatingUser" required="yes" type="numeric" />

		<cfset var stSuccess = StructNew() />
		<cfset stSuccess.success = true />
		<cfset stSuccess.reason = "" />

		<!--- Update table --->
		<cfquery name="qUpdate" datasource="#dsn#">
			UPDATE
				#surveyTbl#
			SET
				surveyName = <cfqueryparam value="#formfields.surveyName#" cfsqltype="CF_SQL_VARCHAR" />,
				surveyDescription = <cfqueryparam value="#formfields.surveyDescription#" cfsqltype="CF_SQL_CLOB" />,
				allUsersYN = <cfqueryparam value="#formfields.allUsersYN#" cfsqltype="CF_SQL_BIT" />,
				resultsPublic = <cfqueryparam value="#formfields.resultsPublic#" cfsqltype="CF_SQL_BIT" />,
				startDate = <cfqueryparam value="#formfields.startDate#" cfsqltype="CF_SQL_DATE" />,
				endDate = <cfqueryparam value="#formfields.endDate#" cfsqltype="CF_SQL_DATE" />,
				modifiedUser = <cfqueryparam value="#VAL(updatingUser)#" cfsqltype="CF_SQL_INTEGER" />,
				modifiedDate = GetDate()
			WHERE
				surveyID = <cfqueryparam value="#VAL(formfields.surveyID)#" cfsqltype="CF_SQL_INTEGER" />
		</cfquery>

		<cfset stSuccess.surveyID = formfields.surveyID />

		<cfreturn stSuccess />
	</cffunction>

	<cffunction name="insertSurvey" access="private" displayname="insertSurvey" hint="Inserts Survey" output="No" returntype="struct">
		<cfargument name="formfields" required="yes" type="struct" />
		<cfargument name="dsn" required="yes" type="string" />
		<cfargument name="surveyTbl" required="yes" type="string" />
		<cfargument name="updatingUser" required="yes" type="numeric" />

		<cfset var stSuccess = StructNew() />
		<cfset stSuccess.success = true />
		<cfset stSuccess.reason = "" />

		<!--- Update table --->
		<cftransaction isolation="SERIALIZABLE">
			<cfquery name="qInsert" datasource="#dsn#">
				SET NOCOUNT OFF
					INSERT INTO
						#surveyTbl#
					(
						surveyName,
						surveyDescription,
						allUsersYN,
						resultsPublic,
						startDate,
						endDate,
						createdUser,
						modifiedUser
					)
					VALUES
					(
						<cfqueryparam value="#formfields.surveyName#" cfsqltype="CF_SQL_VARCHAR" />,
						<cfqueryparam value="#formfields.surveyDescription#" cfsqltype="CF_SQL_CLOB" />,
						<cfqueryparam value="#formfields.allUsersYN#" cfsqltype="CF_SQL_BIT" />,
						<cfqueryparam value="#formfields.resultsPublic#" cfsqltype="CF_SQL_BIT" />,
						<cfqueryparam value="#formfields.startDate#" cfsqltype="CF_SQL_DATE" />,
						<cfqueryparam value="#formfields.endDate#" cfsqltype="CF_SQL_DATE" />,
						<cfqueryparam value="#VAL(updatingUser)#" cfsqltype="CF_SQL_INTEGER" />,
						<cfqueryparam value="#VAL(updatingUser)#" cfsqltype="CF_SQL_INTEGER" />
					)
					SELECT IDENT_CURRENT('#surveyTbl#') AS newID
				SET NOCOUNT ON
			</cfquery>

			<cfset stSuccess.surveyID = qInsert.newID />
		</cftransaction>

		<cfreturn stSuccess />
	</cffunction>

	<cffunction name="getSurveyUsers" access="public" displayname="getSurveyUsers" hint="Gets query of survey users" output="No" returntype="query">
		<cfargument name="dsn" required="yes" type="string" />
		<cfargument name="userTbl" required="yes" type="string" />
		<cfargument name="surveyUserTbl" required="yes" type="string" />
		<cfargument name="preferenceTbl" required="yes" type="string" />
		<cfargument name="surveyID" required="yes" type="numeric" />

		<cfset var qData = "" />

		<cfquery name="qData" datasource="#dsn#">
			SELECT
				su.userID AS user_id,
				CASE WHEN
					u.preferred_name IS NULL
				THEN
					u.first_name
				ELSE
					u.preferred_name
				END AS firstName,
				u.first_name,
				u.preferred_name,
				u.last_name,
				u.email,
				ep.preference AS emailPreference,
				su.surveyTaken,
				su.takenDate
			FROM
				#surveyUserTbl# su
				INNER JOIN #userTbl# u
				ON su.userID = u.user_id
				INNER JOIN #preferenceTbl# ep
				ON u.email_preference = ep.preference_id
			WHERE
				su.active_code = 1
				AND su.surveyID = <cfqueryparam value="#VAL(surveyID)#" cfsqltype="CF_SQL_INTEGER" />
			ORDER BY
				u.last_name,
				firstName
		</cfquery>

		<cfreturn qdata />
	</cffunction>

	<cffunction name="setSurveyUsers" access="public" displayname="setSurveyUsers" hint="Updates Survey Users" output="No" returntype="struct">
		<cfargument name="formfields" required="yes" type="struct" />
		<cfargument name="dsn" required="yes" type="string" />
		<cfargument name="surveyUserTbl" required="yes" type="string" />
		<cfargument name="updatingUser" required="yes" type="numeric" />

		<cfset var stSuccess = StructNew() />
		<cfset stSuccess.success = true />
		<cfset stSuccess.reason = "" />

		<cftransaction isolation="SERIALIZABLE">
			<!--- First, delete any users who haven't taken the survey yet and aren't in the list --->
			<cfquery name="qDelete" datasource="#dsn#">
				UPDATE
					#surveyUserTbl#
				SET
					active_code = 0
				WHERE
					surveyID = <cfqueryparam value="#formfields.surveyID#" cfsqltype="CF_SQL_INTEGER" />
					AND surveyTaken = 0
				<CFIF ListLen(formfields.userid)>
					AND userID NOT IN (<cfqueryparam value="#formfields.userid#" cfsqltype="CF_SQL_INTEGER" list="Yes" />)
				</CFIF>
			</cfquery>

			<!--- See which users already in the table --->
			<cfquery name="qExist" datasource="#dsn#">
				SELECT
					userID
				FROM
					#surveyUserTbl#
				WHERE
					surveyID = <cfqueryparam value="#formfields.surveyID#" cfsqltype="CF_SQL_INTEGER" />
					AND active_code = 1
			</cfquery>

			<!--- Loop along list of users --->
			<cfloop list="#formfields.userID#" index="i">
				<!--- Only insert if the user isn't in the qExist query --->
				<cfif NOT ListFind(ValueList(qExist.userID),i)>
					<cfquery name="qInsert" datasource="#dsn#">
						INSERT INTO
							#surveyUserTbl#
						(
							surveyID,
							userID
						)
						VALUES
						(
							<cfqueryparam value="#formfields.surveyID#" cfsqltype="CF_SQL_INTEGER" />,
							<cfqueryparam value="#i#" cfsqltype="CF_SQL_INTEGER" />
						)
					</cfquery>
				</cfif>
			</cfloop>
		</cftransaction>

		<cfreturn stSuccess />
	</cffunction>

	<cffunction name="setSurveyQuestions" access="public" displayname="setSurveyQuestions" hint="Updates Survey Questions" output="No" returntype="struct">
		<cfargument name="formfields" required="yes" type="struct" />
		<cfargument name="dsn" required="yes" type="string" />
		<cfargument name="questionTbl" required="yes" type="string" />
		<cfargument name="questionChoiceTbl" required="yes" type="string" />
		<cfargument name="updatingUser" required="yes" type="numeric" />

		<cfset var rowID = 0 />
		<cfset var newOld = "" />
		<cfset var stSuccess = StructNew() />
		<cfset stSuccess.success = true />
		<cfset stSuccess.reason = "" />

		<cftransaction isolation="SERIALIZABLE">
			<!--- Delete any existing questions and choices --->
			<cfquery name="qDeleteChoices" datasource="#dsn#">
				DELETE FROM
					#questionChoiceTbl#
				WHERE
					questionID IN
					(
						SELECT
							questionID
						FROM
							#questionTbl#
						WHERE
							surveyID = <cfqueryparam value="#VAL(formfields.surveyID)#" cfsqltype="CF_SQL_INTEGER" />
					)
			</cfquery>
		
			<cfquery name="qDeleteChoices" datasource="#dsn#">
				DELETE FROM
					#questionTbl#
				WHERE
					surveyID = <cfqueryparam value="#VAL(formfields.surveyID)#" cfsqltype="CF_SQL_INTEGER" />
			</cfquery>
			
			<!--- Loop along formfields and get the question "id" --->
			<cfloop collection="#formfields#" item="i">
				<cfif ListFirst(i,"_") IS "questionText">
					<cfset newOld = ListGetAt(i,2,"_") />
					<cfset rowID = ListLast(i,"_") />
					
					<!--- Insert Question --->
					<cfquery name="qInsertQuestion" datasource="#dsn#">
						SET NOCOUNT OFF
							INSERT INTO
								#questionTbl#
							(
								surveyID,
								questionText,
								questionTypeID,
								displayOrder,
								numChoices
							)
							VALUES
							(
								<cfqueryparam value="#VAL(formfields.surveyID)#" cfsqltype="CF_SQL_INTEGER" />,
								<cfqueryparam value="#formfields["questionText_" & newOld & "_" & rowID]#" cfsqltype="CF_SQL_VARCHAR" />,
								<cfqueryparam value="#formfields["questionTypeID_" & newOld & "_" & rowID]#" cfsqltype="CF_SQL_INTEGER" />,
								<cfqueryparam value="#formfields["displayOrder_" & newOld & "_" & rowID]#" cfsqltype="CF_SQL_INTEGER" />,
								<cfqueryparam value="#formfields["numChoices_" & newOld & "_" & rowID]#" cfsqltype="CF_SQL_INTEGER" />
							)
							SELECT IDENT_CURRENT('#questionTbl#') AS newID
						SET NOCOUNT ON
					</cfquery>
					
					<!--- If we need to add choices, do so --->
					<cfif VAL(formfields["numChoices_" & newOld & "_" & rowID])>
						<!--- Loop over number of choices --->
						<cfloop from="1" to="#VAL(formfields["numChoices_" & newOld & "_" & rowID])#" index="j">
							<!--- Insert into table --->
							<cfquery name="qInsertChoice" datasource="#dsn#">
								INSERT INTO
									#questionChoiceTbl#
								(
									questionID,
									choiceVal,
									choiceText
								)
								VALUES
								(
									<cfqueryparam value="#VAL(qInsertQuestion.newID)#" cfsqltype="CF_SQL_INTEGER" />,
									<cfqueryparam value="#j#" cfsqltype="CF_SQL_INTEGER" />,
									<cfqueryparam value="#formfields["choice_" & newOld & "_" & rowID & "_" & j]#" cfsqltype="CF_SQL_VARCHAR" />
								)
							</cfquery>
						</cfloop>
					<cfelseif VAL(formfields["questionTypeID_" & newOld & "_" & rowID]) EQ 1>
						<!--- Insert Yes and No into choice table --->
						<cfquery name="qInsertYes" datasource="#dsn#">
							INSERT INTO
								#questionChoiceTbl#
							(
								questionID,
								choiceVal,
								choiceText
							)
							VALUES
							(
								<cfqueryparam value="#VAL(qInsertQuestion.newID)#" cfsqltype="CF_SQL_INTEGER" />,
								<cfqueryparam value="1" cfsqltype="CF_SQL_INTEGER" />,
								<cfqueryparam value="Yes" cfsqltype="CF_SQL_VARCHAR" />
							)
						</cfquery>
						<cfquery name="qInsertNo" datasource="#dsn#">
							INSERT INTO
								#questionChoiceTbl#
							(
								questionID,
								choiceVal,
								choiceText
							)
							VALUES
							(
								<cfqueryparam value="#VAL(qInsertQuestion.newID)#" cfsqltype="CF_SQL_INTEGER" />,
								<cfqueryparam value="0" cfsqltype="CF_SQL_INTEGER" />,
								<cfqueryparam value="No" cfsqltype="CF_SQL_VARCHAR" />
							)
						</cfquery>
					</cfif>
				</cfif>
			</cfloop>
		</cftransaction>

		<cfreturn stSuccess />
	</cffunction>

	<cffunction name="deleteSurvey" access="public" displayname="deleteSurvey" hint="Deletes Survey" output="No" returntype="struct">
		<cfargument name="formfields" required="yes" type="struct" />
		<cfargument name="dsn" required="yes" type="string" />
		<cfargument name="surveyTbl" required="yes" type="string" />
		<cfargument name="surveyUserTbl" required="yes" type="string" />
		<cfargument name="questionTbl" required="yes" type="string" />
		<cfargument name="questionChoiceTbl" required="yes" type="string" />
		<cfargument name="updatingUser" required="yes" type="numeric" />

		<cfset var stSuccess = StructNew() />
		<cfset stSuccess.success = true />
		<cfset stSuccess.reason = "" />

		<cftransaction isolation="SERIALIZABLE">
			<!--- Delete Users --->
			<cfquery name="qDeleteUsers" datasource="#dsn#">
				UPDATE
					#surveyUserTbl#
				SET
					active_code = 0
				WHERE
					surveyID = <cfqueryparam value="#VAL(formfields.surveyID)#" cfsqltype="CF_SQL_INTEGER" />
			</cfquery>

			<!--- Delete any existing questions and choices --->
			<cfquery name="qDeleteChoices" datasource="#dsn#">
				DELETE FROM
					#questionChoiceTbl#
				WHERE
					questionID IN
					(
						SELECT
							questionID
						FROM
							#questionTbl#
						WHERE
							surveyID = <cfqueryparam value="#VAL(formfields.surveyID)#" cfsqltype="CF_SQL_INTEGER" />
					)
			</cfquery>
		
			<cfquery name="qDeleteQuestions" datasource="#dsn#">
				DELETE FROM
					#questionTbl#
				WHERE
					surveyID = <cfqueryparam value="#VAL(formfields.surveyID)#" cfsqltype="CF_SQL_INTEGER" />
			</cfquery>

			<!--- Delete Survey --->
			<cfquery name="qDeleteSurvey" datasource="#dsn#">
				UPDATE
					#surveyTbl#
				SET
					activeCode = 0,
					modifiedUser = <cfqueryparam value="#VAL(updatingUser)#" cfsqltype="CF_SQL_INTEGER" />,
					modifiedDate = GetDate()
				WHERE
					surveyID = <cfqueryparam value="#VAL(formfields.surveyID)#" cfsqltype="CF_SQL_INTEGER" />
			</cfquery>
		</cftransaction>

		<cfreturn stSuccess />
	</cffunction>

	<cffunction name="activateSurvey" access="public" displayname="activateSurvey" hint="Activates Survey" output="No" returntype="struct">
		<cfargument name="dsn" required="yes" type="string" />
		<cfargument name="surveyTbl" required="yes" type="string" />
		<cfargument name="surveyUserTbl" required="yes" type="string" />
		<cfargument name="userTbl" required="yes" type="string" />
		<cfargument name="user_statusTbl" required="yes" type="string" />
		<cfargument name="practice_transactionTbl" required="yes" type="string" />
		<cfargument name="transaction_typeTbl" required="yes" type="string" />
		<cfargument name="preferenceTbl" required="yes" type="string" />
		<cfargument name="surveyResponseTbl" required="yes" type="string" />
		<cfargument name="surveyID" required="yes" type="numeric" />
		<cfargument name="activityDays" required="yes" type="numeric" />
		<cfargument name="emailURL" required="yes" type="string" />
		<cfargument name="loginURL" required="yes" type="string" />
		<cfargument name="updatingUser" required="yes" type="numeric" />
		<cfargument name="encKey" required="yes" type="string" />
		<cfargument name="lookupCFC" required="yes" type="lookup_queries" />

		<cfset var sid = "" />
		<cfset var qSurvey = "" />
		<cfset var qEmail = "" />
		<cfset var stSuccess = StructNew() />
		<cfset stSuccess.success = true />
		<cfset stSuccess.reason = "" />

		<cftransaction>
			<!--- Update Survey --->
			<cfquery name="qActivate" datasource="#dsn#">
				UPDATE
					#surveyTbl#
				SET
					isLive = 1,
					modifiedUser = <cfqueryparam value="#VAL(updatingUser)#" cfsqltype="CF_SQL_INTEGER" />,
					modifiedDate = GetDate()
				WHERE
					surveyID = <cfqueryparam value="#VAL(surveyID)#" cfsqltype="CF_SQL_INTEGER" />
			</cfquery>

		</cftransaction>

		<!--- Get survey info --->
		<cfset qSurvey = getSurveys(dsn,surveyTbl,surveyUserTbl,surveyResponseTbl,userTbl,surveyID) />
		
		<cfif qSurvey.allUsersYN>
			<!--- If the survey is open to all users, get them --->
			<cfset qEmail = lookupCFC.getMembers(dsn,userTbl,user_statusTbl,practice_transactionTbl,transaction_typeTbl,0,activityDays,"Member") />
		<cfelse>
			<!--- Otherwise, get specific user info for this survey --->
			<cfset qEmail = getSurveyUsers(dsn,userTbl,surveyUserTbl,preferenceTbl,surveyID) />
		</cfif>

		<!--- Generate e-mail content --->
		<cfset mailSubject = "<squid-survey> New SQUID Survey: ""#qSurvey.surveyName#""" />
		<cfoutput>
		<cfsavecontent variable="htmlContent">
		<html>
			<body>
				<p>
					<firstName>,
				</p>
				<p>
					You have a new survey from the SQUID Swim Team.  To fill out the survey,
					please use the following link:
				</p>
				<p>
					<a href="#emailURL#[:sid:].cfm">#qSurvey.surveyName#</a>*
				</p>
				<p>
					If you have any questions or problems accessing this survey, please reply to this e-mail.
				</p>
				<p style="font-style:italics;">
					*You may also <a href="#arguments.loginURL#">log in</a> to access your SQUID surveys.  
					Your responses to any survey will be completely anonymous.
				</p>
			</body>
		</html>
		</cfsavecontent>
<cfsavecontent variable="plainContent">
<firstName>,

You have a new survey from the SQUID Swim Team.  To fill out the survey, please use the following link:

#qSurvey.surveyName#:
<#emailURL#[:sid:].cfm>*

If you have any questions, please reply to this e-mail.

*You may also log in to access your SQUID surveys, by using the following link:
<#arguments.loginURL#>  

Your responses to any survey will be completely anonymous.
</cfsavecontent>
		</cfoutput>

		<!--- Send e-mail --->
		<cfloop query="qEmail">
			<cfif LEN(TRIM(qEmail.email))>
				<cfif LEN(TRIM(qEmail.preferred_name))>
					<cfset toName = qEmail.preferred_name />
				<cfelse>
					<cfset toName = qEmail.first_name />
				</cfif>
				<cfset sid = Encrypt("surveyID|" & arguments.surveyID & "|userID|" & qEmail.user_ID,arguments.encKey,"DESEDE","HEX") />
				<cfset toName = toName & " " & qEmail.last_name />
				<cfmail replyto="#qSurvey.creatorName# <#qSurvey.creatorEmail#>" from="squid@squidswimteam.org" to="#qEmail.email#" subject="#mailSubject#" server="mail.squidswimteam.org">
					<cfmailpart type="text/plain" wraptext="50">#ReplaceNoCase(ReplaceNocase(plainContent,"[:sid:]",sid,"ALL"),"<firstName>",toName)#</cfmailpart>
					<cfmailpart type="text/html">#wrap(ReplaceNoCase(ReplaceNoCase(htmlContent,"[:sid:]",sid,"ALL"),"<firstName>",toName),60)#</cfmailpart>
				</cfmail>
			</cfif>
		</cfloop>

		<cfreturn stSuccess />
	</cffunction>

	<cffunction name="getQuestionResults" access="public" displayname="getQuestionResults" hint="Gets query of question results" output="No" returntype="query">
		<cfargument name="dsn" required="yes" type="string" />
		<cfargument name="surveyTbl" required="yes" type="string" />
		<cfargument name="surveyResponseTbl" required="yes" type="string" />
		<cfargument name="questionTbl" required="yes" type="string" />
		<cfargument name="questionChoiceTbl" required="yes" type="string" />
		<cfargument name="questionTypeTbl" required="yes" type="string" />
		<cfargument name="surveyID" required="yes" type="numeric" />
		<cfargument name="questionID" required="yes" type="numeric" />
		<cfargument name="questionType" required="yes" type="string" />
		<cfargument name="choiceVal" required="yes" type="string" />

		<cfset var qData = "" />
	
		<cfquery name="qData" datasource="#dsn#">
		<cfswitch expression="#questionType#">
			<cfcase value="Long-Answer">
				SELECT
					sr.responseID,
					CAST(sr.responseLong AS nvarchar(4000)) AS surveyResponse
				FROM
					#surveyResponseTbl# sr
				WHERE
					sr.surveyID = <cfqueryparam value="#VAL(surveyID)#" cfsqltype="CF_SQL_INTEGER" />
					AND sr.questionID = <cfqueryparam value="#VAL(questionID)#" cfsqltype="CF_SQL_INTEGER" />
					AND sr.responseLong IS NOT NULL
				ORDER BY
					sr.responseID
			</cfcase>
			<cfcase value="Short-Answer">
				SELECT
					sr.responseID,
					sr.response AS surveyResponse
				FROM
					#surveyResponseTbl# sr
				WHERE
					sr.surveyID = <cfqueryparam value="#VAL(surveyID)#" cfsqltype="CF_SQL_INTEGER" />
					AND sr.questionID = <cfqueryparam value="#VAL(questionID)#" cfsqltype="CF_SQL_INTEGER" />
					AND sr.response IS NOT NULL
				ORDER BY
					sr.responseID
			</cfcase>
			<cfcase value="Yes/No,Choose One,Choose One or More">
				SELECT
					COUNT(sr.response) AS responseCount,
					sc.choiceText AS surveyResponse
				FROM
					#surveyResponseTbl# sr
					INNER JOIN #questionChoiceTbl# sc
					ON (sr.questionID = sc.questionID AND sr.response = sc.choiceVal)
				WHERE
					sr.surveyID = <cfqueryparam value="#VAL(surveyID)#" cfsqltype="CF_SQL_INTEGER" />
					AND sr.questionID = <cfqueryparam value="#VAL(questionID)#" cfsqltype="CF_SQL_INTEGER" />
					AND sc.choiceVal = <cfqueryparam value="#VAL(choiceVal)#" cfsqltype="CF_SQL_INTEGER" />
				GROUP BY
					sc.choiceText,
					sc.choiceVal
			</cfcase>
		</cfswitch>

		</cfquery>

		<cfreturn qdata />
	</cffunction>

	<cffunction name="getIndividualResults" access="public" displayname="getIndividualResults" hint="Gets query of all survey results broken down by individual" output="No" returntype="query">
		<cfargument name="dsn" required="yes" type="string" />
		<cfargument name="surveyTbl" required="yes" type="string" />
		<cfargument name="surveyResponseTbl" required="yes" type="string" />
		<cfargument name="questionTbl" required="yes" type="string" />
		<cfargument name="questionChoiceTbl" required="yes" type="string" />
		<cfargument name="questionTypeTbl" required="yes" type="string" />
		<cfargument name="surveyID" required="yes" type="numeric" />

		<cfset var qData = "" />
	
		<cfquery name="qData" datasource="#dsn#">
			<!--- Long-Answer and Short-Answer --->
			SELECT
				CASE WHEN 
					qt.questionType = 'Long-Answer'
				THEN
					CAST(sr.responseLong AS nvarchar(4000))
				ELSE
					sr.response
				END AS surveyResponse,
				sr.questionID,
				q.questionText,
				sr.uniqueResponseID,
				qt.questionType,
				q.displayOrder
			FROM
				#surveyResponseTbl# sr
				INNER JOIN #questionTbl# q
				ON sr.questionID = q.surveyQuestionID
					INNER JOIN #questionTypeTbl# qt
					ON q.questionTypeID = qt.questionTypeID
			WHERE
				sr.surveyID = <cfqueryparam value="#VAL(surveyID)#" cfsqltype="CF_SQL_INTEGER" />
				AND 
				(
					qt.questionType = 'Long-Answer'
					OR qt.questionType = 'Short-Answer'
				)
		UNION
			<!--- Multiple Choice and Yes/No --->
			SELECT
				qc.choiceText AS surveyResponse,
				sr.questionID,
				q.questionText,
				sr.uniqueResponseID,
				qt.questionType,
				q.displayOrder
			FROM
				#surveyResponseTbl# sr
				INNER JOIN #questionTbl# q
				ON sr.questionID = q.surveyQuestionID
					INNER JOIN #questionTypeTbl# qt
					ON q.questionTypeID = qt.questionTypeID
						INNER JOIN #questionChoiceTbl# qc
						ON (sr.questionID = qc.questionID AND sr.response = qc.choiceVal)
			WHERE
				sr.surveyID = <cfqueryparam value="#VAL(surveyID)#" cfsqltype="CF_SQL_INTEGER" />
				AND 
				(
					qt.questionType = 'Yes/No'
					OR qt.questionType = 'Choose One'
					OR qt.questionType = 'Choose One or More'
				)
			ORDER BY
				uniqueResponseID,
				displayOrder
		</cfquery>

		<cfreturn qdata />
	</cffunction>

	<cffunction name="getEncryptedSurvey" access="public" displayname="Get Encrypted Survey" hint="Gets the user ID and Survey ID for an encrypted sid" output="No" returntype="struct">
		<cfargument name="enckey" required="yes" type="string" />
		<cfargument name="sid" required="yes" type="string" />

		<cfset var decrypted = "" />
		<cfset var stResults = StructNew() />
		<cfset stResults.surveyID = 0 />
		<cfset stResults.userID = 0 />

		<cfif LEN(arguments.sid)>
			<cfset decrypted = Decrypt(arguments.sid,arguments.encKey,"DESEDE","HEX") />
			<cfif ListLen(decrypted,"|") EQ 4>
				<cfset stResults.surveyID = ListGetAt(decrypted,2,"|") />
				<cfset stResults.userID = ListGetAt(decrypted,4,"|") />
			</cfif>
		</cfif>

		<cfreturn stResults />
	</cffunction>
</cfcomponent>
