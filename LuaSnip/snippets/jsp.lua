local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

return {
	-- Basic JSP scriptlet
	s("jsp-scriptlet", fmt("<% {} %>", { i(1, "// Java code here") })),

	-- JSP expression
	s("jsp-expr", fmt("<%= {} %>", { i(1, "variable") })),

	-- JSP declaration
	s("jsp-decl", fmt("<%! {} %>", { i(1, "int counter = 0;") })),

	-- JSP page directive
	s(
		"jsp-page",
		fmt('<%@ page language="java" contentType="text/html; charset=UTF-8"\n    pageEncoding="UTF-8"%>', {})
	),

	-- JSP include directive
	s("jsp-include", fmt('<%@ include file="{}" %>', { i(1, "header.jsp") })),

	-- JSP taglib directive
	s(
		"jsp-taglib",
		fmt('<%@ taglib uri="{}" prefix="{}" %>', { i(1, "http://java.sun.com/jsp/jstl/core"), i(2, "c") })
	),

	-- JSTL if
	s("c-if", fmt('<c:if test="{}">\n    {}\n</c:if>', { i(1, "${condition}"), i(2, "content") })),

	-- JSTL forEach
	s(
		"c-for",
		fmt(
			'<c:forEach var="{}" items="{}">\n    {}\n</c:forEach>',
			{ i(1, "item"), i(2, "${collection}"), i(3, "content") }
		)
	),

	-- JSTL choose / when / otherwise
	s(
		"c-choose",
		fmt(
			[[
<c:choose>
    <c:when test="{}">
        {}
    </c:when>
    <c:otherwise>
        {}
    </c:otherwise>
</c:choose>
]],
			{ i(1, "${condition}"), i(2, "when true"), i(3, "otherwise") }
		)
	),

	-- JSTL out
	s("c-out", fmt('<c:out value="{}" />', { i(1, "${variable}") })),

	-- Struts2 form
	s(
		"s-form",
		fmt(
			[[
<s:form action="{}" method="{}">
    {}
</s:form>
]],
			{ i(1, "actionName"), i(2, "post"), i(3, "Form fields") }
		)
	),

	-- Struts2 textfield
	s("s-textfield", fmt('<s:textfield name="{}" label="{}" />', { i(1, "fieldName"), i(2, "Label") })),

	-- Struts2 textarea
	s(
		"s-textarea",
		fmt(
			'<s:textarea name="{}" label="{}" rows="{}" cols="{}" />',
			{ i(1, "fieldName"), i(2, "Label"), i(3, "5"), i(4, "30") }
		)
	),

	-- Struts2 submit
	s("s-submit", fmt('<s:submit value="{}" />', { i(1, "Submit") })),

	-- Full JSP skeleton
	s(
		"jsp-base",
		fmt(
			[[
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>{}</title>
</head>
<body>
    <h1>{}</h1>
    <%
        {}
    %>
</body>
</html>
]],
			{ i(1, "Title"), i(2, "Header Text"), i(3, "// Java logic here") }
		)
	),

	-- JSTL core taglib
	s("c-taglib", fmt('<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>', {})),

	-- Struts2 taglib
	s("s-taglib", fmt('<%@ taglib prefix="s" uri="/struts-tags" %>', {})),

	-- s:form with enctype multipart (file upload)
	s(
		"s-form-file",
		fmt(
			[[
<s:form action="{}" method="{}" enctype="multipart/form-data">
    {}
</s:form>
]],
			{ i(1, "uploadAction"), i(2, "post"), i(3, "Form fields") }
		)
	),

	-- s:select with list
	s(
		"s-select",
		fmt(
			[[
<s:select name="{}" list="{}" label="{}" headerKey="" headerValue="{}"/>
]],
			{ i(1, "country"), i(2, "countries"), i(3, "Country"), i(4, "Select") }
		)
	),

	-- s:checkbox / s:radio
	s("s-checkbox", fmt('<s:checkbox name="{}" label="{}" />', { i(1, "subscribe"), i(2, "Subscribe to newsletter") })),
	s(
		"s-radio",
		fmt('<s:radio name="{}" list="{}" label="{}" />', { i(1, "gender"), i(2, "genders"), i(3, "Gender") })
	),

	-- s:property (print action value)
	s("s-property", fmt('<s:property value="{}" />', { i(1, "username") })),

	-- s:iterator (loop over list)
	s(
		"s-iterator",
		fmt(
			[[
<s:iterator value="{}" var="{}">
    {}
</s:iterator>
]],
			{ i(1, "users"), i(2, "user"), i(3, "Content here") }
		)
	),

	-- s:if / s:else
	s(
		"s-if",
		fmt(
			[[
<s:if test="{}">
    {}
</s:if>
]],
			{ i(1, "user.loggedIn"), i(2, "Content if true") }
		)
	),
	s(
		"s-else",
		fmt(
			[[
<s:else>
    {}
</s:else>
]],
			{ i(1, "Content if false") }
		)
	),

	-- Error / FieldError display
	s("s-error", fmt('<s:fielderror field="{}" />', { i(1, "username") })),
	s("s-actionerror", fmt("<s:actionerror />", {})),
	s("s-actionmessage", fmt("<s:actionmessage />", {})),
}
