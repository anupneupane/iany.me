---
updated_at: <2012-12-12 07:07:05>
created_at: <2011-12-03 03:40:47>
title: Rails Config
tags: web, rails, ruby
class: no-chapsec
comment: false
---

Source: [Rails HTTP Status Code to Symbol Mapping](http://www.codyfauser.com/2008/7/4/rails-http-status-code-to-symbol-mapping)

1xx Informational
-----------------

<%=render_table(<<TABLE)
|       Status Code | Status Message                  | Symbol                           |
|-------------------+---------------------------------+----------------------------------|
|               100 | Continue                        | :continue                        |
|               101 | Switching Protocols             | :switching_protocols             |
|               102 | Processing                      | :processing                      |
TABLE
%>

2xx Success
-----------

<%=render_table(<<TABLE)
|       Status Code | Status Message                  | Symbol                           |
|-------------------+---------------------------------+----------------------------------|
|               200 | OK                              | :ok                              |
|               201 | Created                         | :created                         |
|               202 | Accepted                        | :accepted                        |
|               203 | Non-Authoritative Information   | :non_authoritative_information   |
|               204 | No Content                      | :no_content                      |
|               205 | Reset Content                   | :reset_content                   |
|               206 | Partial Content                 | :partial_content                 |
|               207 | Multi-Status                    | :multi_status                    |
|               226 | IM Used                         | :im_used                         |
TABLE
%>

3xx Redirection
----------------

<%=render_table(<<TABLE)
|       Status Code | Status Message                  | Symbol                           |
|-------------------+---------------------------------+----------------------------------|
|               300 | Multiple Choices                | :multiple_choices                |
|               301 | Moved Permanently               | :moved_permanently               |
|               302 | Found                           | :found                           |
|               303 | See Other                       | :see_other                       |
|               304 | Not Modified                    | :not_modified                    |
|               305 | Use Proxy                       | :use_proxy                       |
|               307 | Temporary Redirect              | :temporary_redirect              |
TABLE
%>

4xx Client Error
----------------

<%=render_table(<<TABLE)
|       Status Code | Status Message                  | Symbol                           |
|-------------------+---------------------------------+----------------------------------|
|               400 | Bad Request                     | :bad_request                     |
|               401 | Unauthorized                    | :unauthorized                    |
|               402 | Payment Required                | :payment_required                |
|               403 | Forbidden                       | :forbidden                       |
|               404 | Not Found                       | :not_found                       |
|               405 | Method Not Allowed              | :method_not_allowed              |
|               406 | Not Acceptable                  | :not_acceptable                  |
|               407 | Proxy Authentication Required   | :proxy_authentication_required   |
|               408 | Request Timeout                 | :request_timeout                 |
|               409 | Conflict                        | :conflict                        |
|               410 | Gone                            | :gone                            |
|               411 | Length Required                 | :length_required                 |
|               412 | Precondition Failed             | :precondition_failed             |
|               413 | Request Entity Too Large        | :request_entity_too_large        |
|               414 | Request-URI Too Long            | :request_uri_too_long            |
|               415 | Unsupported Media Type          | :unsupported_media_type          |
|               416 | Requested Range Not Satisfiable | :requested_range_not_satisfiable |
|               417 | Expectation Failed              | :expectation_failed              |
|               422 | Unprocessable Entity            | :unprocessable_entity            |
|               423 | Locked                          | :locked                          |
|               424 | Failed Dependency               | :failed_dependency               |
|               426 | Upgrade Required                | :upgrade_required                |
TABLE
%>


5xx Server Error
----------------

<%=render_table(<<TABLE)
|       Status Code | Status Message                  | Symbol                           |
|-------------------+---------------------------------+----------------------------------|
|               500 | Internal Server Error           | :internal_server_error           |
|               501 | Not Implemented                 | :not_implemented                 |
|               502 | Bad Gateway                     | :bad_gateway                     |
|               503 | Service Unavailable             | :service_unavailable             |
|               504 | Gateway Timeout                 | :gateway_timeout                 |
|               505 | HTTP Version Not Supported      | :http_version_not_supported      |
|               507 | Insufficient Storage            | :insufficient_storage            |
|               510 | Not Extended                    | :not_extended                    |
TABLE
%>
