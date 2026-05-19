local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local rep = require("luasnip.extras").rep
local fmt = require("luasnip.extras.fmt").fmt

return {
	-- 1. Standard C Function
	s(
		"fn",
		fmt(
			[[
    {} {}({}) {{
        {}
    }}
    ]],
			{
				i(1, "void"),
				i(2, "function_name"),
				i(3, "void"),
				i(4, "/* implementation */"),
			}
		)
	),

	-- 2. Standard C Main Function
	s(
		"main",
		fmt(
			[[
    int main(int argc, char** argv) {{
        {}
        return 0;
    }}
    ]],
			{
				i(1, "/* code */"),
			}
		)
	),

	-- 3. C-Compliant Hello World
	s(
		"hw",
		fmt(
			[[
    #include <stdio.h>

    int main(int argc, char** argv) {{
        printf("Hello, World!\n");
        {}
        return 0;
    }}
    ]],
			{
				i(1),
			}
		)
	),

	-- 4. Typedef Struct Pattern
	-- Utilizes 'rep' to automatically mirror the struct name
	s(
		"struct",
		fmt(
			[[
    typedef struct {} {{
        {}
    }} {};
    ]],
			{
				i(1, "StructName"),
				i(2, "/* data */"),
				rep(1),
			}
		)
	),

	-- 5. Safe Memory Allocation (malloc with NULL check)
	-- Utilizes 'rep' to mirror the type and variable name automatically
	s(
		"malloc",
		fmt(
			[[
    {}* {} = malloc({} * sizeof({}));
    if ({} == NULL) {{
        {}
    }}
    ]],
			{
				i(1, "type"),
				i(2, "ptr"),
				i(3, "count"),
				rep(1),
				rep(2),
				i(4, "return -1;"),
			}
		)
	),

	-- 6. Include Guard for Header Files
	s(
		"guard",
		fmt(
			[[
    #ifndef {}_H
    #define {}_H

    {}

    #endif // {}_H
    ]],
			{
				i(1, "HEADER_NAME"),
				rep(1),
				i(2, "/* declarations */"),
				rep(1),
			}
		)
	),

	-- 7. Standard For-Loop
	s(
		"for",
		fmt(
			[[
    for (size_t {} = 0; {} < {}; ++{}) {{
        {}
    }}
    ]],
			{
				i(1, "i"),
				rep(1),
				i(2, "length"),
				rep(1),
				i(3, "/* body */"),
			}
		)
	),
}
