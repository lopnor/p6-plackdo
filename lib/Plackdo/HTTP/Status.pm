use v6;

class Plackdo::HTTP::Status {
    my %StatusCode = (
        100 => 'Continue',
        101 => 'Switching Protocols',
        102 => 'Processing',                      # RFC 2518 (WebDAV)
        200 => 'OK',
        201 => 'Created',
        202 => 'Accepted',
        203 => 'Non-Authoritative Information',
        204 => 'No Content',
        205 => 'Reset Content',
        206 => 'Partial Content',
        207 => 'Multi-Status',                    # RFC 2518 (WebDAV)
        300 => 'Multiple Choices',
        301 => 'Moved Permanently',
        302 => 'Found',
        303 => 'See Other',
        304 => 'Not Modified',
        305 => 'Use Proxy',
        307 => 'Temporary Redirect',
        400 => 'Bad Request',
        401 => 'Unauthorized',
        402 => 'Payment Required',
        403 => 'Forbidden',
        404 => 'Not Found',
        405 => 'Method Not Allowed',
        406 => 'Not Acceptable',
        407 => 'Proxy Authentication Required',
        408 => 'Request Timeout',
        409 => 'Conflict',
        410 => 'Gone',
        411 => 'Length Required',
        412 => 'Precondition Failed',
        413 => 'Request Entity Too Large',
        414 => 'Request-URI Too Large',
        415 => 'Unsupported Media Type',
        416 => 'Request Range Not Satisfiable',
        417 => 'Expectation Failed',
        422 => 'Unprocessable Entity',            # RFC 2518 (WebDAV)
        423 => 'Locked',                          # RFC 2518 (WebDAV)
        424 => 'Failed Dependency',               # RFC 2518 (WebDAV)
        425 => 'No code',                         # WebDAV Advanced Collections
        426 => 'Upgrade Required',                # RFC 2817
        449 => 'Retry with',                      # unofficial Microsoft
        500 => 'Internal Server Error',
        501 => 'Not Implemented',
        502 => 'Bad Gateway',
        503 => 'Service Unavailable',
        504 => 'Gateway Timeout',
        505 => 'HTTP Version Not Supported',
        506 => 'Variant Also Negotiates',         # RFC 2295
        507 => 'Insufficient Storage',            # RFC 2518 (WebDAV)
        509 => 'Bandwidth Limit Exceeded',        # unofficial
        510 => 'Not Extended',                    # RFC 2774
    );

    method status_message (Int $code) {
        return %StatusCode{ $code }
    }

    method is_info         (Int $code) { $code >= 100 && $code < 200; }
    method is_success      (Int $code) { $code >= 200 && $code < 300; }
    method is_redirect     (Int $code) { $code >= 300 && $code < 400; }
    method is_error        (Int $code) { $code >= 400 && $code < 600; }
    method is_client_error (Int $code) { $code >= 400 && $code < 500; }
    method is_server_error (Int $code) { $code >= 500 && $code < 600; }
}

# vim: ft=perl6 :
