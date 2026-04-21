-- lua/plugins/cord.lua
return {
  {
    "vyfor/cord.nvim",
    opts = {
      display = {

        theme = "minecraft",
      },
      buttons = {},
      editor = {
        client = "astronvim",
      },
    },
    -- opts = function()
    --   local visibility = {}
    --
    --   local function probe(repo_url)
    --     if type(repo_url) ~= "string" or repo_url == "" then return end
    --     if visibility[repo_url] ~= nil then return end
    --
    --     local owner, repo = repo_url:match "github%.com[:/]+([^/]+)/([^/%.]+)"
    --     if not owner or not repo or vim.fn.executable "gh" ~= 1 then
    --       visibility[repo_url] = false
    --       return
    --     end
    --
    --     visibility[repo_url] = false
    --     vim.system(
    --       { "gh", "repo", "view", owner .. "/" .. repo, "--json", "visibility", "-q", ".visibility" },
    --       { text = true },
    --       function(result)
    --         visibility[repo_url] = result.code == 0 and (result.stdout or ""):match "PUBLIC" ~= nil
    --       end
    --     )
    --   end
    --
    --   return {
    --     display = {
    --       theme = "minecraft",
    --     },
    --     text = {
    --       workspace = false,
    --     },
    --     buttons = {
    --       {
    --         label = "View Repository",
    --         url = function(opts)
    --           probe(opts.repo_url)
    --           if opts.repo_url and visibility[opts.repo_url] == true then return opts.repo_url end
    --           return nil
    --         end,
    --       },
    --     },
    --     hooks = {
    --       workspace_change = function(opts) probe(opts.repo_url) end,
    --     },
    --   }
    -- end,
  },
}
