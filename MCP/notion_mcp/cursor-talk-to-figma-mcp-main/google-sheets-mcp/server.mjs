import dotenv from "dotenv"; // .env 파일을 읽어올 수 있도록 해주는 모듈
import path from "path"; // 특정 파일을 찾아오거나 불러올때  사용하는 모듈
import { fileURLToPath } from "url"; // ESM 모듈 전용 라이브러리 (특정 파일의 경로를 확인할 때)
import { google } from "googleapis"; // GS API를 사용할 수 있도록 해주는 라이브러리
import { z } from "zod"; // z object definition -> 완성된 요소의 검증을 해주는 라이브러리
// McpServer :  MCP 서버로서 실행할 수 있도록 클래스
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
// Cursor 라는 MCP 서버와 GS가 양방향 통신을 할 수 있도록 도와주는 라이브러리
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";

// const : 변수를 정의 할 때 사용
// .env 파일안에 기입한 credentials 파일을 읽어와서 GS에 연결
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

dotenv.config({
  path: path.join(__dirname, ".env"),
});

const SCOPES = ["https://www.googleapis.com/auth/spreadsheets"];
const DEFAULT_SPREADSHEET_ID = process.env.GOOGLE_SHEETS_DEFAULT_SPREADSHEET_ID;

if (!process.env.GOOGLE_APPLICATION_CREDENTIALS) {
  throw new Error("GOOGLE_APPLICATION_CREDENTIALS is not set.");
}

const credentialsPath = path.resolve(
  __dirname,
  process.env.GOOGLE_APPLICATION_CREDENTIALS,
);

const auth = new google.auth.GoogleAuth({
  keyFile: credentialsPath,
  scopes: SCOPES,
});

const sheets = google.sheets({ version: "v4", auth });

function ensureSpreadsheetId(spreadsheetId) {
  const id = spreadsheetId || DEFAULT_SPREADSHEET_ID;
  if (!id) {
    throw new Error(
      "spreadsheetId is required or set GOOGLE_SHEETS_DEFAULT_SPREADSHEET_ID.",
    );
  }
  return id;
}

function textResult(obj) {
  return {
    content: [
      {
        type: "text",
        text: typeof obj === "string" ? obj : JSON.stringify(obj, null, 2),
      },
    ],
  };
}

// mcp.json 파일안에 입력한 mcp 서버이름을 정상적으로 인지하고 작동시켜준다
const server = new McpServer({
  name: "google-sheets-mcp",
  version: "1.0.0",
});

// mcp 서버가 GS에 접속해서 데이터 읽어오기
server.registerTool(
  "gsheets_read_range",
  {
    title: "Read a range from Google Sheets",
    description: "Reads values from a Google Sheet range in A1 notation.",
    inputSchema: {
      spreadsheetId: z.string().optional(),
      range: z.string(),
    },
  },
  async ({ spreadsheetId, range }) => {
    try {
      const id = ensureSpreadsheetId(spreadsheetId);
      const res = await sheets.spreadsheets.values.get({
        spreadsheetId: id,
        range,
      });

      return textResult({
        spreadsheetId: id,
        range,
        values: res.data.values || [],
      });
    } catch (error) {
      return textResult({
        error: error instanceof Error ? error.message : String(error),
      });
    }
  },
);

// mcp 서버가 GS에 접속해서 행 추가 등의 데이터 추가등록
server.registerTool(
  "gsheets_append_rows",
  {
    title: "Append rows to Google Sheets",
    description: "Appends one or more rows to the end of a sheet range.",
    inputSchema: {
      spreadsheetId: z.string().optional(),
      range: z.string(),
      values: z.array(z.array(z.union([z.string(), z.number(), z.boolean()]))),
    },
  },
  async ({ spreadsheetId, range, values }) => {
    try {
      const id = ensureSpreadsheetId(spreadsheetId);
      const res = await sheets.spreadsheets.values.append({
        spreadsheetId: id,
        range,
        valueInputOption: "USER_ENTERED",
        insertDataOption: "INSERT_ROWS",
        requestBody: { values },
      });

      return textResult({
        spreadsheetId: id,
        range,
        updates: res.data.updates,
      });
    } catch (error) {
      return textResult({
        error: error instanceof Error ? error.message : String(error),
      });
    }
  },
);

