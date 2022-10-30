sub init()
    m.port = createObject("roMessagePort")
    m.top.observeField("request", m.port)
    m.top.functionName = "go"
    m.top.control = "RUN"
end sub

function go()
    executing = true
    while executing
        msg = wait(0, m.port)
        if type(msg) = "roSGNodeEvent"
            if msg.getField() = "request"
                data = msg.getData().data
                method = data.method
                m.top.request.url = ""
                if method <> "GET" and method <> "POST" and method <> "PUT" and method <> "DELETE"
                else
                    if method = "GET"
                        return get(data.url, data.from, data.headers)
                    end if
                end if
                executing = false
            end if
        end if
    end while
end function

function getHeaders() as object
    headers = {
        "Content-Type": "application/json",
        "Accept": "*/*",
        "Accept-Encoding": "gzip, deflate, br",
        "Connection": "keep-alive"
    }
    return headers
end function

function get(url as string, from as string, extraHeaders as object) as dynamic
    request = CreateObject("roUrlTransfer")
    port = m.port
    request.SetUrl(url)
    request.EnableHostVerification(false)
    request.EnablePeerVerification(false)
    request.setPort(port)
    headers = getHeaders()
    request.setHeaders(headers)
    request.RetainBodyOnError(true)
    cb = request.AsyncGetToString()
    if cb
        while (true)
            msg = wait(0, port)
            if type(msg) = "roUrlEvent"
                if msg <> invalid
                    parsedResponse = parseJson(msg)
                    m.top.content = parsedResponse
                end if
            else if (msg = invalid)
                request.AsyncCancel()
            end if
        end while
    end if
    return invalid
end function