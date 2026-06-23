-- minuet-ai.nvim — AI / LLM code completion delivered as an nvim-cmp source.
-- Works with local servers (LM Studio, Ollama) and cloud providers (OpenAI,
-- Anthropic/Claude, Gemini, Codestral, OpenRouter, …).
--
-- Choosing a backend:
--   * Set `provider` to the block you want from `provider_options` below.
--   * `api_key` is the NAME of an environment variable, NOT the key itself.
--     Export it in your shell, e.g. `export OPENAI_API_KEY=sk-...`.
--   * Local servers ignore the key, so they use the always-present `TERM`
--     variable as a harmless placeholder.
--
-- This file only configures the AI backend. It is plugged into the completion
-- menu (and given a manual trigger) over in `nvim-cmp.lua`.

---@type LazySpec
return {
  "milanglacier/minuet-ai.nvim",
  lazy = true, -- loaded on demand as a dependency of nvim-cmp
  config = function(_, opts) require("minuet").setup(opts) end,
  opts = {
    -- Active backend. Default = LM Studio via the OpenAI-compatible block below.
    -- Switch to: "openai" | "claude" | "gemini" | "codestral" | "openai_fim_compatible"
    provider = "openai_compatible",

    n_completions = 2, -- suggestions requested per trigger (1 call, N variants)
    context_window = 16000, -- max chars of surrounding code sent as context
    throttle = 1000, -- ms: minimum gap between requests (rate limit)
    debounce = 400, -- ms: wait for typing to settle before firing
    notify = "warn", -- "error" to quiet the connection/warn chatter

    -- nvim-cmp integration. Auto-suggest while typing — great for a free local
    -- model. If you move to a paid provider, flip this to `false` and drive it
    -- by hand with the <A-y> mapping defined in `nvim-cmp.lua` to control spend.
    cmp = { enable_auto_complete = true },

    provider_options = {
      -- ── LM Studio (local, OpenAI-compatible server) ──────────────────────
      -- In LM Studio: Developer tab → Start Server (default port 1234), load a
      -- model, then set `model` below to that model's id (shown in LM Studio).
      openai_compatible = {
        api_key = "TERM", -- LM Studio ignores the key; TERM is always set
        name = "LMStudio",
        end_point = "http://localhost:1234/v1/chat/completions",
        -- Installed LM Studio models (ids from GET /v1/models — NOT the display name):
        --   "google/gemma-4-e4b" → light & fast (5.9 GB), best for snappy inline completion (default)
        --   "qwen/qwen3.6-27b"   → stronger at code but heavy (16 GB) + reasoning-capable; see note below
        model = "google/gemma-4-e4b",
        stream = true,
        optional = {
          max_tokens = 256,
          top_p = 0.9,
          -- If you switch to "qwen/qwen3.6-27b", keep its "thinking" mode OFF so it
          -- streams code instead of slow <think> reasoning, and bump request_timeout
          -- (top-level option above) to ~5s since the 27B is slower to first token:
          -- chat_template_kwargs = { enable_thinking = false },
        },
      },

      -- Point the block above at OpenRouter / DeepSeek / Groq / etc. instead by
      -- swapping the fields, e.g.:
      --   api_key   = "OPENROUTER_API_KEY",
      --   name      = "OpenRouter",
      --   end_point = "https://openrouter.ai/api/v1/chat/completions",
      --   model     = "deepseek/deepseek-chat",

      -- ── Cloud providers (set `provider = "<name>"` above to activate) ─────
      -- Export the matching env var first.
      openai = {
        api_key = "OPENAI_API_KEY",
        model = "gpt-4o-mini", -- ← change to a model you can access
        optional = { max_tokens = 256 },
      },
      claude = {
        api_key = "ANTHROPIC_API_KEY",
        model = "claude-haiku-4-5", -- ← change to a current Anthropic model id
        optional = { max_tokens = 512 },
      },
      gemini = {
        api_key = "GEMINI_API_KEY",
        model = "gemini-2.0-flash",
        optional = {},
      },
      codestral = {
        api_key = "CODESTRAL_API_KEY",
        model = "codestral-latest",
        optional = { max_tokens = 256 },
      },

      -- ── Ollama (local, fill-in-the-middle) ───────────────────────────────
      -- provider = "openai_fim_compatible"
      openai_fim_compatible = {
        api_key = "TERM",
        name = "Ollama",
        end_point = "http://localhost:11434/v1/completions",
        model = "qwen2.5-coder:7b",
        optional = { max_tokens = 256 },
      },
    },
  },
}
