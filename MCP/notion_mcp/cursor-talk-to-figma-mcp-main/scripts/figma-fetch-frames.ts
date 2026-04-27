#!/usr/bin/env bun
/**
 * One-off: join relay channel, get_document_info + get_nodes_info for FRAME children.
 * Usage: bun scripts/figma-fetch-frames.ts [channel]
 */
import { randomUUID } from "crypto";

const CHANNEL = process.argv[2] || "5gt4x8hq";
const WS_URL = "ws://localhost:3055";
const TIMEOUT_MS = 45_000;

const pending = new Map<
  string,
  { resolve: (v: unknown) => void; reject: (e: Error) => void; t: ReturnType<typeof setTimeout> }
>();

function sendCommand(ws: WebSocket, command: string, params: Record<string, unknown> = {}) {
  const id = randomUUID();
  ws.send(
    JSON.stringify({
      id,
      type: "message",
      channel: CHANNEL,
      message: {
        id,
        command,
        params: { ...params, commandId: id },
      },
    })
  );
  return id;
}

function rpc(ws: WebSocket, command: string, params: Record<string, unknown> = {}) {
  return new Promise<unknown>((resolve, reject) => {
    const id = sendCommand(ws, command, params);
    const t = setTimeout(() => {
      if (pending.has(id)) {
        pending.delete(id);
        reject(new Error(`timeout: ${command}`));
      }
    }, TIMEOUT_MS);
    pending.set(id, { resolve, reject, t });
  });
}

const ws = new WebSocket(WS_URL);

ws.addEventListener("message", (ev) => {
  const data = JSON.parse(String(ev.data)) as {
    type?: string;
    message?: string | { id?: string; result?: unknown; error?: string; command?: string };
  };

  if (data.type === "error" && typeof data.message === "string") {
    console.error("Relay:", data.message);
    ws.close();
    process.exit(1);
  }

  if (data.type === "broadcast" && data.message && typeof data.message === "object" && data.message.id && pending.has(data.message.id)) {
    const m = data.message;
    const slot = pending.get(m.id)!;
    clearTimeout(slot.t);
    pending.delete(m.id);
    if (m.error) slot.reject(new Error(m.error));
    else slot.resolve(m.result);
  }
});

ws.addEventListener("error", () => {
  console.error("WebSocket error (is bun socket running on 3055?)");
  process.exit(1);
});

ws.addEventListener("open", () => {
  ws.send(JSON.stringify({ type: "join", channel: CHANNEL }));
});

ws.addEventListener("message", async (ev) => {
  const data = JSON.parse(String(ev.data)) as {
    type?: string;
    message?: string | { result?: string };
    channel?: string;
  };

  if (
    data.type === "system" &&
    data.message &&
    typeof data.message === "object" &&
    data.message.result &&
    String(data.message.result).includes("Connected to channel")
  ) {
    try {
      const doc = (await rpc(ws, "get_document_info", {})) as {
        name?: string;
        id?: string;
        children?: Array<{ id: string; name: string; type: string }>;
      };
      const children = doc.children || [];
      const frames = children.filter((c) => c.type === "FRAME");
      const byType: Record<string, number> = {};
      for (const c of children) {
        byType[c.type] = (byType[c.type] || 0) + 1;
      }

      const MAX_FRAME_DEEP = 12;
      const summaries: Array<Record<string, unknown>> = [];
      for (let i = 0; i < Math.min(frames.length, MAX_FRAME_DEEP); i++) {
        const f = frames[i]!;
        try {
          const node = (await rpc(ws, "get_node_info", { nodeId: f.id })) as {
            id?: string;
            name?: string;
            type?: string;
            absoluteBoundingBox?: { x: number; y: number; width: number; height: number };
            children?: unknown[];
            fills?: unknown[];
            cornerRadius?: number;
          };
          summaries.push({
            id: node.id,
            name: node.name,
            type: node.type,
            width: node.absoluteBoundingBox?.width,
            height: node.absoluteBoundingBox?.height,
            x: node.absoluteBoundingBox?.x,
            y: node.absoluteBoundingBox?.y,
            directChildCount: Array.isArray(node.children) ? node.children.length : 0,
            hasBackgroundFill: Array.isArray(node.fills) && node.fills.length > 0,
            cornerRadius: node.cornerRadius,
          });
        } catch (e) {
          summaries.push({
            id: f.id,
            name: f.name,
            error: e instanceof Error ? e.message : String(e),
          });
        }
      }

      console.log(
        JSON.stringify(
          {
            channel: CHANNEL,
            pageName: doc.name,
            pageId: doc.id,
            topLevelCount: children.length,
            topLevelByType: byType,
            frames: frames.map((f) => ({ id: f.id, name: f.name })),
            frameSummaries: summaries,
            note:
              frames.length > MAX_FRAME_DEEP
                ? `Only first ${MAX_FRAME_DEEP} frames summarized; ${frames.length} total.`
                : undefined,
          },
          null,
          2
        )
      );
      ws.close();
      process.exit(0);
    } catch (e) {
      console.error(e instanceof Error ? e.message : e);
      ws.close();
      process.exit(1);
    }
  }
});
