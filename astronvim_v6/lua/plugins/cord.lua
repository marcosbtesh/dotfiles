-- lua/plugins/cord.lua
return {
  {
    "vyfor/cord.nvim",
    build = ":Cord update",
    opts = function()
      local visibility_cache = {}

      local function is_public_repo(repo_url)
        if type(repo_url) ~= "string" or repo_url == "" then return false end
        if visibility_cache[repo_url] ~= nil then return visibility_cache[repo_url] end

        local owner, repo = repo_url:match "github%.com[:/]+([^/]+)/([^/%.]+)"
        if not owner or not repo then
          visibility_cache[repo_url] = false
          return false
        end

        if vim.fn.executable "gh" ~= 1 then
          visibility_cache[repo_url] = false
          return false
        end

        local result = vim
          .system({ "gh", "repo", "view", owner .. "/" .. repo, "--json", "visibility", "-q", ".visibility" }, { text = true })
          :wait(3000)
        local public = result.code == 0 and (result.stdout or ""):match "PUBLIC" ~= nil
        visibility_cache[repo_url] = public
        return public
      end

      return {
        text = {
          workspace = false,
        },
        buttons = {
          {
            label = "View Repository",
            url = function(opts)
              if is_public_repo(opts.repo_url) then return opts.repo_url end
              return nil
            end,
          },
        },
      }
    end,
  },
}