// mcp 서버가 GS에 접속해서 기존 데이터를 덮어쓰기 | 수정
server.registerTool(
  "gsheets_update_range",
  {
    title: "Update a range in Google Sheets",
    description: "Overwrites a specific range with the provided values.",
    inputSchema: {
      spreadsheetId: z.string().optional(),
      range: z.string(),
      values: z.array(z.array(z.union([z.string(), z.number(), z.boolean()]))),
    },
  },
  async ({ spreadsheetId, range, values }) => {
    try {
      const id = ensureSpreadsheetId(spreadsheetId);
      const res = await sheets.spreadsheets.values.update({
        spreadsheetId: id,
        range,
        valueInputOption: "USER_ENTERED",
        requestBody: { values },
      });

      return textResult({
        spreadsheetId: id,
        range,
        updatedRows: res.data.updatedRows,
        updatedColumns: res.data.updatedColumns,
        updatedCells: res.data.updatedCells,
      });
    } catch (error) {
      return textResult({
        error: error instanceof Error ? error.message : String(error),
      });
    }
  },
);

// mcp 서버가 GS에 접속해서 데이터 삭제 | 제거
server.registerTool(
  "gsheets_clear_range",
  {
    title: "Clear a range in Google Sheets",
    description: "Clears values from a Google Sheet range.",
    inputSchema: {
      spreadsheetId: z.string().optional(),
      range: z.string(),
    },
  },
  async ({ spreadsheetId, range }) => {
    try {
      const id = ensureSpreadsheetId(spreadsheetId);
      const res = await sheets.spreadsheets.values.clear({
        spreadsheetId: id,
        range,
        requestBody: {},
      });

      return textResult({
        spreadsheetId: id,
        clearedRange: res.data.clearedRange,
      });
    } catch (error) {
      return textResult({
        error: error instanceof Error ? error.message : String(error),
      });
    }
  },
);

// mcp 서버가 GS에 접속해서 특정 컬럼에 입력된 키워드들을 수집 | 분석해서 형태소 분류
server.registerTool(
  "gsheets_write_keyword_summary",
  {
    title: "Write keyword summary rows",
    description:
      "Writes keyword summary rows with columns like keyword, count, source, date.",
    inputSchema: {
      spreadsheetId: z.string().optional(),
      sheetName: z.string().default("KeywordSummary"),
      rows: z.array(
        z.object({
          keyword: z.string(),
          count: z.number(),
          source: z.string().default("slack"),
          date: z.string(),
        }),
      ),
    },
  },
  async ({ spreadsheetId, sheetName, rows }) => {
    try {
      const id = ensureSpreadsheetId(spreadsheetId);
      const values = rows.map((row) => [
        row.keyword,
        row.count,
        row.source,
        row.date,
      ]);

      const range = `${sheetName}!A:D`;

      const res = await sheets.spreadsheets.values.append({
        spreadsheetId: id,
        range,
        valueInputOption: "USER_ENTERED",
        insertDataOption: "INSERT_ROWS",
        requestBody: { values },
      });

      return textResult({
        spreadsheetId: id,
        sheetName,
        appended: rows.length,
        updates: res.data.updates,
      });
    } catch (error) {
      return textResult({
        error: error instanceof Error ? error.message : String(error),
      });
    }
  },
);

// cursor와 외부 API가 정상적으로 양뱡향 통신을 하도록 하기 위한 인스턴스 객체를 생성
const transport = new StdioServerTransport();

// 위에서 만든 객체를 활용해서 실제 서버간 접속, 연결
await server.connect(transport);
