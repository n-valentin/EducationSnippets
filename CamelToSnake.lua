--[[
This was done with Lua 5.5, without libraries.
I will try to over-explain everything in extreme detail.
A lot of this is better-documented in the Lua handbook: https://www.lua.org/pil/

@param defines parameters in functions or methods, where applicable
For example: --]]
---@param testString string
function Somethingidk(testString)
  -- ...
end

-- This happens to be a bit easier to work with, in other forks of Lua, such as Luau (via Roblox Studio)
function Somethingidk2(testString : String)
  -- ...
end

--[[

Let's get into what everything does.

in the string function, I am accessing the string CLASS, since data in Lua, is all tables, the data is extremely dynamic.
- Parameters don't matter in the front-end, in Lua, they're only for abstraction and longevity.

I start by defining a temporary container, lua does not by default have garbage collection, this has to be introduced manually afaik..
You can however choose to not give a shit if it's just a test program.

Next is the for-loop, or in scripting terms a numeric *for* -- https://www.lua.org/pil/4.3.4.html
We define i (iteration) as 1, since arrays and loops are best handled at index-1, in Lua -- https://www.lua.org/pil/11.1.html
We make use of a string function, specifically a character-counted (String.Length), abbreviated to s.len() -- it counts the bytes of a string.
Effectively, we have X amount of iterations based on our input, if our string is 19 characters-long, our loop will have 19 iterations.

In this numeric for-loop we have to very precisely manipulate our given string variable from the function parameter.
The goal is to turn camelCase text, into snake_case text.
We start by grabbing the exact byte (or character) of our text, using string.sub(s,i,j) -- abbreviation for subject, I think... doesn't really matter.
- e.g. if our text is "Carrot" and the iteration is 2, the result of our .sub is "arrot",
--and we can change which character to end on, in this case the same character. If so, we can grab "a".

Our string.sub variable only serves a single purpose. To be a shortcut.
Instead of using the same method to reference this character, we simply store it temporarily,
--to use less resources and use more RAM. (like 1 byte)
For final reference; The "c" variable, is the character we're focusing on, in the for-loop.

Now we need to build the result. To do that we make use of the string.match method. (Even tho it's a function...)
In this case we don't need to learn what .match does, only that it can be used to detect UPPERCASE letters.
string.match return a string, or nil. It does this when it finds a match with a given pattern.
In this case we're using the "%u" pattern.
We don't care about what string.match spits out, only whether it gives us a result or not.
- If it gives us a result, we still don't care what it is but we know, it has found an UPPERCASE character.
- If it doesn't give us a result, we can move on, and we know, that the currently-focused character, our "c" variable's value, is not UPPERCASE.

By default, we want to rebuild our given string from the function, left to right.
Let's ignore the string.match condition for now;
- Each iteration, we take the current character. If the text is "Carrot", we start with "C", next we get "Ca", then "Car", then "Carr", etc.
We're doing that if the letters are *not* UPPERCASE.
With our string.match condition, we want to change this outcome.
- If the character is UPPERCASE, we *instead* place an underscore >> "_"
- and THEN we place our character

What this effectively does, is turning e.g. "camelCaseTest" into "camel_case_test"
- We iterate through each character; c, a, m, e, l, **C** <<<< this is UPPERCASE, we put an underscore here, and then the C.

However we still haven't turned it into a lowercase character.
To do that, we could introduce string.lower() when our condition is met   >>>   result = result .. "_" .. string.lower(c)
- but we need to save performance...
Instead, we do that last...

When we're done iterating through the text and the loop is done, we need to spit out our result.
We return what we have.
This means, when we try to make a variable, that references the function, our variable will be set to what the function returns.
Effectively it doesn't matter what this function does.
- If it returns a value, the variable will be set to it, and the function can do whatever it wants.

That said, this is where we place our string.lower, we have to lowercase-ify our result.
- return string.lower(res)

Now we can turn any camelCase string into snake_case, or just about anything else.
However, if the first character is uppercase...
- that means, a text like "Carrot" will become "_carrot", and a text like "CARROT" will become "_c_a_r_r_o_t"

We'll make a variable to store said result, to use for later or just abstraction.

Then we print it...

]]


---@deprecated
local function Init()

    ---@param text string
    function string.ToSnakeCasing(text)

        -- Define container, a temporary result
        local res = ""

        -- Iterate through characters in given string
        for i=1, string.len(text) do
            -- character counting
            local c = string.sub(text, i, i)

            --Dynamic nil condition
            -- %u: represents all uppercase letters.
            if string.match(c, "%u") then
                res = res .. "_" .. c
            else
                res = res .. c
            end
        end

        return string.lower(res)
    end

    local toSnakeCasing = string.ToSnakeCasing("camelTestIGuessCheckThisOut")

    print("Result: " .. toSnakeCasing)

end

Init() -- Run that code



-- Abstract version

local function Init2()

    --- Main function. Converts and returns given string into snake_case.
    --- 
    ---@param text string
    function string.ToSnakeCasing(text)

        --- Returns the iteration's character from given string.
        ---
        ---@params s string
        ---@params i integer
        ---@return string
        local function _subIteration(s, i)
            return string.sub(s, i, i)
        end

        --- Returns true if a character in the string is UPPERCASE.
        ---
        --- Pattern "%u": represents all uppercase letters.
        ---
        ---@params s string
        ---@return boolean
        local function _matchUppercase(s)
            return string.match(s, "%u") == not nil
        end

        --- Merge string for UPPERCASE result
        ---
        ---@params s1 string
        ---@params s2 string
        ---@return string
        local function _resultUpper(s1, s2)
            return s1 .. "_" .. s2
        end

        --- Merge string for lowercase result
        ---
        ---@params s1 string
        ---@params s2 string
        ---@return string
        local function _resultLower(s1, s2)
            return s1 .. s2
        end

        -- Define container, a temporary result
        local res = ""

        -- Iterate through each byte in given string. len = length
        for i=1, string.len(text) do

            local _char = _subIteration(text, i)
            local _isUppercase = _matchUppercase(_char)

            if _isUppercase then
                res = _resultUpper()
            else
                res = _resultLower()
            end
        end

        return string.lower(res) -- Final Result
    end


    local userInput = "camelTestIGuessCheckThisOut"
    local toSnakeCasing = string.ToSnakeCasing(userInput)

    print("Result: " .. toSnakeCasing)

end

Init2() -- Run that code


--//
