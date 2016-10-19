<cfcomponent displayname="Image Components" hint="CFC for Images">
	<cffunction name="uploadPhoto" access="public" displayname="Uploads Picture" hint="Uploads Picture" output="No" returntype="struct">
		<cfargument name="image_path" required="no" type="string" default="">
		<cfargument name="image_name" required="no" type="string" default="">
		<cfargument name="max_height" required="no" type="numeric" default=0>
		<cfargument name="max_width" required="no" type="numeric" default=0>
		<cfargument name="overwrite" required="no" type="boolean" default=false>
		<cfargument name="imageField" required="yes" type="string" default="picture">

		<cfscript>
			var.success = StructNew();
			var.success.success = "Yes";
			var.success.reason = "";
		</cfscript>		
		<cftry>
			<cffile action="UPLOAD" filefield="#arguments.imageField#" destination="#arguments.image_path#" nameconflict="MAKEUNIQUE" accept="image/gif,image/jpeg,image/pjpeg">

			<!--- If the file already exists and overwrite is true, delete the old version --->
			<cfset tmpFile = CFFILE.serverFile>

			<cfif arguments.overwrite AND FileExists(arguments.image_path & "\" & arguments.image_name & ".gif")>
				<cffile action="delete" file="#arguments.image_path#\#arguments.image_name#.gif">
			<cfelseif arguments.overwrite AND FileExists(arguments.image_path & "\" & arguments.image_name & ".jpg")>
				<cffile action="delete" file="#arguments.image_path#\#arguments.image_name#.jpg">
			</cfif>

			<cfset var.imageExt = CFFILE.serverFileExt>
			<cffile action="RENAME" source="#arguments.image_path#\#tmpFile#" destination="#arguments.image_path#\#arguments.image_name#.#CFFILE.serverFileExt#">

			<!--- Get ImageInfo --->
			<cfinvoke
				component="#this#"
				method="getImageInfo"
				returnvariable="imageinfo"
				file="#arguments.image_path#\#arguments.image_name#.#CFFILE.serverFileExt#"
			>

			<cfcatch type="Any">
				<cfscript>
					var.success.success = "No";
					var.success.reason = "There was a problem uploading the image.--#cfcatch.message#*";
				</cfscript>

				<cfreturn var.success>
			</cfcatch>
		</cftry>

		<cfset var.success.imageName = ListLast(imageInfo.filename,"\")>
	<cfif ListLen(var.success.imageName,".") LT 2>
		<cfset var.success.imageName = var.success.imageName & "." & var.imageExt>
	</cfif>
		<cfset var.success.imageHeight = imageInfo.height>
		<cfset var.success.imageWidth= imageInfo.width>
		
		<cfreturn var.success>
	</cffunction>

	<cffunction name="getImageInfo" access="public" displayname="Image Info" hint="Gets Image Info" output="No" returntype="struct">
		<cfargument name="file" required="yes" type="string" default="">

		<!--- check for attribute existance --->
		<cfif not isdefined("arguments.file")>
		  <cfthrow type="ImageInfo.MissingAttribute"
		           message="Attribute set validation error in tag CF_IMAGEINFO"
		           detail="The tag has an invalid attribute combination: the following required attributes have not been provided: (FILE).">
		</cfif>
		
		<!--- read in the image file --->
		<cftry>
			<cffile action="read" file="#arguments.file#" variable="image">
			<cfcatch type="any">
				<cfset image="">
			</cfcatch>
		</cftry>
		
		<cfscript>
		  size = len(image);
		  if (size ge 4) {
		    imagesig = left(image, 4);
		    // ---- JPEG ----
		    if (imagesig is "#chr(255)##chr(216)##chr(255)##chr(224)#" or imagesig is "#chr(255)##chr(216)##chr(255)##chr(225)#") {
		      type = "JPEG";
		      filepos = 1;
		      while (filepos le (size - 1)) {
		        if (asc(mid(image, filepos, 1)) is 255) {
		          marker = asc(mid(image, filepos + 1, 1));
		          filepos = filepos + 2;
		          // switch on marker type
		          switch (marker) {
		            // start of frame
		            case "192": case "193": case "194": case "195": case "198": case "199":
		            case "201": case "202": case "203": case "205": case "206": case "207": {
		              height = (asc(mid(image, filepos + 3, 1)) * 256) + asc(mid(image, filepos + 4, 1));
		              width = (asc(mid(image, filepos + 5, 1)) *256) + asc(mid(image, filepos + 6, 1));
		              filepos = filepos + (asc(mid(image, filepos, 1)) * 256) + asc(mid(image, filepos + 1, 1));
		              break;
		            }
		            // start of image
		            case "216": {
		              break;
		            }
		            // end of image
		            case "217": {
		              filepos = size;
		              break;
		            }
		            // start of scan
		            case "218": {
		              filepos = size;
		              break;
		            }
		            // skip over any others
		            default: {
		              filepos = filepos + (asc(mid(image, filepos, 1)) * 256) + asc(mid(image, filepos + 1, 1));
		            }
		          }
		        } else {
		          error_message = "BadHeader,JPEG Header Possibly Corrupt,There has been a problem with reading the JPEG header.";
		          filepos = size;
		        }
		      }
		      // check to make sure image information block was located
		      if (not isdefined("height")) {
		        error_message = "BadHeader,JPEG SOFn Not Found,Could not find image information header marker.";
		      }
		    // ---- PNG ----
		    } else if (imagesig is "#chr(137)#PNG") {
		      type = "PNG";
		      if (size gt 33) {
		        // only extracting 3 of the 4 size bytes... who's gonna have a web image
		        // larger than 16777216 pixels :)
		        width = (asc(mid(image, 18, 1)) * 65536) + (asc(mid(image, 19, 1)) * 256) + asc(mid(image, 20, 1));
		        height = (asc(mid(image, 22, 1)) * 65536) + (asc(mid(image, 23, 1)) * 256) + asc(mid(image, 24, 1));
		      } else {
		        error_message = "Badheader,PNG Header Possibly Corrupt,There has been a problem with reading the PNG header.";
		      }
		    // ---- GIF ----
		    } else if (imagesig is "GIF8") {
		      if (size gt 10) {
		        type = mid(image, 1, 6);
		        width = asc(mid(image, 7, 1)) + (asc(mid(image, 8, 1)) * 256);
		        height = asc(mid(image, 9, 1)) + (asc(mid(image, 10, 1)) * 256);
		      } else {
		        error_message = "BadHeader,GIF Header Possibly Corrupt,There has been a problem with reading the GIF header.";
		      }
		    // unsupported file type
		    } else {
		      error_message = "UnrecognizedFile,Format Not Recognized,Could not determine the format of the file #arguments.file#";
		    }
		  // file was too small
		  } else {
		    error_message = "UnrecognizedFile,Format Not Recognized,Could not determine the format of the file or file was not found: #arguments.file#";
		  }
		  // if no errors, set up imageinfo structure in the caller
		  if (not isdefined("error_message")) {
		    imageinfo = structnew();
		    structinsert(imageinfo, "filename", arguments.file);
		    structinsert(imageinfo, "type", type);
		    structinsert(imageinfo, "height", height);
		    structinsert(imageinfo, "width", width);
		    structinsert(imageinfo, "size", size);
		  }
		</cfscript>
		
		<!--- throw a cold fusion error if we had problems --->
		<cfif isdefined("error_message")>
		  <cfthrow type="ImageInfo.#listgetat(error_message, 1)#" message="CF_IMAGEINFO: #listgetat(error_message, 2)#" detail="#listgetat(error_message, 3)#">
		</cfif>

		<cfreturn imageinfo>		
	</cffunction>

	<cffunction name="deletePhoto" access="public" displayname="Deletes Picture" hint="Deletes Picture" returntype="struct">
		<cfargument name="image_path" required="no" type="string" default="">
		<cfargument name="image_name" required="no" type="string" default="">

		<cfscript>
			var.success = StructNew();
			var.success.success = "Yes";
			var.success.reason = "";
		</cfscript>		
		<cftry>
			<cffile action="delete" file="#arguments.image_path#\#arguments.image_name#">

			<cfcatch type="Any">
				<cfscript>
					var.success.success = "No";
					var.success.reason = "There was a problem uploading the image.--#cfcatch.message#*";
				</cfscript>

				<cfreturn var.success>
			</cfcatch>
		</cftry>

		<cfreturn var.success>
	</cffunction>
</cfcomponent>