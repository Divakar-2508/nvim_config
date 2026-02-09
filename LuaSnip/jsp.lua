local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

return {
	-- Basic JSP page skeleton
	s(
		"jspbase",
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
        {}
    </body>
    </html>
  ]],
			{ i(1, "Page Title"), i(2, "Content here") }
		)
	),

	-- JSP expression
	s("exp", fmt("<%= {} %>", { i(1, "expression") })),

	-- JSP scriptlet
	s(
		"scr",
		fmt(
			[[
    <%
        {}
    %>
  ]],
			{ i(1, "// Java code") }
		)
	),

	-- JSP declaration
	s(
		"dec",
		fmt(
			[[
    <%! 
        {}
    %>
  ]],
			{ i(1, "// Declaration") }
		)
	),

	-- JSP include
	s("inc", fmt('<%@ include file="{}" %>', { i(1, "header.jsp") })),

	-- JSP forward
	s("fwd", fmt('<jsp:forward page="{}" />', { i(1, "next.jsp") })),

	-- JSTL forEach
	s(
		"foreach",
		fmt(
			[[
    <c:forEach var="{}" items="{}">
        {}
    </c:forEach>
  ]],
			{ i(1, "item"), i(2, "${list}"), i(3, "Content") }
		)
	),

	-- JSTL if
	s(
		"cif",
		fmt(
			[[
    <c:if test="{}">
        {}
    </c:if>
  ]],
			{ i(1, "${condition}"), i(2, "Content") }
		)
	),

	-- JSTL choose/when/otherwise
	s(
		"choose",
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
			{ i(1, "${condition}"), i(2, "When true"), i(3, "Otherwise") }
		)
	),

	-- Print a variable (shortcut)
	s("out", fmt('<c:out value="{}" />', { i(1, "${variable}") })),

	-- Custom taglib
	s("taglib", fmt('<%@ taglib prefix="{}" uri="{}" %>', { i(1, "c"), i(2, "http://java.sun.com/jsp/jstl/core") })),
}
