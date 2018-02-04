<cfcomponent displayname="Lookup Queries" hint="Lookup Queries">
	<cffunction name="getEventTypes" access="public" displayname="Get Event Types" hint="Gets event types" output="No" returntype="query">
		<cfargument name="dsn" required="yes" type="string">
		<cfargument name="event_typeTbl" required="yes" type="string">
		<cfargument name="event_type_id" required="no" default="0" type="numeric">

		<cfquery name="qryTypes" datasource="#arguments.DSN#">
			SELECT
				et.event_type_id,
				et.event_type,
				et.icon
			FROM
				#arguments.event_typeTbl# et
		<cfif VAL(arguments.event_type_id) GT 0>
			WHERE
				et.event_type_id = <cfqueryparam value="#VAL(arguments.event_type_id)#" cfsqltype="CF_SQL_INTEGER">
		</cfif>
			ORDER BY
				et.event_type
		</cfquery>

		<cfreturn qryTypes />
	</cffunction>

	<cffunction name="getFreq" access="public" displayname="Get Frequencies" hint="Gets Frequencies" output="No" returntype="query">
		<cfargument name="dsn" required="yes" type="string">
		<cfargument name="frequencyTbl" required="yes" type="string">
		<cfargument name="frequency_id" required="no" default="0" type="numeric">

		<cfquery name="qryFreq" datasource="#arguments.DSN#">
			SELECT
				f.frequency_id,
				f.frequency,
				f.part
			FROM
				#arguments.frequencyTbl# f
		<cfif VAL(arguments.frequency_id) GT 0>
			WHERE
				f.frequency_id = <cfqueryparam value="#VAL(arguments.frequency_id)#" cfsqltype="CF_SQL_INTEGER">
		</cfif>
			ORDER BY
				f.frequency_id
		</cfquery>

		<cfreturn qryFreq />
	</cffunction>

	<cffunction name="getLinks" access="public" displayname="Gets Links" hint="Gets Links" output="No" returntype="query">
		<cfargument name="dsn" required="yes" type="string">
		<cfargument name="linksTbl" required="yes" type="string">
		<cfargument name="links_categoryTbl" required="yes" type="string">
		<cfargument name="link_id" required="no" default="0" type="numeric">
		<cfargument name="category_id" required="no" default="0" type="numeric">

		<cfquery name="qryLinks" datasource="#arguments.DSN#">
			SELECT
				l.link_id,
				l.category_id,
				l.name,
				l.url,
				l.description,
				l.display_order,
				c.category
			FROM
				#arguments.linksTbl# l,
				#arguments.links_categoryTbl# c
			WHERE
				l.category_id = c.category_id
				AND l.active_code = 1
			<cfif VAL(arguments.link_id) GT 0>
				AND l.link_id = <cfqueryparam value="#VAL(arguments.link_id)#" cfsqltype="CF_SQL_INTEGER">
			</cfif>
			<cfif VAL(arguments.category_id) GT 0>
				AND l.category_id = <cfqueryparam value="#VAL(arguments.category_id)#" cfsqltype="CF_SQL_INTEGER">
			</cfif>
			ORDER BY
				c.display_order,
				l.display_order
		</cfquery>

		<cfreturn qryLinks />
	</cffunction>

	<cffunction name="getLinkCategories" access="public" displayname="Get Link Categories" hint="Gets Link Categories" output="No" returntype="query">
		<cfargument name="dsn" required="yes" type="string">
		<cfargument name="categoryTbl" required="yes" type="string">

		<cfquery name="qryCats" datasource="#arguments.DSN#">
			SELECT
				c.category_id,
				c.category
			FROM
				#arguments.categoryTbl# c
			WHERE
				c.active_code = 1
			ORDER BY
				c.display_order
		</cfquery>

		<cfreturn qryCats />
	</cffunction>

	<cffunction name="getGalleryFiles" access="public" displayname="Gets Gallery Files" hint="Gets the Gallery files for a page" output="No" returntype="query">
		<cfargument name="dsn" required="yes" type="string">
		<cfargument name="galleryTbl" required="yes" type="string">
		<cfargument name="fileTbl" required="yes" type="string">
		<cfargument name="file_typeTbl" required="yes" type="string">
		<cfargument name="categoryTbl" required="yes" type="string">
		<cfargument name="page_id" required="no" default=0 type="numeric">

		<cfquery name="qryGallery" datasource="#arguments.DSN#">
			SELECT
				g.gallery_id,
				g.file_id,
				g.page_id,
				CASE WHEN g.link_id IS NULL THEN
					0
				ELSE
					g.link_id
				END AS link_id,
				g.display_order,
				f.filename,
				l.filename AS link_file,
				f.description,
				f.file_type_id,
				f.category_id,
				ft.file_type,
				c.category
			FROM
				(
					(
						(
							#arguments.galleryTbl# g
							INNER JOIN
							#arguments.fileTbl# f
							ON g.file_id = f.file_id
						)
						INNER JOIN
						#arguments.file_typeTbl# ft
						ON f.file_type_id = ft.file_type_id
					)
					INNER JOIN
					#arguments.categoryTbl# c
					ON f.category_id = c.category_id
				)
				LEFT OUTER JOIN
				#arguments.fileTbl# l
				ON g.link_id = l.file_id
			WHERE
				g.active_code = 1
			<cfif VAL(arguments.page_id) GT 0>
				AND g.page_id = <cfqueryparam value="#VAL(arguments.page_id)#" cfsqltype="CF_SQL_INTEGER">
			</cfif>
			ORDER BY
				g.display_order
		</cfquery>

		<cfreturn qryGallery />
	</cffunction>

	<cffunction name="getMinMaxValue" access="public" displayname="Get Minimum and Maximum Values" hint="Gets Minimum and Maximum values from a table" output="No" returntype="query">
		<cfargument name="dsn" required="yes" type="string">
		<cfargument name="tblName" required="yes" type="string">
		<cfargument name="field" required="yes" type="string">
		<cfargument name="activeField" required="no" type="string" default="">

		<cfquery name="qryMinMax" datasource="#arguments.DSN#">
			SELECT
				MIN(#arguments.field#) AS minVal,
				MAX(#arguments.field#) AS maxVal
			FROM
				#arguments.tblName#
		<cfif LEN(TRIM(arguments.activeField))>
			WHERE
				#arguments.activeField# = 1
		</cfif>
		</cfquery>

		<cfreturn qryMinMax />
	</cffunction>

	<cffunction name="getNews" access="public" displayname="Get News Items" hint="Gets Query of News Items" output="No" returntype="query">
		<cfargument name="dsn" required="yes" type="string">
		<cfargument name="newsTbl" required="yes" type="string">
		<cfargument name="date_from" required="no" default="" type="string">
		<cfargument name="date_to" required="no" default="" type="string">
		<cfargument name="news_id" required="no" default=0 type="numeric">
		<cfargument name="getAnnouncements" required="no" default="false" type="boolean">

		<cfquery name="qryNews" datasource="#arguments.DSN#">
			SELECT
				n.news_id,
				n.headline,
				CAST(n.article AS nvarchar(3000)) AS article,
				n.date_start,
				n.date_end,
				'News' AS newsType
			FROM
				#arguments.newsTbl# n
			WHERE
				n.active_code = 1
			<cfif VAL(arguments.news_id) GT 0>
				AND n.news_id = <cfqueryparam value="#VAL(arguments.news_id)#" cfsqltype="CF_SQL_INTEGER">
			</cfif>
			<cfif IsDate(arguments.date_from) AND IsDate(arguments.date_to)>
				AND
				(
					n.date_start <= <cfqueryparam value="#ParseDateTime(arguments.date_to)#" cfsqltype="CF_SQL_TIMESTAMP">
					AND n.date_end >= <cfqueryparam value="#ParseDateTime(arguments.date_from)#" cfsqltype="CF_SQL_TIMESTAMP">
				)
			</cfif>
	<cfif arguments.getAnnouncements>
		UNION
			SELECT
				a.announcement_id AS news_id,
				a.subject AS headline,
				CAST(a.announcement AS nvarchar(3000)) AS article,
				a.date_approved AS date_start,
				CASE WHEN
					a.eventDate IS NOT NULL
				THEN
					a.eventDate
				ELSE
					'12/31/9999'
				END AS date_end,
				'Announcement' AS newsType
			FROM
				announcements a
			WHERE
				a.isPublic = 1
				AND a.active_code = 1
				AND a.date_approved IS NOT NULL
			<cfif IsDate(arguments.date_from) AND IsDate(arguments.date_to)>
				AND
				(
					a.date_approved <= <cfqueryparam value="#ParseDateTime(arguments.date_to)#" cfsqltype="CF_SQL_TIMESTAMP">
					AND
					(
						a.eventDate >= <cfqueryparam value="#ParseDateTime(arguments.date_from)#" cfsqltype="CF_SQL_TIMESTAMP">
						OR a.eventDate IS NULL
					)
				)
			</cfif>
	</cfif>
			ORDER BY
				date_start DESC,
				date_end DESC
		</cfquery>

		<cfreturn qryNews>
	</cffunction>

	<cffunction name="getContent" access="public" displayname="Get Content" hint="Gets Query of Content" output="No" returntype="query">
		<cfargument name="dsn" required="yes" type="string">
		<cfargument name="pageTbl" required="yes" type="string">
		<cfargument name="galleryTbl" required="no" default="galleryTbl" type="string">
		<cfargument name="page" required="yes" type="string">
		<cfargument name="parent_id" required="no" default="0" type="numeric">
		<cfargument name="page_id" required="no" default="0" type="numeric">

		<cfquery name="qryContent" datasource="#arguments.DSN#">
			SELECT
				p.page_id,
				p.parent_id,
				p.page,
				p.title,
			<cfif (CompareNoCase(arguments.page,"Gallery") EQ 0) AND (parent_id GT 0)>
				COUNT(g.gallery_id) AS numFiles,
			</cfif>
			<cfif (CompareNoCase(arguments.page,"Gallery") EQ 0) AND (parent_id GT 0)>
				CAST(p.content AS nvarchar(4000)) AS content
			<cfelse>
				p.content
			</cfif>
			FROM
				#arguments.pageTbl# p
			<cfif (CompareNoCase(arguments.page,"Gallery") EQ 0) AND (parent_id GT 0)>
				LEFT JOIN
				#arguments.galleryTbl# g
				ON
				(
					p.page_id = g.page_id
					AND g.active_code = 1
				)
			</cfif>
			WHERE
				p.active_code = 1
				AND UPPER(p.page) = <cfqueryparam value="#UCASE(arguments.page)#" cfsqltype="CF_SQL_VARCHAR">
				AND p.parent_id = <cfqueryparam value="#VAL(arguments.parent_id)#" cfsqltype="CF_SQL_INTEGER">
			<cfif VAL(arguments.page_id) GT 0>
				AND p.page_id = <cfqueryparam value="#VAL(arguments.page_id)#" cfsqltype="CF_SQL_INTEGER">
			</cfif>
		<cfif (CompareNoCase(arguments.page,"Gallery") EQ 0) AND (parent_id GT 0)>
			GROUP BY
				p.page_id,
				p.parent_id,
				p.page,
				p.title,
				CAST(p.content AS nvarchar(4000)),
				p.display_order
		</cfif>
			ORDER BY
				p.display_order ASC
		</cfquery>

		<cfreturn qryContent>
	</cffunction>

	<cffunction name="getFiles" access="public" displayname="Get Files" hint="Gets Query of Files" output="No" returntype="query">
		<cfargument name="dsn" required="yes" type="string">
		<cfargument name="fileTbl" required="yes" type="string">
		<cfargument name="file_typeTbl" required="yes" type="string">
		<cfargument name="file_categoryTbl" required="yes" type="string">
		<cfargument name="file_id" required="no" default="0" type="numeric">
		<cfargument name="file_type_id" required="no" default="0" type="numeric">
		<cfargument name="category_id" required="no" default="0" type="numeric">
		<cfargument name="imageYN" required="no" default="" type="string">
		<cfargument name="categoryName" required="no" default="" type="string" />
		<cfargument name="orderBy" required="no" default="f.fileName" type="string" />

		<cfquery name="qryFiles" datasource="#arguments.DSN#">
			SELECT
				f.file_id,
				f.filename,
				f.file_type_id,
				f.category_id,
				f.description,
				ft.file_type,
				c.category
			FROM
				#arguments.fileTbl# f,
				#arguments.file_typeTbl# ft,
				#arguments.file_categoryTbl# c
			WHERE
				f.active_code = 1
				AND f.file_type_id = ft.file_type_id
				AND f.category_id = c.category_id
			<cfif VAL(arguments.file_type_id)>
				AND f.file_type_id = <cfqueryparam value="#arguments.file_type_id#" cfsqltype="CF_SQL_INTEGER">
			<cfelseif LEN(TRIM(arguments.imageYN))>
				AND f.file_type_id
				<cfif NOT arguments.imageYN>
					<>
				<cfelse>
					=
				</cfif>
				1
			</cfif>
			<cfif VAL(arguments.category_id)>
				AND f.category_id = <cfqueryparam value="#arguments.category_id#" cfsqltype="CF_SQL_INTEGER">
			</cfif>
			<cfif VAL(arguments.file_id)>
				AND f.file_id = <cfqueryparam value="#arguments.file_id#" cfsqltype="CF_SQL_INTEGER">
			</cfif>
			<cfif LEN(TRIM(arguments.categoryName))>
				AND lower(c.category) = <cfqueryparam value="#LCASE(arguments.categoryName)#" cfsqltype="CF_SQL_VARCHAR" />
			</cfif>
			ORDER BY
				#arguments.orderBy#
		</cfquery>

		<cfreturn qryFiles>
	</cffunction>

	<cffunction name="getFileTypes" access="public" displayname="Get File Types" hint="Gets Query of File Types" output="No" returntype="query">
		<cfargument name="dsn" required="yes" type="string">
		<cfargument name="file_typeTbl" required="yes" type="string">

		<cfquery name="qryFileTypes" datasource="#arguments.DSN#">
			SELECT
				ft.file_type_id,
				ft.file_type
			FROM
				#arguments.file_typeTbl# ft
			ORDER BY
				ft.file_type
		</cfquery>

		<cfreturn qryFileTypes>
	</cffunction>

	<cffunction name="getCategories" access="public" displayname="Get Categories" hint="Gets Query of Categories" output="No" returntype="query">
		<cfargument name="dsn" required="yes" type="string">
		<cfargument name="categoryTbl" required="yes" type="string">

		<cfquery name="qryCats" datasource="#arguments.DSN#">
			SELECT
				c.category_id,
				c.category
			FROM
				#arguments.categoryTbl# c
			ORDER BY
				c.category
		</cfquery>

		<cfreturn qryCats>
	</cffunction>

	<cffunction name="getTransactionTypes" access="public" displayname="Get Transaction Types" hint="Gets Query of Transaction Types" output="No" returntype="query">
		<cfargument name="dsn" required="yes" type="string">
		<cfargument name="transaction_typeTbl" required="yes" type="string">
		<cfargument name="transaction_type_id" required="no" default="0" type="numeric">
		<cfargument name="getPractices" required="no" default="true" type="boolean">
		<cfargument name="transaction_type" required="no" default="" type="string">

		<cfquery name="qryTransTypes" datasource="#arguments.DSN#">
			SELECT
				transaction_type_id,
				transaction_type,
				default_swims
			FROM
				#arguments.transaction_typeTbl#
			WHERE
				active_code = 1
			<cfif VAL(arguments.transaction_type_id)>
				AND transaction_type_id = <cfqueryparam value="#arguments.transaction_type_id#" cfsqltype="CF_SQL_INTEGER">
			</cfif>
			<cfif NOT getPractices>
				AND UPPER(transaction_type) NOT IN ('SWIM WORKOUT','VISIT WORKOUT')
			</cfif>
			<cfif LEN(TRIM(arguments.transaction_type))>
				AND UPPER(transaction_type) = <cfqueryparam value="#UCASE(arguments.transaction_type)#" cfsqltype="CF_SQL_VARCHAR">
			</cfif>
		</cfquery>

		<cfreturn qryTransTypes>
	</cffunction>

	<cffunction name="getTransactions" access="public" displayname="Get Transactions" hint="Gets Query of Transactions" output="No" returntype="query">
		<cfargument name="transaction_id" required="no" default="0" type="numeric">
		<cfargument name="member_id" required="no" default="0" type="numeric">
		<cfargument name="practice_id" required="no" default="0" type="numeric">
		<cfargument name="dsn" required="yes" type="string">
		<cfargument name="usersTbl" required="yes" type="string">
		<cfargument name="user_statusTbl" required="yes" type="string">
		<cfargument name="transactionTbl" required="yes" type="string">
		<cfargument name="practiceTbl" required="yes" type="string">
		<cfargument name="transaction_typeTbl" required="yes" type="string">
		<cfargument name="facilityTbl" required="yes" type="string">
		<cfargument name="date_start" required="no" default="" type="string">
		<cfargument name="date_end" required="no" default="" type="string">
		<cfargument name="memberType" required="no" default="" type="string">
		<cfargument name="paymentConfirmed" required="no" default="1" type="boolean">
		<cfargument name="transactionCategory" default="debit" type="string" />

		<cfquery name="qryTrans" datasource="#arguments.DSN#">
			SELECT
				t.transaction_id,
				t.member_id,
				t.num_swims,
				t.practice_id,
				t.transaction_type_id,
				t.date_transaction,
				t.paymentConfirmed,
				t.usersSwimPassID,
				p.facility_id,
				p.coach_id,
				t.notes,
				m.first_name AS memberFirst,
				isNull(m.preferred_name,m.first_name) AS memberPref,
				m.last_name AS memberLast,
				m.email AS memberEmail,
				ms.status AS memberStatus,
				tt.transaction_type,
				f.facility,
				c.first_name AS coachFirst,
				c.preferred_name AS coachPref,
				c.last_name AS coachLast,
				sp.swimPass
			FROM
				(
					(
						(
							(
								#arguments.transactionTbl# t
								INNER JOIN
								(
									#arguments.usersTbl# m
									INNER JOIN #arguments.user_statusTbl# ms
									ON m.user_status_id = ms.user_status_id
								)
								ON m.user_id = t.member_id
							)
							INNER JOIN
							#arguments.transaction_typeTbl# tt
							ON t.transaction_type_id = tt.transaction_type_id
						)
						LEFT JOIN
						#arguments.practiceTbl# p
						ON t.practice_id = p.practice_id
					)
					LEFT JOIN
					#arguments.facilityTbl# f
					ON p.facility_id = f.facility_id
				)
				LEFT JOIN
				#arguments.usersTbl# c
				ON c.user_id = p.coach_id
				LEFT JOIN
				(
					usersSwimPasses usp
					LEFT JOIN swimPasses sp
					ON usp.swimPassID = sp.swimPassID
				)
				ON t.usersSwimPassID = usp.usersSwimPassID
			WHERE
				t.active_code = 1
			<cfif LEN(TRIM(arguments.date_start))>
				AND t.date_transaction >= <cfqueryparam value="#arguments.date_start#" cfsqltype="CF_SQL_DATE">
			</cfif>
			<cfif LEN(TRIM(arguments.date_end))>
				<cfset dateEnd = CreateDateTime(Year(arguments.date_end),Month(arguments.date_end),Day(arguments.date_end),23,59,59) />
				AND t.date_transaction <= <cfqueryparam value="#dateEnd#" cfsqltype="CF_SQL_TIMESTAMP">
			</cfif>
			<cfif VAL(arguments.transaction_id)>
				AND t.transaction_id = <cfqueryparam value="#arguments.transaction_id#" cfsqltype="CF_SQL_INTEGER">
			</cfif>
			<cfif VAL(arguments.member_id)>
				AND t.member_id = <cfqueryparam value="#arguments.member_id#" cfsqltype="CF_SQL_INTEGER">
			</cfif>
			<cfif arguments.transactionCategory EQ "credit">
				AND UPPER(tt.transaction_type) NOT IN ('SWIM WORKOUT','VISIT WORKOUT')
			<cfelseif arguments.transactionCategory EQ "debit">
				AND UPPER(tt.transaction_type) IN ('SWIM WORKOUT','VISIT WORKOUT')
			</cfif>
			<cfif VAL(arguments.practice_id)>
				AND t.practice_id = <cfqueryparam value="#arguments.practice_id#" cfsqltype="CF_SQL_INTEGER">
			</cfif>
			<cfif LEN(TRIM(arguments.memberType))>
				AND UPPER(ms.status) LIKE <cfqueryparam value="%#UCASE(arguments.memberType)#" cfsqltype="CF_SQL_VARCHAR">
			</cfif>
				AND t.paymentConfirmed = <cfqueryparam value="#paymentConfirmed#" cfsqltype="CF_SQL_BIT" />
			ORDER BY
				t.date_transaction
		</cfquery>

		<cfreturn qryTrans>
	</cffunction>

	<cffunction name="getPaypalPurchaseTransaction" access="public" output="false" returntype="query">
		<cfargument name="transactionID" required="true" type="numeric" />
		<cfargument name="memberID" required="true" type="numeric" />
		<cfargument name="dsn" required="true" type="string" />

		<cfset local = structNew() />
		<cfset local.qTransaction = "" />

		<cfquery name="local.qTransaction" datasource="squidSQL">
			SELECT
				t.transaction_id,
				t.member_id,
				t.num_swims,
				t.practice_id,
				t.transaction_type_id,
				t.date_transaction,
				t.paymentConfirmed,
				t.usersSwimPassID,
				t.notes,
				m.first_name AS memberFirst,
				m.preferred_name AS memberPref,
				m.last_name AS memberLast,
				m.email AS memberEmail
			FROM
				practiceTransactions t
				INNER JOIN users m ON t.member_id = m.user_id
			WHERE
				t.active_code = 1
				AND t.transaction_id = <cfqueryparam value="#arguments.transactionID#" cfsqltype="cf_sql_bigint" />
				AND t.member_id = <cfqueryparam value="#arguments.memberID#" cfsqltype="cf_sql_integer" />
		</cfquery>

		<cfreturn local.qTransaction />
	</cffunction>
	<cffunction name="getUserStatuses" access="public" displayname="Get User Statuses" hint="Gets User Statuses" output="No" returntype="query">
		<cfargument name="dsn" required="no" type="string" default="squid">
		<cfargument name="user_statusTbl" required="yes" type="string">
		<cfargument name="status" required="no" type="string" default="">
		<cfargument name="user_status_id" required="no" type="numeric" default=0>

		<cfquery name="qryUserStatuses" datasource="#arguments.DSN#">
			SELECT
				s.user_status_id,
				s.status
			FROM
				#arguments.user_statusTbl# s
			WHERE
				1 = 1
		<cfif LEN(TRIM(arguments.status))>
				AND UPPER(s.status) = <cfqueryparam value="#UCASE(arguments.status)#" cfsqltype="CF_SQL_VARCHAR">
		</cfif>
		<cfif VAL(arguments.user_status_id)>
				AND s.user_status_id = <cfqueryparam value="#VAL(arguments.user_status_id)#" cfsqltype="CF_SQL_INTEGER">
		</cfif>
			ORDER BY
				s.status
		</cfquery>

		<cfreturn qryUserStatuses>
	</cffunction>

	<cffunction name="getPractices" access="public" displayname="Get Practices" hint="Gets Query of Practices" output="No" returntype="query">
		<cfargument name="practice_id" required="no" default="0" type="numeric">
		<cfargument name="dsn" required="yes" type="string">
		<cfargument name="usersTbl" required="yes" type="string">
		<cfargument name="practicesTbl" required="yes" type="string">
		<cfargument name="facilityTbl" required="yes" type="string">
		<cfargument name="date_start" required="no" default="" type="string">
		<cfargument name="date_end" required="no" default="" type="string">
		<cfargument name="practiceDate" required="no" default="" type="string">

		<cfquery name="qryPractices" datasource="#arguments.DSN#">
			SELECT
				p.practice_id,
				p.date_practice,
				p.members,
				p.guests,
				p.notes,
				p.facility_id,
				p.coach_id,
				CASE WHEN p.facility_id = 0 THEN
					'(No Facility)'
				ELSE
					f.facility
				END AS facility,
				CASE WHEN p.coach_id = 0 THEN
					'(No Coach)'
				ELSE
					c.preferred_name + ' ' + c.last_name
				END AS coach
			FROM
				(
					#arguments.practicesTbl# p
					LEFT OUTER JOIN
					#arguments.usersTbl# c
					ON p.coach_id = c.user_id
				)
				LEFT OUTER JOIN
				#arguments.facilityTbl# f
				ON p.facility_id = f.facility_id
			WHERE
				p.active_code = 1
			<cfif LEN(TRIM(arguments.date_start))>
				AND p.date_practice >= <cfqueryparam value="#arguments.date_start#" cfsqltype="CF_SQL_DATE">
			</cfif>
			<cfif LEN(TRIM(arguments.date_end))>
				AND p.date_practice <= <cfqueryparam value="#arguments.date_end#" cfsqltype="CF_SQL_DATE">
			</cfif>
			<cfif VAL(arguments.practice_id) GT 0>
				AND p.practice_id = <cfqueryparam value="#VAL(arguments.practice_id)#" cfsqltype="CF_SQL_INTEGER">
			</cfif>
			<cfif LEN(TRIM(arguments.practiceDate))>
				AND p.date_practice = <cfqueryparam value="#arguments.practiceDate#" cfsqltype="CF_SQL_DATE">
			</cfif>
			ORDER BY
				p.date_practice
		</cfquery>

		<cfreturn qryPractices>
	</cffunction>

	<cffunction name="getPracticeAttendees" access="public" displayname="Get PracticeAttendees" hint="Gets Query of Practice Attendees" output="No" returntype="query">
		<cfargument name="dsn" required="yes" type="string">
		<cfargument name="usersTbl" required="yes" type="string">
		<cfargument name="practice_transactionTbl" required="yes" type="string">
		<cfargument name="practice_id" required="no" default="0" type="numeric">

		<cfquery name="qryAttendees" datasource="#arguments.DSN#">
			SELECT
				pt.member_id,
				isNull(u.preferred_name,u.first_name) AS preferred_name,
				u.last_name
			FROM
				#arguments.practice_transactionTbl# pt,
				#arguments.usersTbl# u
			WHERE
				u.user_id = pt.member_id
				AND pt.active_code = 1
				AND pt.practice_id = <cfqueryparam value="#arguments.practice_id#" cfsqltype="CF_SQL_INTEGER">
		</cfquery>

		<cfreturn qryAttendees>
	</cffunction>

	<cffunction name="getSwimPasses" access="public" hint="Returns query of all swim passes" output="false" returntype="query">
		<cfargument name="dsn" required="true" type="string" />
		<cfargument name="swimPassID" required="true" type="numeric" />

		<cfset var local = structNew() />
		<cfset local.qPass = "" />

		<cfquery name="local.qPass" datasource="#arguments.dsn#">
			SELECT
				sp.swimPassID,
				sp.swimPass,
				sp.expirationUnitAbbreviation,
				sp.expirationUnit,
				sp.expirationNumber,
				sp.displayOrder,
				sp.price
			FROM
				swimPasses sp with(nolock)
			WHERE
				sp.active = 1
			<cfif val(arguments.swimPassID) GT 0>
				AND sp.swimPassID = <cfqueryparam value="#arguments.swimPassID#" cfsqltype="cf_sql_integer" />
			</cfif>
			ORDER BY
				sp.displayOrder
		</cfquery>

		<cfreturn local.qPass />
	</cffunction>

	<cffunction name="getUsersSwimPassesByID" access="public" hint="Returns query of users swim passes" output="false" returntype="query">
		<cfargument name="dsn" required="true" type="string" />
		<cfargument name="usersSwimPassID" required="true" type="numeric" />

		<cfset var local = structNew() />
		<cfset local.qPass = "" />

		<cfquery name="local.qPass" datasource="#arguments.dsn#">
			SELECT
				usp.usersSwimPassID,
				usp.userID,
				usp.swimPassID,
				usp.activeDate,
				usp.expirationDate,
				sp.swimPass,
				sp.expirationUnitAbbreviation,
				sp.expirationUnit,
				sp.expirationNumber,
				sp.displayOrder,
				sp.price
			FROM
				usersSwimPasses usp with(nolock)
				INNER JOIN swimPasses sp with(nolock)
				ON usp.swimPassID = sp.swimPassID
			WHERE
				sp.active = 1
			<cfif val(arguments.usersSwimPassID) GT 0>
				AND usp.usersSwimPassID = <cfqueryparam value="#arguments.usersSwimPassID#" cfsqltype="cf_sql_integer" />
			</cfif>
			ORDER BY
				usp.expirationDate DESC
		</cfquery>

		<cfreturn local.qPass />
	</cffunction>

	<cffunction name="getActiveUsersSwimPassesByUserIDAndDate" access="public" hint="Returns query of users swim passes by user and date" output="false" returntype="query">
		<cfargument name="dsn" required="true" type="string" />
		<cfargument name="userID" required="true" type="numeric" />
		<cfargument name="activeDate" required="true" type="date" />

		<cfset var local = structNew() />
		<cfset local.qPass = "" />

		<cfquery name="local.qPass" datasource="#arguments.dsn#">
			SELECT
				usp.usersSwimPassID,
				usp.userID,
				usp.swimPassID,
				usp.activeDate,
				usp.expirationDate,
				sp.swimPass,
				sp.expirationUnitAbbreviation,
				sp.expirationUnit,
				sp.expirationNumber,
				sp.displayOrder,
				sp.price
			FROM
				usersSwimPasses usp with(nolock)
				INNER JOIN swimPasses sp with(nolock)
				ON usp.swimPassID = sp.swimPassID
			WHERE
				usp.active = 1
				AND <cfqueryparam value="#arguments.activeDate#" cfsqltype="cf_sql_date" /> BETWEEN usp.activeDate AND (usp.expirationDate + 1)
			<cfif val(arguments.userID) GT 0>
				AND usp.userID = <cfqueryparam value="#arguments.userID#" cfsqltype="cf_sql_integer" />
			</cfif>
			ORDER BY
				usp.expirationDate DESC
		</cfquery>

		<cfreturn local.qPass />
	</cffunction>

	<cffunction name="getBalances" access="public" displayname="Get Balances" hint="Gets Swim Balances" output="No" returntype="query">
		<cfargument name="user_id" required="no" default="0" type="numeric">
		<cfargument name="dsn" required="yes" type="string">
		<cfargument name="usersTbl" required="yes" type="string">
		<cfargument name="transactionTbl" required="no" type="string">
		<cfargument name="user_statusTbl" required="yes" type="string">
		<cfargument name="transaction_typeTbl" required="no" type="string">
		<cfargument name="statusType" required="no" default="" type="string">
		<cfargument name="activitySort" required="no" default="no" type="boolean">
		<cfargument name="activityDays" required="no" default="90" type="numeric">
		<cfargument name="activityLevel" required="no" default="all" type="string" />

		<cfquery name="qryBalances" datasource="#arguments.DSN#">
			SELECT
				user_id,
				preferred_name,
				first_name,
				last_name,
				status,
				balance,
				lastPractice,
				activityLevel
			FROM
			(
				SELECT
					u.user_id,
					isNull(u.preferred_name,u.first_name) AS preferred_name,
					u.first_name,
					u.last_name,
					CASE WHEN us.status = 'Member' THEN
						'Member'
					ELSE
						'Non-Member'
					END AS status,
					SUM(t.num_swims) AS balance,
					MAX(t.date_transaction) AS lastPractice,
					CASE WHEN MAX(t.date_transaction) >= <cfqueryparam value="#CreateODBCDate(DateAdd("d",(0-VAL(arguments.activityDays)),Now()))#" cfsqltype="CF_SQL_DATE"> THEN
						'Active'
					ELSE
						'Inactive'
					END AS activityLevel
				FROM
					(
						#arguments.usersTbl# u LEFT OUTER JOIN
						#arguments.transactionTbl# t
						ON t.member_id = u.user_id
					)
					INNER JOIN
					#arguments.user_statusTbl# us
					ON us.user_status_id = u.user_status_id
				WHERE
					u.active_code = 1
			<cfif VAL(arguments.user_id) GT 0>
					AND u.user_id = <cfqueryparam value="#VAL(arguments.user_id)#" cfsqltype="CF_SQL_INTEGER">
			</cfif>
				<cfif structKeyExists(arguments,"paymentConfirmed")>
					AND t.paymentConfirmed = <cfqueryparam value="#paymentConfirmed#" cfsqltype="CF_SQL_BIT" />
				</cfif>
					AND t.active_code = 1
				GROUP BY
					u.user_id,
					u.last_name,
					u.preferred_name,
					u.first_name,
					us.status
			) balances
			WHERE 1 = 1
			<cfif arguments.activityLevel IS NOT "ALL">
				AND activityLevel = <cfqueryparam value="#arguments.activityLevel#" cfsqltype="cf_sql_varchar" />
			</cfif>
			<cfif LEN(TRIM(arguments.statusType)) AND arguments.statusType NEQ "ALL">
				AND UPPER(status) = <cfqueryparam value="#UCASE(arguments.statusType)#" cfsqltype="CF_SQL_VARCHAR">
			</cfif>
			ORDER BY
			<cfif arguments.activitySort>
				activityLevel,
			</cfif>
				last_name,
				preferred_name
		</cfquery>

		<cfreturn qryBalances>
	</cffunction>

	<cffunction name="getMembers" access="public" displayname="Get Members" hint="Gets Query of Members" output="No" returntype="query">
		<cfargument name="dsn" required="yes" type="string">
		<cfargument name="usersTbl" required="yes" type="string">
		<cfargument name="user_statusTbl" required="yes" type="string">
		<cfargument name="transactionTbl" required="yes" type="string">
		<cfargument name="transaction_typeTbl" required="yes" type="string">
		<cfargument name="user_id" required="no" default="0" type="numeric">
		<cfargument name="activityDays" required="no" default="90" type="numeric">
		<cfargument name="statusType" required="no" default="All" type="string">
		<cfargument name="activitySort" required="no" default="false" type="boolean">
		<cfargument name="getContactInfo" required="no" default="false" type="boolean">
		<cfargument name="userList" required="no" default="" type="string">
		<cfargument name="getVisibleOnly" required="no" default="false" type="boolean">
		<cfargument name="balanceDate" required="no" default="#Now()#" type="date">
		<cfargument name="mailingListOnly" required="no" default="false" type="boolean" />
		<cfargument name="officerTbl" required="No" type="string" default="officers" />
		<cfargument name="officerTypeTbl" required="No" type="string" default="officerTypes" />
		<cfargument name="filter" required="No" type="string" default="" hint="This is used to filter the last name or username" />
		<cfargument name="getMembersOnly" required="No" type="boolean" default="false" />

		<cfquery name="qryMembers" datasource="#arguments.DSN#">
			SELECT
				u.user_id,
				u.username,
				isNull(u.preferred_name,u.first_name) AS preferred_name,
				u.first_name,
				u.middle_name,
				u.last_name,
				us.status,
				u.email,
				u.date_expiration,
			<cfif arguments.getContactInfo>
				u.address1,
				u.address2,
				u.city,
				u.state_id,
				u.zip,
				u.country,
				u.phone_day,
				u.phone_night,
				u.phone_cell,
				u.fax,
			</cfif>
				isNull(SUM(t.num_swims),0) AS balance,
				MAX(t.date_transaction) AS lastPractice,
				CASE WHEN coach.officer_id IS NOT NULL OR MAX(t.date_transaction) >= <cfqueryparam value="#CreateODBCDate(DateAdd("d",(0-VAL(arguments.activityDays)),Now()))#" cfsqltype="CF_SQL_DATE"> THEN
					'Active'
				ELSE
					'Inactive'
				END AS activityLevel,
				CASE WHEN coach.officer_id IS NOT NULL THEN
					1
				ELSE
					0
				END isCoach,
				usp.expirationDate AS swimPassExpiration
			FROM
				(
					(
						#arguments.usersTbl# u LEFT OUTER JOIN
						#arguments.transactionTbl# t
						ON t.member_id = u.user_id
					)
					INNER JOIN
					#arguments.user_statusTbl# us
					ON us.user_status_id = u.user_status_id
				)
				LEFT OUTER JOIN
				(
					#arguments.officerTbl# coach
					INNER JOIN
					#arguments.officerTypeTbl# coachType
					ON coach.officer_type_id = coachType.officer_type_id
					AND coachType.officer_type = 'Coach'
				)
				ON u.user_id = coach.user_id
				AND coach.active_code = 1
				AND coach.date_end IS NULL
				LEFT OUTER JOIN usersSwimPasses usp with(nolock)
				ON u.user_id = usp.userID
				AND usp.active = 1
				AND getdate() < (usp.expirationDate + 1)
			WHERE
				u.active_code = 1
				AND
				(
					t.active_code = 1
					OR t.active_code  IS NULL
				)
				AND
				(
					t.paymentConfirmed = 1
					OR t.paymentConfirmed IS NULL
				)
			<cfif arguments.getMembersOnly>
				AND us.status = 'Member'
			<cfelseif CompareNoCase(arguments.statusType,"All") NEQ 0>
				AND UPPER(us.status) LIKE <cfqueryparam value="%#UCASE(arguments.statusType)#" cfsqltype="CF_SQL_VARCHAR">
			</cfif>
			<cfif VAL(arguments.user_id) GT 0>
				AND u.user_id = <cfqueryparam value="#VAL(arguments.user_id)#" cfsqltype="CF_SQL_INTEGER">
			<cfelseif ListLen(arguments.userList) GT 0>
				AND u.user_id IN (<cfqueryparam value="#arguments.userList#" cfsqltype="CF_SQL_INTEGER" list="Yes">)
			</cfif>
			<cfif arguments.getVisibleOnly>
				AND u.profile_visible = 1
			</cfif>
			<cfif arguments.mailingListOnly>
				AND u.mailingListYN = 1
			</cfif>
			<cfif len(trim(arguments.filter))>
				AND
				(
					lower(u.last_name) LIKE <cfqueryparam value="#lcase(arguments.filter)#%" cfsqltype="CF_SQL_VARCHAR">
					OR lower(u.username) LIKE <cfqueryparam value="#lcase(arguments.filter)#%" cfsqltype="CF_SQL_VARCHAR">
				)
			</cfif>
				AND ( t.date_transaction <= <cfqueryparam value="#arguments.balanceDate#" cfsqltype="CF_SQL_TIMESTAMP"> OR t.date_transaction IS NULL)
				AND
				(
					usp.usersSwimPassID IS NULL
					OR
					usp.usersSwimPassID =
					(
						SELECT TOP 1 usersSwimPassID
						FROM usersSwimPasses usp2
						WHERE usp2.userID = u.user_id
							AND usp2.active = 1
						ORDER BY usp2.expirationDate DESC
					)
				)
			GROUP BY
				u.user_id,
				u.username,
				u.last_name,
				u.preferred_name,
				u.first_name,
				u.middle_name,
				u.email,
				u.date_expiration,
			<cfif arguments.getContactInfo>
				u.address1,
				u.address2,
				u.city,
				u.state_id,
				u.zip,
				u.country,
				u.phone_cell,
				u.phone_day,
				u.phone_night,
				u.fax,
			</cfif>
				us.status,
				CASE WHEN coach.officer_id IS NOT NULL THEN 1 ELSE 0 END,
				coach.officer_id,
				usp.expirationDate
			ORDER BY
			<cfif arguments.activitySort>
				activityLevel,
			</cfif>
				u.last_name,
				u.first_name
		</cfquery>

		<cfreturn qryMembers>
	</cffunction>

	<cffunction name="getMembersActivity" access="public" displayname="Get Members by Activity and Status" hint="Gets Query of Members by Activity and Status" output="no" returntype="query">
		<cfargument name="qrySource" required="yes" type="query">
		<cfargument name="activityLevel" required="no" default="both" type="string">
		<cfargument name="statusType" required="no" default="All" type="string">
		<cfargument name="exactStatusType" required="no" default="All" type="string">

		<cfquery name="qryNew" dbtype="query">
			SELECT
				user_id,
				preferred_name,
				first_name,
				last_name,
				email,
				status,
				balance,
				lastPractice,
				activityLevel
			FROM
				qrySource
			WHERE
				1 = 1
			<cfif CompareNoCase(arguments.exactStatusType,"All") NEQ 0>
				AND UPPER(status) = <cfqueryparam value="#UCASE(arguments.exactStatusType)#" cfsqltype="CF_SQL_VARCHAR">
			<cfelseif CompareNoCase(arguments.statusType,"All") NEQ 0>
				AND UPPER(status) LIKE <cfqueryparam value="%#UCASE(arguments.statusType)#%" cfsqltype="CF_SQL_VARCHAR">
			</cfif>
			<cfif CompareNoCase(arguments.activityLevel,"Both") NEQ 0>
				AND UPPER(activityLevel) = <cfqueryparam value="#UCASE(arguments.activityLevel)#" cfsqltype="CF_SQL_VARCHAR">
			</cfif>
			ORDER BY
				last_name,
				first_name
		</cfquery>

		<cfreturn qryNew>
	</cffunction>

	<cffunction name="getCoaches" access="public" displayname="Get Coaches" hint="Gets Query of Coaches" output="No" returntype="query">
		<cfargument name="coach_id" required="no" default="0" type="numeric">
		<cfargument name="dsn" required="yes" type="string">
		<cfargument name="usersTbl" required="yes" type="string">
		<cfargument name="officerTbl" required="yes" type="string">
		<cfargument name="officer_typeTbl" required="yes" type="string">
		<cfargument name="defaultsTbl" required="yes" type="string">

		<cfquery name="qryCoaches" datasource="#arguments.DSN#">
			SELECT
				o.date_end,
				u.user_id,
				u.first_name,
				u.last_name,
				u.preferred_name,
				d.coach_id AS defaultCoach
			FROM
				(
					(
						#arguments.usersTbl# u
						LEFT JOIN
						#arguments.defaultsTbl# d
						ON
						(
							d.coach_id = u.user_id
							AND d.active_code = 1
						)
					)
					INNER JOIN
					#arguments.officerTbl# o
					ON
					(
						o.user_id = u.user_id
						AND o.active_code = 1
					)
				)
				INNER JOIN
				#arguments.officer_typeTbl# ot
				ON
				(
					ot.officer_type_id = o.officer_type_id
					AND UPPER(ot.officer_type) = 'COACH'
				)
			WHERE
				u.active_code = 1
		<cfif VAL(arguments.coach_id) GT 0>
				AND u.user_id = <cfqueryparam value="#VAL(arguments.coach_id)#" cfsqltype="CF_SQL_INTEGER">
		</cfif>
			ORDER BY
				o.date_end,
				u.last_name,
				u.first_name
		</cfquery>

		<cfreturn qryCoaches>
	</cffunction>

	<cffunction name="getNonCoaches" access="public" displayname="Get Non-Coaches" hint="Gets Query of People Who Aren't Coaches" output="No" returntype="query">
		<cfargument name="dsn" required="yes" type="string">
		<cfargument name="usersTbl" required="yes" type="string">
		<cfargument name="officerTbl" required="yes" type="string">
		<cfargument name="officer_typeTbl" required="yes" type="string">

		<cfquery name="qryNonCoaches" datasource="#arguments.DSN#">
			SELECT
				u.user_id,
				u.preferred_name,
				u.first_name,
				u.last_name
			FROM
				#arguments.usersTbl# u
			WHERE
				u.user_id NOT IN
				(
					SELECT
						o.user_id
					FROM
						#arguments.officerTbl# o,
						#arguments.officer_typeTbl# ot
					WHERE
						ot.officer_type_id = o.officer_type_id
						AND UPPER(ot.officer_type) = 'COACH'
						AND o.active_code = 1
				)
				AND u.active_code = 1
			ORDER BY
				u.last_name, u.first_name
		</cfquery>

		<cfreturn qryNonCoaches>
	</cffunction>

	<cffunction name="getFacilities" access="public" displayname="Get Facilities" hint="Gets Query of Facilities" output="No" returntype="query">
		<cfargument name="facility_id" required="no" default="0" type="numeric">
		<cfargument name="dsn" required="yes" type="string">
		<cfargument name="facilityTbl" required="yes" type="string">
		<cfargument name="defaultsTbl" required="yes" type="string">

		<cfquery name="qryFacilities" datasource="#arguments.DSN#">
			SELECT
				f.facility_id,
				f.facility,
				d.facility_id AS defaultFac
			FROM
				#arguments.facilityTbl# f
				LEFT JOIN
				#arguments.defaultsTbl# d
				ON
				(
					d.facility_id = f.facility_id
					AND d.active_code = 1
				)
			WHERE
				f.active_code = 1
		<cfif VAL(arguments.facility_id) GT 0>
				AND f.facility_id = <cfqueryparam value="#VAL(arguments.facility_id)#" cfsqltype="CF_SQL_INTEGER">
		</cfif>
			ORDER BY
				f.facility
		</cfquery>

		<cfreturn qryFacilities>
	</cffunction>

	<cffunction name="getPreferences" access="public" displayname="Gets Query of Preferences" hint="Gets Query of Preferences" output="No" returntype="query">
		<cfargument name="preference_id" required="no" default="0" type="numeric">
		<cfargument name="preference_type" required="yes" type="string">
		<cfargument name="dsn" required="no" type="string" default="squid">
		<cfargument name="preferenceTbl" required="no" type="string" default="preferenceTbl">

		<cfquery name="qryPreferences" datasource="#arguments.DSN#">
			SELECT
				p.preference_id,
				p.preference_type,
				p.preference
			FROM
				#arguments.preferenceTbl# p
			WHERE
				UPPER(p.preference_type) = <cfqueryparam value="#UCASE(arguments.preference_type)#" cfsqltype="CF_SQL_VARCHAR">
		<cfif VAL(arguments.preference_id) GT 0>
				AND p.preference_id = <cfqueryparam value="#VAL(arguments.preference_id)#" cfsqltype="CF_SQL_INTEGER">
		</cfif>
			ORDER BY
				p.preference
		</cfquery>

		<cfreturn qryPreferences>
	</cffunction>

	<cffunction name="getStates" access="public" displayname="Gets Query of States" hint="Gets Query of States" output="No" returntype="query">
		<cfargument name="state_id" required="no" default="" type="string">
		<cfargument name="dsn" required="no" type="string" default="squid">
		<cfargument name="stateTbl" required="no" type="string" default="stateTbl">

		<cfquery name="qryStates" datasource="#arguments.DSN#">
			SELECT
				s.state_id,
				s.state
			FROM
				#arguments.stateTbl# s
		<cfif LEN(TRIM(arguments.state_id))>
			WHERE
				UPPER(s.state_id) = <cfqueryparam value="#UCASE(arguments.state_id)#" cfsqltype="CF_SQL_VARCHAR">
		</cfif>
			ORDER BY
				s.state
		</cfquery>

		<cfreturn qryStates>
	</cffunction>

	<cffunction name="getCountries" access="public" hint="Gets Query of Countries" output="false" returntype="query">
		<cfargument name="dsn" required="true" type="string" />

		<cfset var local = structNew() />
		<cfquery name="local.qCountries" datasource="#arguments.DSN#">
			SELECT
				c.countryID,
				c.country,
				c.countryCode,
				c.threeLetterCountryCode
			FROM
				countries c
			ORDER BY
				c.country
		</cfquery>

		<cfreturn local.qCountries />
	</cffunction>

	<cffunction name="getCreditCardTypes" access="public" hint="Gets Query of Credit Card Types" output="false" returntype="query">
		<cfargument name="dsn" required="true" type="string" />

		<cfset var local = structNew() />
		<cfquery name="local.qCreditCardTypes" datasource="#arguments.DSN#">
			SELECT
				creditCardTypeID,
				creditCardType,
				shortName,
				numberOfAccountDigits,
				numberOfCVVDigits
			FROM
				creditCardTypes
			ORDER BY
				creditCardType
		</cfquery>

		<cfreturn local.qCreditCardTypes />
	</cffunction>

	<cffunction name="getIssuesStatus" access="public" displayname="Issue Statuses" hint="Gets Query of Issues Statuses" output="No" returntype="query">
		<cfargument name="dsn" required="no" type="string" default="squid">
		<cfargument name="statusTbl" required="no" type="string" default="issue_statusTbl">

		<cfquery name="qryStatus" datasource="#arguments.DSN#">
			SELECT
				s.status_id,
				s.status
			FROM
				#arguments.statusTbl# s
			ORDER BY
				s.status_id
		</cfquery>

		<cfreturn qryStatus>
	</cffunction>

	<cffunction name="getIssuesSeverity" access="public" displayname="Issue Severityes" hint="Gets Query of Issues Severityes" output="No" returntype="query">
		<cfargument name="dsn" required="no" type="string" default="squid">
		<cfargument name="severityTbl" required="no" type="string" default="issue_severityTbl">

		<cfquery name="qrySeverity" datasource="#arguments.DSN#">
			SELECT
				s.severity_id,
				s.severity
			FROM
				#arguments.severityTbl# s
			ORDER BY
				s.severity
		</cfquery>

		<cfreturn qrySeverity>
	</cffunction>

	<cffunction name="getDevelopers" access="public" displayname="Developers" hint="Gets Developers" output="No" returntype="query">
		<cfargument name="dsn" required="no" type="string" default="squid">
		<cfargument name="developerTbl" required="no" type="string" default="developerTbl">
		<cfargument name="usersTbl" required="no" type="string" default="usersTbl">

		<cfquery name="qryDevelopers" datasource="#arguments.DSN#">
			SELECT
				d.developer_id,
				d.user_id,
				u.preferred_name + ' ' + u.last_name AS developer
			FROM
				#arguments.developerTbl# d,
				#arguments.usersTbl# u
			WHERE
				d.user_id = u.user_id
				AND d.active_code = 1
			ORDER BY
				u.last_name, u.preferred_name
		</cfquery>

		<cfreturn qryDevelopers>
	</cffunction>

	<cffunction name="getTesters" access="public" displayname="Testers" hint="Gets Testers" output="No" returntype="query">
		<cfargument name="dsn" required="no" type="string" default="squid">
		<cfargument name="testerTbl" required="no" type="string" default="testerTbl">
		<cfargument name="usersTbl" required="no" type="string" default="usersTbl">

		<cfquery name="qryTesters" datasource="#arguments.DSN#">
			SELECT
				t.tester_id,
				t.user_id,
				u.preferred_name + ' ' + u.last_name AS tester,
				u.username,
				u.password,
				u.email
			FROM
				#arguments.testerTbl# t,
				#arguments.usersTbl# u
			WHERE
				t.user_id = u.user_id
				AND t.active_code = 1
				AND u.active_code = 1
			ORDER BY
				u.last_name, u.preferred_name
		</cfquery>

		<cfreturn qryTesters>
	</cffunction>

	<cffunction name="getOfficerTypes" access="public" displayname="Officer Types" hint="Gets Officer Types" output="No" returntype="query">
		<cfargument name="dsn" required="no" type="string" default="squid">
		<cfargument name="officerTypeTbl" required="no" type="string" default="officer_typeTbl">
		<cfargument name="officerType" required="no" type="string" default="">
		<cfargument name="officer_type_id" required="no" type="numeric" default="0">
		<cfargument name="feedbackOnly" required="no" type="boolean" default="false">

		<cfquery name="qryOfficerTypes" datasource="#arguments.DSN#">
			SELECT
				ot.officer_type_id,
				ot.officer_type,
				ot.team_council,
				ot.feedback,
				ot.email
			FROM
				#arguments.officerTypeTbl# ot
			WHERE
				ot.active_code = 1
			<cfif LEN(TRIM(arguments.officerType))>
				AND UPPER(ot.officer_type) = <cfqueryparam value="#UCASE(arguments.officerType)#" cfsqltype="CF_SQL_VARCHAR">
			</cfif>
			<cfif VAL(arguments.officer_type_id) GT 0>
				AND ot.officer_type_id = <cfqueryparam value="#VAL(arguments.officer_type_id)#" cfsqltype="CF_SQL_INTEGER">
			</cfif>
			<cfif arguments.feedbackOnly>
				AND ot.feedback <> 0
			</cfif>
			ORDER BY
				ot.team_council,
				ot.officer_type
		</cfquery>

		<cfreturn qryOfficerTypes>
	</cffunction>

	<cffunction name="getOfficers" access="public" displayname="Officers" hint="Gets Officers" output="No" returntype="query">
		<cfargument name="dsn" required="no" type="string" default="squid">
		<cfargument name="officer_typeTbl" required="yes" type="string" default="officer_typeTbl">
		<cfargument name="officerTbl" required="yes" type="string" default="officer_typeTbl">
		<cfargument name="usersTbl" required="yes" type="string" default="officer_typeTbl">
		<cfargument name="officer_type_id" required="yes" type="numeric" />
		<cfargument name="displayCoaches" required="yes" type="boolean" />
		<cfargument name="displayInactive" required="yes" type="boolean" />

		<cfquery name="qryOfficers" datasource="#arguments.DSN#">
			SELECT
				ot.officer_type_id,
				ot.officer_type,
				u.user_id,
				u.first_name,
				u.preferred_name,
				u.last_name,
				u.email
			FROM
				#arguments.officer_typeTbl# ot
				LEFT JOIN
				(
					#arguments.officerTbl# o
					INNER JOIN #arguments.usersTbl# u
					ON o.user_id = u.user_id
					AND u.active_code = 1
					<cfif NOT arguments.displayInactive>
						AND o.date_end IS NULL
					</cfif>
				)
				ON ot.officer_type_id = o.officer_type_id
				AND o.active_code = 1
			WHERE
				ot.active_code = 1
			<cfif NOT arguments.displayCoaches>
				AND UPPER(ot.officer_type) <> 'COACH'
			</cfif>
			<cfif VAL(arguments.officer_type_id) GT 0>
				AND ot.officer_type_id = <cfqueryparam value="#VAL(arguments.officer_type_id)#" cfsqltype="CF_SQL_INTEGER">
			</cfif>
			ORDER BY
				ot.officer_type,
				u.last_name,
				u.preferred_name
		</cfquery>

		<cfreturn qryOfficers>
	</cffunction>

	<cffunction name="getMembershipTransactions" access="public" displayname="getMembershipTransactions" hint="Gets Membership Transactions" output="No" returntype="query">
		<cfargument name="dsn" required="yes" type="string" />
		<cfargument name="usersTbl" required="yes" type="string" />
		<cfargument name="transactionTbl" required="yes" type="string" />
		<cfargument name="transaction_id" required="no" type="numeric" default="0" />
		<cfargument name="confirmed" required="no" type="numeric" default="-1" />
		<cfargument name="member_id" required="no" type="numeric" default="0" />
		<cfargument name="date_start" required="no" default="" type="string">
		<cfargument name="date_end" required="no" default="" type="string">

		<cfset var qData = "" />

		<cfquery name="qData" datasource="#dsn#">
			SELECT
				t.transaction_id,
				t.member_id,
				t.duesYear,
				t.date_transaction,
				t.membershipFee,
				t.paymentConfirmed,
				t.notes,
				isNull(u.preferred_name,u.first_name) AS preferred_name,
				u.last_name,
				u.email,
				u.date_expiration,
				u.username
			FROM
				#transactionTbl# t
				RIGHT OUTER JOIN #usersTbl# u
				ON t.member_id = u.user_id
			WHERE
				t.active_code = 1
			<cfif VAL(transaction_id)>
				AND t.transaction_id = <cfqueryparam value="#VAL(transaction_id)#" cfsqltype="CF_SQL_INTEGER">
			</cfif>
			<cfif VAL(arguments.member_id)>
				AND t.member_id = <cfqueryparam value="#arguments.member_id#" cfsqltype="CF_SQL_INTEGER">
			</cfif>
			<cfif VAL(arguments.confirmed) GT -1>
				AND t.paymentConfirmed = <cfqueryparam value="#arguments.confirmed#" cfsqltype="CF_SQL_BIT">
			</cfif>
			<cfif IsDate(arguments.date_start)>
				AND t.date_transaction >= <cfqueryparam value="#arguments.date_start#" cfsqltype="CF_SQL_DATE">
			</cfif>
			<cfif IsDate(arguments.date_end)>
				<cfset dateEnd = CreateDateTime(Year(arguments.date_end),Month(arguments.date_end),Day(arguments.date_end),23,59,59) />
				AND t.date_transaction <= <cfqueryparam value="#dateEnd#" cfsqltype="CF_SQL_TIMESTAMP">
			</cfif>
			ORDER BY
				t.date_transaction DESC,
				u.last_name,
				isNull(u.preferred_name,u.first_name)
		</cfquery>

		<cfreturn qData />
	</cffunction>

	<cffunction name="getNegativeBalances" access="public" displayname="getNegativeBalances" hint="Gets Active Swimmers with Negative Swim Balances" output="No" returntype="query">
		<cfargument name="dsn" required="yes" type="string">
		<cfargument name="usersTbl" required="yes" type="string">
		<cfargument name="preferenceTbl" required="yes" type="string">
		<cfargument name="transactionTbl" required="yes" type="string">
		<cfargument name="activityDays" required="no" default="90" type="numeric">

		<cfquery name="qData" datasource="#dsn#">
			SELECT
				u.user_id,
				u.email,
				isNull(u.preferred_name,u.first_name) AS firstName,
				u.last_name,
				SUM(pt.num_swims) AS balance,
				MAX(pt.date_transaction) AS lastTrans,
				p.preference
			FROM
				#usersTbl# u,
				#transactionTbl# pt,
				#preferenceTbl# p
			WHERE
				u.user_id = pt.member_id
				AND u.email_preference = p.preference_id
				AND pt.active_code = 1
				AND u.email IS NOT NULL
				AND u.email <> ''
				AND NOT EXISTS
				(
					SELECT
						us.userID
					FROM
						unsubscribes us
					WHERE
						(
							u.user_id = us.userID
							OR u.email = us.email
						)
						AND us.resubscribeDate IS NULL
				)
			GROUP BY
				pt.member_id,
				u.user_id,
				u.last_name,
				u.first_name,
				isNull(u.preferred_name,u.first_name),
				u.email,
				p.preference
			HAVING
				SUM(pt.num_swims) < 0
				AND MAX(pt.date_transaction) > <cfqueryparam value="#CreateODBCDate(DateAdd("d",(-1 * activityDays),Now()))#" cfsqltype="CF_SQL_DATE">
			ORDER BY
				UPPER(u.last_name), UPPER(u.first_name)
		</cfquery>

		<cfreturn qData />
	</cffunction>

	<cffunction name="getUserEvents" access="public" displayname="getUserEvents" hint="Gets User Events/Times" output="No" returntype="query">
		<cfargument name="dsn" required="yes" type="string" />
		<cfargument name="usersTbl" required="yes" type="string" />
		<cfargument name="userEventTbl" required="yes" type="string" />
		<cfargument name="distanceTbl" required="yes" type="string" />
		<cfargument name="distanceTypeTbl" required="yes" type="string" />
		<cfargument name="distanceUnitTbl" required="yes" type="string" />
		<cfargument name="strokeTbl" required="yes" type="string" />
		<cfargument name="user_id" required="true" type="numeric" />
		<cfargument name="eventID" required="true" type="numeric" />
		<cfargument name="distanceID" required="true" type="numeric" />
		<cfargument name="strokeID" required="true" type="numeric" />
		<cfargument name="distanceTypeID" required="true" type="numeric" />
		<cfargument name="unitID" required="true" type="numeric" />
		<cfargument name="startDate" required="true" type="string" />
		<cfargument name="endDate" required="true" type="string" />

		<cfset var qData = "" />

		<cfquery name="qData" datasource="#dsn#">
			SELECT
				ue.eventID,
				u.first_name,
				u.preferred_name,
				u.last_name,
				ue.seedTime,
				ue.eventDate,
				ue.eventLocation,
				ue.distanceID,
				ue.strokeID,
				ue.distanceTypeID,
				ue.unitID,
				d.distance,
				s.stroke,
				du.unit,
				du.abbrv AS unitAbbrv,
				dt.abbrv AS typeAbbrv,
				dt.distanceType
			FROM
				#arguments.usersTbl# u
				INNER JOIN #arguments.userEventTbl# ue
				ON u.user_id = ue.user_id
				INNER JOIN #arguments.distanceTbl# d
				ON ue.distanceID = d.distanceID
				INNER JOIN #arguments.strokeTbl# s
				ON ue.strokeID = s.strokeID
				INNER JOIN #arguments.distanceUnitTbl# du
				ON du.unitID = ue.unitID
				INNER JOIN #arguments.distanceTypeTbl# dt
				ON dt.distanceTypeID = ue.distanceTypeID
			WHERE
				u.active_code = 1
			<cfif VAL(arguments.user_id) GT 0>
				AND u.user_id = <cfqueryparam value="#VAL(arguments.user_id)#" cfsqltype="CF_SQL_INTEGER" />
			</cfif>
			<cfif VAL(arguments.eventID) GT 0>
				AND ue.eventID = <cfqueryparam value="#VAL(arguments.eventID)#" cfsqltype="CF_SQL_INTEGER" />
			</cfif>
			<cfif VAL(arguments.distanceID) GT 0>
				AND ue.distanceID = <cfqueryparam value="#VAL(arguments.distanceID)#" cfsqltype="CF_SQL_INTEGER" />
			</cfif>
			<cfif VAL(arguments.strokeID) GT 0>
				AND ue.strokeID = <cfqueryparam value="#VAL(arguments.strokeID)#" cfsqltype="CF_SQL_INTEGER" />
			</cfif>
			<cfif VAL(arguments.distanceTypeID) GT 0>
				AND ue.distanceTypeID = <cfqueryparam value="#VAL(arguments.distanceTypeID)#" cfsqltype="CF_SQL_INTEGER" />
			</cfif>
			<cfif VAL(arguments.unitID) GT 0>
				AND ue.unitID = <cfqueryparam value="#VAL(arguments.unitID)#" cfsqltype="CF_SQL_INTEGER" />
			</cfif>
			<cfif isDate(arguments.startDate)>
				AND ue.eventDate >= <cfqueryparam value="#arguments.startDate#" cfsqltype="cf_sql_date" />
			</cfif>
			<cfif isDate(arguments.endDate)>
				AND ue.eventDate <= <cfqueryparam value="#arguments.endDate#" cfsqltype="cf_sql_date" />
			</cfif>
			ORDER BY
				UPPER(u.last_name),
				UPPER(u.first_name),
				ue.eventDate
<!---
				d.distance,
				UPPER(s.stroke),
				ue.eventDate DESC
 --->
		</cfquery>

		<cfreturn qData />
	</cffunction>

	<cffunction name="getStrokes" access="public" displayname="getStrokes" hint="Gets Strokes" output="No" returntype="query">
		<cfargument name="dsn" required="yes" type="string" />
		<cfargument name="strokeTbl" required="yes" type="string" />

		<cfset var qData = "" />

		<cfquery name="qData" datasource="#dsn#">
			SELECT
				s.strokeID,
				s.stroke
			FROM
				#strokeTbl# s
			ORDER BY
				UPPER(s.stroke)
		</cfquery>

		<cfreturn qData />
	</cffunction>

	<cffunction name="getDistances" access="public" displayname="getDistances" hint="Gets Distances" output="No" returntype="query">
		<cfargument name="dsn" required="yes" type="string" />
		<cfargument name="distanceTbl" required="yes" type="string" />

		<cfset var qData = "" />

		<cfquery name="qData" datasource="#dsn#">
			SELECT
				d.distanceID,
				d.distance
			FROM
				#distanceTbl# d
			ORDER BY
				d.distance
		</cfquery>

		<cfreturn qData />
	</cffunction>

	<cffunction name="getDistanceTypes" access="public" displayname="getDistanceTypes" hint="Gets Distance Types" output="No" returntype="query">
		<cfargument name="dsn" required="yes" type="string" />
		<cfargument name="distanceTypeTbl" required="yes" type="string" />

		<cfset var qData = "" />

		<cfquery name="qData" datasource="#dsn#">
			SELECT
				dt.distanceTypeID,
				dt.distanceType,
				dt.abbrv
			FROM
				#distanceTypeTbl# dt
			ORDER BY
				dt.distanceType
		</cfquery>

		<cfreturn qData />
	</cffunction>

	<cffunction name="getDistanceUnits" access="public" displayname="getDistanceUnits" hint="Gets Distance Units" output="No" returntype="query">
		<cfargument name="dsn" required="yes" type="string" />
		<cfargument name="distanceUnitTbl" required="yes" type="string" />

		<cfset var qData = "" />

		<cfquery name="qData" datasource="#dsn#">
			SELECT
				du.unitID,
				du.unit,
				du.abbrv
			FROM
				#distanceUnitTbl# du
			ORDER BY
				du.unit
		</cfquery>

		<cfreturn qData />
	</cffunction>

	<cffunction name="getNewSwimmers" access="public" displayname="getNewSwimmers" hint="Gets Query of New Swimmers" output="no" returntype="query">
		<cfargument name="dsn" required="yes" type="string" />
		<cfargument name="usersTbl" required="yes" type="string" />
		<cfargument name="user_statusTbl" required="yes" type="string" />
		<cfargument name="newDays" required="yes" type="numeric" />

		<cfset var qData = "" />

		<cfquery name="qData" datasource="#dsn#">
			SELECT
				u.user_id,
				DateDiff(d,u.created_date,GetDate())
			FROM
				#usersTbl# u
				INNER JOIN #user_statusTbl# us
				ON u.user_status_id = us.user_status_id
			WHERE
				UPPER(us.status) LIKE <cfqueryparam value="%MEMBER" cfsqltype="CF_SQL_VARCHAR" />
				AND DateDiff(d,u.created_date,GetDate()) < <cfqueryparam value="#newDays#" cfsqltype="CF_SQL_INTEGER" />
		</cfquery>

		<cfreturn qData />
	</cffunction>

	<cffunction name="getCoachingSummary" access="public" displayname="getCoachingSummary" hint="Gets Query of Practices by Coach" output="no" returntype="query">
		<cfargument name="dsn" required="yes" type="string" />
		<cfargument name="practicesTbl" required="yes" type="string" />
		<cfargument name="usersTbl" required="yes" type="string" />
		<cfargument name="fromDate" required="Yes" type="date" />
		<cfargument name="toDate" required="Yes" type="date" />

		<cfset var qData = "" />

		<cfquery name="qData" datasource="#dsn#">
			SELECT
				u.user_id,
				u.preferred_name,
				u.last_name,
				CAST(Year(p.date_practice) AS varchar(4)) + CASE WHEN Month(p.date_practice) < 10 THEN '0' ELSE '' END +  CAST(Month(p.date_practice) AS varchar(2)) AS monthSort,
				DateName(month,p.date_practice) + ' ' + CAST(Year(p.date_practice) AS varchar(4)) AS practiceMonth,
				COUNT(p.date_practice) AS numPractices
			FROM
				#usersTbl# u
				INNER JOIN #practicesTbl# p
				ON u.user_id = p.coach_id
			WHERE
				p.date_practice BETWEEN <cfqueryparam value="#fromDate#" cfsqltype="CF_SQL_DATE" /> AND <cfqueryparam value="#toDate#" cfsqltype="CF_SQL_DATE" />
				AND p.active_code = 1
			GROUP BY
				CAST(Year(p.date_practice) AS varchar(4)) + CASE WHEN Month(p.date_practice) < 10 THEN '0' ELSE '' END +  CAST(Month(p.date_practice) AS varchar(2)),
				DateName(month,p.date_practice) + ' ' + CAST(Year(p.date_practice) AS varchar(4)),
				u.user_id,
				u.preferred_name,
				u.last_name
			ORDER BY
				monthSort,
				u.last_name,
				u.preferred_name
		</cfquery>

		<cfreturn qData />
	</cffunction>

	<cffunction name="getStatus" access="public" displayname="Get Status" hint="Gets Query of Statuses" output="No" returntype="query">
		<cfargument name="dsn" required="yes" type="string" />
		<cfargument name="statusTbl" required="yes" type="string" />
		<cfargument name="status_id" required="yes" type="numeric" />
		<cfargument name="orderBy" required="no" type="string" default="lower(s.status)" />

		<cfset var qResults = "" />

		<cfquery name="qResults" datasource="#arguments.DSN#">
			SELECT
				s.status_id,
				s.status
			FROM
				#arguments.statusTbl# s
		<cfif VAL(arguments.status_id)>
			WHERE
				s.status_id = <cfqueryparam value="#VAL(arguments.status_id)#" cfsqltype="CF_SQL_INTEGER" />
		</cfif>
			ORDER BY
				#arguments.orderBy#
		</cfquery>

		<cfreturn qResults />
	</cffunction>

	<cffunction name="getMembershipTransactions2" access="public" displayname="Get Membership Transactions" hint="Gets Query of Membership Transactions" output="No" returntype="query">
		<cfargument name="dsn" required="true" type="string">
		<cfargument name="transaction_id" required="true" type="numeric" />
		<cfargument name="date_start" required="true" type="string">
		<cfargument name="date_end" required="true" type="string">
		<cfargument name="paymentConfirmed" required="true" type="numeric">

		<cfset var local = structNew() />
		<cfset local.qResults = "" />

		<cfquery name="local.qResults" datasource="#arguments.DSN#">
			SELECT
				t.transaction_id,
				t.member_id,
				t.duesYear,
				t.date_transaction,
				t.paymentConfirmed,
				t.notes,
				isNull(u.preferred_name,u.first_name) AS memberPref,
				CASE WHEN
					u.last_name IS NULL
				THEN
					'(none)'
				ELSE
					u.last_name
				END AS memberLast
			FROM
				membershipTransactions t
				LEFT OUTER JOIN users u
				ON t.member_id = u.user_id
			WHERE
				t.active_code = 1
			<cfif VAL(arguments.transaction_id)>
				AND t.transaction_id = <cfqueryparam value="#arguments.transaction_id#" cfsqltype="CF_SQL_INTEGER">
			</cfif>
			<cfif arguments.paymentConfirmed NEQ -1>
				AND t.paymentConfirmed = <cfqueryparam value="#paymentConfirmed#" cfsqltype="CF_SQL_BIT" />
			</cfif>
			<cfif isDate(arguments.date_start)>
				AND t.date_transaction > <cfqueryparam value="#arguments.date_start# 0:00:00" cfsqltype="cf_sql_timestamp" />
			</cfif>
			<cfif isDate(arguments.date_end)>
				AND t.date_transaction <= <cfqueryparam value="#arguments.date_end# 23:59:59" cfsqltype="cf_sql_timestamp" />
			</cfif>
			ORDER BY
				t.date_transaction
		</cfquery>

		<cfreturn local.qResults />
	</cffunction>

	<cffunction name="getMinutes" access="public" hint="Gets meeting minutes" output="false" returntype="query">
		<cfargument name="dsn" required="true" type="string">

		<cfset var qResults = "" />

		<cfquery name="qResults" datasource="#arguments.DSN#">
			SELECT
				ft.file_type,
				f.filename,
				f.description
			FROM
				files f
				INNER JOIN fileTypes ft
				ON f.file_type_id = ft.file_type_id
				INNER JOIN fileCategories fc
				ON f.category_id = fc.category_id
				AND fc.category = 'Meeting Minutes'
			WHERE
				f.active_code = 1
			ORDER BY
				f.created_date DESC
		</cfquery>

		<cfreturn qResults />
	</cffunction>

	<cffunction name="getUsersSwimPassTransactionsByDate" access="public" hint="Returns query of users swim passes for given date range" output="false" returntype="query">
		<cfargument name="dsn" required="true" type="string" />
		<cfargument name="startDate" required="true" type="date" />
		<cfargument name="endDate" required="true" type="date" />

		<cfset var local = structNew() />
		<cfset local.qSwimPassTransactions = "" />


		<cfquery name="local.qSwimPassTransactions" datasource="#arguments.dsn#">
			SELECT
				pt.transaction_id,
				pt.date_transaction,
				pt.notes,
				usp.activeDate,
				usp.expirationDate,
				sp.price,
				sp.swimPass,
				isNull(u.preferred_name,u.first_name) AS first_name,
				u.last_name
			FROM
				practiceTransactions pt
				INNER JOIN transactionTypes tt ON pt.transaction_type_id = tt.transaction_type_id
				AND tt.transaction_type = 'Swim Pass Purchase'
				INNER JOIN usersSwimPasses usp ON pt.usersSwimPassID = usp.usersSwimPassID
				INNER JOIN swimPasses sp ON usp.swimPassID = sp.swimPassID
				INNER JOIN users u ON usp.userID = u.user_id
			WHERE pt.active_code = 1
				AND usp.active = 1
				AND pt.paymentConfirmed = 1
				AND pt.date_transaction BETWEEN <cfqueryparam value="#arguments.startDate#" cfsqltype="cf_sql_date" /> AND <cfqueryparam value="#dateAdd("d",1,arguments.endDate)#" cfsqltype="cf_sql_date" />
			ORDER BY pt.date_transaction
		</cfquery>

		<cfreturn local.qSwimPassTransactions />
	</cffunction>

	<cffunction name="getUsersSwimPassesByEffectiveDate" access="public" hint="Returns query of users swim passes for given date range" output="false" returntype="query">
		<cfargument name="dsn" required="true" type="string" />
		<cfargument name="startDate" required="true" type="date" />
		<cfargument name="endDate" required="true" type="date" />

		<cfset var local = structNew() />
		<cfset local.qSwimPasses = "" />


		<cfquery name="local.qSwimPasses" datasource="#arguments.dsn#">
			SELECT
				usp.activeDate,
				usp.expirationDate,
				sp.price,
				sp.swimPass,
				CASE WHEN
					isNull(u.preferred_name,'') = ''
				THEN
					u.first_name
				ELSE
					u.preferred_name
				END AS first_name,
				u.last_name
			FROM
				usersSwimPasses usp
				INNER JOIN swimPasses sp ON usp.swimPassID = sp.swimPassID
				INNER JOIN users u ON usp.userID = u.user_id
			WHERE usp.active = 1
				AND
				(
					usp.activeDate BETWEEN <cfqueryparam value="#arguments.startDate#" cfsqltype="cf_sql_date" /> AND <cfqueryparam value="#dateAdd("d",1,arguments.endDate)#" cfsqltype="cf_sql_date" />
					OR usp.expirationDate BETWEEN <cfqueryparam value="#arguments.startDate#" cfsqltype="cf_sql_date" /> AND <cfqueryparam value="#dateAdd("d",1,arguments.endDate)#" cfsqltype="cf_sql_date" />
				)
			ORDER BY usp.activeDate
		</cfquery>

		<cfreturn local.qSwimPasses />
	</cffunction>

	<cffunction name="getExpiredSwimPasses" access="public" hint="Returns query of users swim passes that have expired and not been notified about it or gotten a new one" output="false" returntype="query">
		<cfargument name="dsn" required="true" type="string" />

		<cfset var local = structNew() />
		<cfset local.qSwimPasses = "" />

		<cfquery name="local.qSwimPasses" datasource="#arguments.dsn#">
			SELECT usp.usersSwimPassID,
				usp.expirationDate,
				sp.swimPass,
				CASE WHEN
					isNull(u.preferred_name,'') = ''
				THEN
					u.first_name
				ELSE
					u.preferred_name
				END AS first_name,
				u.last_name,
				u.email
			FROM usersSwimPasses usp
				INNER JOIN swimPasses sp ON usp.swimPassID = sp.swimPassID
				INNER JOIN users u ON usp.userID = u.user_id
			WHERE usp.active = 1
			AND userID NOT IN
			(
				SELECT usp2.userID
				FROM usersSwimPasses usp2
				WHERE usp2.active = 1
					AND usp2.expirationDate >= <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp" />
			)
				AND usp.expirationDate < <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp" />
				AND usp.expirationNotificationDate IS NULL
		</cfquery>

		<cfreturn local.qSwimPasses />
	</cffunction>

	<cffunction name="getExpiringSwimPasses" access="public" hint="Returns query of users swim passes that are expiring soon expired and not been notified about it or gotten a new one" output="false" returntype="query">
		<cfargument name="dsn" required="true" type="string" />
		<cfargument name="reminderDays1" required="true" type="numeric" />
		<cfargument name="reminderDays2" required="true" type="numeric" />

		<cfset var local = structNew() />
		<cfset local.qSwimPasses = "" />

		<cfquery name="local.qSwimPasses" datasource="#arguments.dsn#">
			SELECT usp.usersSwimPassID,
				usp.expirationDate,
				usp.expirationWarningDate1,
				usp.expirationWarningDate2,
				dateDiff(d,getDate(),usp.expirationDate) AS daysUntilExpiration,
				sp.swimPass,
				CASE WHEN
					isNull(u.preferred_name,'') = ''
				THEN
					u.first_name
				ELSE
					u.preferred_name
				END AS first_name,
				u.last_name,
				u.email,
				CASE WHEN
					expirationWarningDate1 IS NULL
				THEN
					'First'
				ELSE
					'Final'
				END AS notificationNumber
			FROM usersSwimPasses usp
				INNER JOIN swimPasses sp ON usp.swimPassID = sp.swimPassID
				INNER JOIN users u ON usp.userID = u.user_id
			WHERE usp.active = 1
			AND userID NOT IN
			(
				SELECT usp2.userID
				FROM usersSwimPasses usp2
				WHERE usp2.active = 1
					AND usp2.activeDate >= <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp" />
			)
				AND
				(
					usp.expirationDate BETWEEN getdate()
					AND dateAdd(d,#arguments.reminderDays2#,getdate())
					AND usp.expirationWarningDate2 IS NULL
					OR
					usp.expirationDate BETWEEN dateAdd(d,#arguments.reminderDays2 + 1#,getdate()) AND dateAdd(d,#arguments.reminderDays1#,getdate())
					AND usp.expirationWarningDate1 IS NULL
				)
		</cfquery>

		<cfreturn local.qSwimPasses />
	</cffunction>
</cfcomponent>