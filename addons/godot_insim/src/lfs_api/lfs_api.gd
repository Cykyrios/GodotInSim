extends Node


var access_token_url := "https://id.lfs.net/oauth2/access_token"
var credentials_file := "res://addons/godot_insim/secrets/lfs_api.txt"
var token_path := "user://lfs_api/token.txt"
var api_url := "https://api.lfs.net/"

var token := ""


## Generic API request, returns a [Dictionary] with the complete HTTP response.
## You should use API wrapper functions where available (see [method get_mod_list] and
## [method get_mod_details] for instance). You need to pass the access point to [param request],
## for instance [code]vehiclemod[/code] for the list of mods. If an authorization error occurs,
## a new access token will be generated, and the request sent again.
func get_api_request(request: String) -> Dictionary:
	var response := {}
	var read_api_response := func read_api_response(
		result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray
	) -> void:
		if result != HTTPRequest.Result.RESULT_SUCCESS:
			push_warning("HTTP request failed: error %s" % [result])
			return
		response["result"] = result
		response["code"] = response_code
		response["headers"] = headers
		response["body"] = JSON.parse_string(body.get_string_from_utf8())

	var http_request := HTTPRequest.new()
	add_child(http_request)
	var _connect := http_request.request_completed.connect(read_api_response)
	token = _get_token_from_cache()
	if token.is_empty():
		token = await _get_access_token()
		if token == "abort":
			return {}
	var request_token := "Authorization: Bearer %s" % [token]
	var error := http_request.request(api_url + request, [request_token], HTTPClient.METHOD_GET)
	if error:
		push_error("Failed to perform HTTP request: code %d" % [error])
	else:
		await http_request.request_completed
	http_request.queue_free()
	var response_body := response["body"] as Dictionary
	if response["code"] == 401 and response_body.has("error"):
		var error_message := str((response_body["error"] as Dictionary)["message"])
		if error_message.contains("expired") or error_message.contains("parse"):
			token = await _get_access_token()
			if token == "abort":
				return {}
			response = await get_api_request(request)
	return response


## Returns all information about the mod corresponding to the given [param skin_id],
## including detailed engine info, mass, power-to-weight ratio, etc.
func get_mod_details(skin_id: String) -> Dictionary:
	var response := await get_api_request("vehiclemod/%s" % [skin_id])
	if response.is_empty():
		return {}
	var body := response["body"] as Dictionary
	if not body.has("data"):
		if body.has("error") and (body["error"] as Dictionary).has("message"):
			_push_api_error(response["code"] as int, str(body["error"]["message"]))
		else:
			_push_api_error(response["code"] as int, "unknown error")
		return body
	var data := body["data"] as Dictionary
	return data


## Returns the list of currently available vehicle mods.
func get_mod_list() -> Array[Dictionary]:
	var response := await get_api_request("vehiclemod")
	if response.is_empty():
		return []
	var body := response["body"] as Dictionary
	if not body.has("data"):
		if body.has("error") and (body["error"] as Dictionary).has("message"):
			_push_api_error(response["code"] as int, str(body["error"]["message"]))
		else:
			_push_api_error(response["code"] as int, "unknown error")
		return []
	var data: Array[Dictionary] = []
	data.assign(body["data"] as Array[Dictionary])
	return data


#region Access token
func _get_access_token() -> String:
	print("Requesting new access token")
	var file := FileAccess.open(credentials_file, FileAccess.READ)
	if not file:
		var file_error := FileAccess.get_open_error()
		push_error("Failed to open credentials file, aborting (error %d)" % [file_error])
		return "abort"
	var client_id := file.get_line()
	var client_secret := file.get_line()
	var request_data := "&".join([
		"grant_type=client_credentials",
		"client_id=" + client_id,
		"client_secret=" + client_secret,
	])

	var read_token_response := func read_token_response(
		result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray
	) -> void:
		var response := {}
		if result != HTTPRequest.Result.RESULT_SUCCESS:
			push_warning("HTTP request failed: error %s" % [result])
			return
		response["result"] = result
		response["code"] = response_code
		response["headers"] = headers
		response["body"] = body
		var token_response := JSON.parse_string(body.get_string_from_utf8()) as Dictionary
		if response_code == 401:
			_push_api_error(response["code"] as int, "Authentication error")
			return
		elif response_code != 200 or not token_response.has("access_token"):
			_push_api_error(response["code"] as int, "Did not receive access token")
			return
		token = token_response["access_token"] as String

	var http_request := HTTPRequest.new()
	add_child(http_request)
	var _connect := http_request.request_completed.connect(read_token_response)
	var error := http_request.request(
		access_token_url,
		["Content-Type: application/x-www-form-urlencoded"],
		HTTPClient.METHOD_POST,
		request_data
	)
	if error:
		push_error("Failed to perform HTTP request: code %d" % [error])
	else:
		await http_request.request_completed
	http_request.queue_free()
	_set_token_cache()
	return token


func _get_token_from_cache() -> String:
	var file := FileAccess.open(token_path, FileAccess.READ)
	if not file:
		return ""
	return file.get_line()


func _set_token_cache() -> void:
	var _dir := DirAccess.make_dir_recursive_absolute(token_path.get_base_dir())
	var file := FileAccess.open(token_path, FileAccess.WRITE)
	if not file:
		print(FileAccess.get_open_error())
		return
	var _discard := file.store_line(token)
#endregion


#region API log
func _push_api_error(code: int, error: String) -> void:
	push_error("LFS API error %d: %s" % [code, error])


func _push_api_warning(warning: String) -> void:
	push_warning("LFS API warning: " + warning)
#endregion
