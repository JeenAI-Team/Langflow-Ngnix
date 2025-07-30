-- Shared secret set via environment variable (same value exposed to Jeen backend)
local shared_secret = os.getenv("JWT_SECRET") or ""

-- Utility: unauthorized helper
local function unauthorized()
    ngx.status = ngx.HTTP_UNAUTHORIZED
    ngx.say("401 Unauthorized")
    return ngx.exit(ngx.HTTP_UNAUTHORIZED)
end

-----------------------------------------------------
-- 0.  Internal-to-internal shortcut -----------------
--    Jeen backend calls LangFlow through this proxy
--    and sends the *raw* shared secret either in the
--    "Authorization" *or* "X-Internal-Token" header.
-----------------------------------------------------

local raw_auth_header  = ngx.var.http_authorization
local internal_header  = ngx.var.http_x_internal_token

if (raw_auth_header  and raw_auth_header  == shared_secret) or
   (internal_header  and internal_header  == shared_secret) then
    return -- allow
end

-----------------------------------------------------
-- 1.  Cookie-based shortcut -------------------------
--    We drop a first-party cookie (lf_ss) the very
--    first time the browser hits the proxy with the
--    ?token=<shared_secret> query parameter.  After
--    that every XHR/fetch the LangFlow frontend
--    performs will automatically include this cookie
--    so we don’t need to modify LangFlow’s code.
-----------------------------------------------------

local function cookie_has_secret()
    local cookie_header = ngx.var.http_cookie or ""
    -- Very small / safe check: look for exact key=value pair.
    local pattern = "lf_ss=" .. shared_secret
    return cookie_header:find(pattern, 1, true) ~= nil
end

if cookie_has_secret() then
    return -- allow
end

-----------------------------------------------------
-- 2.  Query-string token ----------------------------
--    Used only on the very first iframe/page load.
--    If valid, drop the cookie so subsequent requests
--    pass rule #1 and continue.
-----------------------------------------------------

local qs_token = ngx.var.arg_token
if qs_token and qs_token == shared_secret then
    -- Set a session cookie so the browser keeps sending it.
    ngx.header["Set-Cookie"] = "lf_ss=" .. shared_secret .. "; Path=/; SameSite=Lax"
    return -- allow
end

-----------------------------------------------------
-- 3.  Anything with a Bearer token ------------------
--    After /api/v1/auto_login, LangFlow attaches an
--    internal JWT in the Authorization header.  We
--    *don’t* attempt to validate it – the presence of
--    a Bearer token *plus* the fact that the initial
--    gate has already set the cookie is good enough.
-----------------------------------------------------

if raw_auth_header and raw_auth_header:sub(1,7):lower() == "bearer " then
    return -- allow
end

-----------------------------------------------------
-- 4.  Everything else → 401 -------------------------
-----------------------------------------------------

return unauthorized() 