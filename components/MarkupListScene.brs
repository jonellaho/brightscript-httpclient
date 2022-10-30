'********** Copyright 2016 Roku Corp.  All Rights Reserved. **********

function init()
    m.MarkupList = m.top.findNode("MarkupList")
    m.background = m.top.findNode("background")
	m.MarkupList.SetFocus(true)
    m.httpclient = CreateObject("roSGNode", "httpclient")
    m.httpclient.observeField("content", "onResponseReceived")
    fetchData("http://de-coding-test.s3.amazonaws.com/books.json")


    'dynamic params for width&height 
    di = CreateObject("roDeviceInfo")
    displaySize = di.GetDisplaySize()
    m.background.height = displaySize.h
    m.background.width = displaySize.w

end function

function getMarkupListData(res) as object
    data = CreateObject("roSGNode", "ContentNode")
    for each item in res
        dataItem = data.CreateChild("ListItemData")
        dataItem.posterUrl = item.imageURL
        dataItem.labelText = item.title
    end for
    return data
end function

sub fetchData(urlPath)
    req = CreateObject("roSGNode", "Node")
    req.addFields({
        url: urlPath,
        method: "GET",
        from: "fetchData"
    })
    m.httpclient.request = { data: req }
end sub


sub onResponseReceived(event as object)
    res = m.httpclient.content
    m.MarkupList.content = getMarkupListData(res)
end sub





