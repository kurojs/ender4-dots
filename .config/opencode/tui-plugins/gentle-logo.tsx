// @ts-nocheck
/** @jsxImportSource @opentui/solid */
import type { TuiPlugin, TuiThemeCurrent } from "@opencode-ai/plugin/tui"
import { useTerminalDimensions } from "@opentui/solid"
import { createMemo } from "solid-js"

const id = "gentle-logo"

const roseArt = [
  "▗▖ ▗▖▗▖ ▗▖▗▄▄▖  ▗▄▖",
  "▐▌▗▞▘▐▌ ▐▌▐▌ ▐▌▐▌ ▐▌",
  "▐▛▚▖ ▐▌ ▐▌▐▛▀▚▖▐▌ ▐▌",
  "▐▌ ▐▌▝▚▄▞▘▐▌ ▐▌▝▚▄▞▘",
  "",
  "👾 ゴ ゴ ゴ ゴ ゴ... 🍫",
]

const compactArt = ["✦ Gentle AI ✦"]

const Logo = (props: { theme: TuiThemeCurrent }) => {
  const dim = useTerminalDimensions()
  const lines = createMemo(() => {
    const term = dim()
    return term.height >= roseArt.length + 6 && term.width >= 32 ? roseArt : compactArt
  })

  return (
    <box flexDirection="column" alignItems="center">
      {lines().map((line) => (
        <text fg={props.theme.accent}>{line}</text>
      ))}
    </box>
  )
}

const tui: TuiPlugin = async (api) => {
  api.slots.register({
    id,
    order: 100,
    slots: {
      home_logo(ctx) {
        return <Logo theme={ctx.theme.current} />
      },
    },
  })
}

const plugin = { id: "gentle-logo", tui }
export default plugin
