# FFmpeg MCP Server


## Overview

The **FFmpeg MCP Server** is a Model Context Protocol (MCP) server that exposes powerful **FFmpeg-based video and audio processing capabilities** as MCP tools.
It allows LLMs like Claude to programmatically perform common media-processing tasks such as:

* Extracting audio from videos
* Converting video formats
* Re-encoding video and audio
* Controlling quality, bitrate, and presets
* Changing frame rate and resolution
* Trimming and merging videos

All generated files are automatically saved to a visible `outputs/` directory.

---

## Features

* Executes FFmpeg commands via MCP tools
* Supports most common video and audio transformations
* Automatically generates unique output filenames
* Centralized output directory for easy access
* Configurable FFmpeg executable via environment variables
* Designed for seamless integration with Claude MCP

---

## Installation

### Prerequisites

Ensure the following are installed:

* Python 3.8+
* FFmpeg
* MCP / FastMCP

---

### Install FFmpeg

**Windows:**

1. Download FFmpeg from the [official site](https://ffmpeg.org/download.html)(Download the build release)
2. Extract it and add the `bin/` directory to your system PATH
<br>
Verify installation:

```bash
ffmpeg -version
```

**Linux:**

```bash
sudo apt update
sudo apt install ffmpeg
```

**macOS:**

```bash
brew install ffmpeg
```

---

### Install MCP & FastMCP

```bash
pip install mcp fastmcp
```

---

### Clone the Repository

```bash
git clone https://github.com/your-username/ffmpeg-mcp-server.git
cd ffmpeg-mcp-server
```

---

## Project Structure

```
ffmpeg-mcp-server/
├── server.py       # MCP server implementation
├── outputs/        # Generated audio/video files
└── README.md
```

---

## Environment Configuration

You can specify the FFmpeg executable path via environment variable:

```bash
export FFMPEG_EXECUTABLE=/absolute/path/to/ffmpeg
```

If not set, the server defaults to:

```text
ffmpeg
```

---

## Integration with Claude

To integrate the FFmpeg MCP server with Claude, add the following to your `claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "ffmpeg-server": {
      "command": "/absolute/path/to/python",
      "args": [
        "/absolute/path/to/ffmpeg-mcp-server/server.py"
      ],
      "env": {
        "FFMPEG_EXECUTABLE": "/absolute/path/to/ffmpeg"
      }
    }
  }
}
```
## Fiding Your Python Path
To find your python path, use the following command:

### Windows(Powershell):
```
(Get-Command python).Source
```
### Windows(Command Prompt/ Terminal):
```
which python
```
---


## Available Tools

1. **extract_audio** – Extract audio from a video
2. **convert_video** – Convert a video from one format to another
3. **encode_audio_video** – Re-encode video and audio using specific codecs
4. **preset_video** – Control encoding speed and compression using FFmpeg presets
5. **control_video_quality** – Adjust video quality via CRF
6. **bitrate_set** – Set fixed video bitrate
7. **framerate_set** – Set a fixed frame rate
8. **resolution_or_scaling** – Resize video to a specific resolution
9. **trim_video** – Trim a video between start and end times
10. **video_merge** – Merge multiple videos using FFmpeg concat demuxer

---
## Contributing

1. Fork the repository
2. Create a feature branch:

```bash
git checkout -b add-feature
```

3. Commit your changes:

```bash
git commit -m "Added new FFmpeg tool"
```

4. Push to your fork:

```bash
git push origin add-feature
```

5. Open a Pull Request

---

## License

This project is licensed under the **MIT License**.
You are free to use, modify, and distribute this software.

---

## Author

Created by **Sujal Gyawali**
Contributions welcome 🚀
