{
	// Place your global snippets here. Each snippet is defined under a snippet name and has a scope, prefix, body and 
	// description. Add comma separated ids of the languages where the snippet is applicable in the scope field. If scope 
	// is left empty or omitted, the snippet gets applied to all languages. The prefix is what is 
	// used to trigger the snippet and the body will be expanded and inserted. Possible variables are: 
	// $1, $2 for tab stops, $0 for the final cursor position, and ${1:label}, ${2:another} for placeholders. 
	// Placeholders with the same ids are connected.
	// Example:
	// "Print to console": {
	// 	"scope": "javascript,typescript",
	// 	"prefix": "log",
	// 	"body": [
	// 		"console.log('$1');",
	// 		"$2"
	// 	],
	// 	"description": "Log output to console"
	//
 	"New-AuditManifest":{
		"scope": "json",
		"prefix": "jsonAuditManifest",
		"body": ["{",
		"\t\"@type\":\"File\",",
		"\t\"file_name\":\"${1:fileName.ext}\",",
		"\t\"data_disposition\":\"${2|keep,archive,purge|}\",",
		"\t\"comment\":\"${3|nonviable code: missing database objects or data management processes,inactive report: data set not reproducible,purge: all|}\"",
		"}",
		]
	},
	"New-AuditLog":{
		"scope": "json",
		"prefix": "jsonAuditLog",
		"body": ["{",
		"\t\"@context\": {",
			"\t\t\"vocab\": \"http://schema.org/\",",
			"\t\t\"auditor\": \"agent\",",
			"\t\t\"event_name\": \"name\",",
			"\t\t\"directory_path\": \"location\",",
			"\t\t\"event_date\": \"endTime\",",
			"\t\t\"event_state\": \"actionStatus\",",
			"\t\t\"manifest\": \"Array\",",
			"\t\t\"file_name\": \"name\",",
			"\t\t\"data_disposition\": \"actionStatus\",",
			"\t\t\"comment\": \"comment\"",
		"\t},",
		"\t\"auditor\":\"${1:ADAccount}\",",
		"\t\"event_name\":\"${2|audit,admin,data modification|}\",",
		"\t\"directory_path\":\"//SERVER/directory/${3:file directory name}\",",
		"\t\"description\":\"${4:data disposition review}\",",
		"\t\"event_date\":\"${5:yyyy-mm-dd}\",",
		"\t\"event_state\":\"${6|pre-approval,approved,hold,rejected|}\",",
		"\t\"manifest\": [",
		"\t\t${7:use jsonAuditManifest to create manifests of each file}",
		"\t]",
		"}",
		],
		"description": "Creates a new audit log file. Choose the audit option on event_name. Record all files with their extensions in the manifest array."
	}
}
