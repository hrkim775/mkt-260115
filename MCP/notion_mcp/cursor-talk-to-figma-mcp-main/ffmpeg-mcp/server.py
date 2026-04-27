from fastmcp import FastMCP
import os 
import subprocess
import uuid 

#defining mcp 
mcp = FastMCP("FFmpeg Video Server")

#this is the executable file ffmpeg.exe
FFMPEG_EXECUTABLE = os.getenv("FFMPEG_EXECUTABLE","ffmpeg")
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
OUTPUTS_DIR = os.path.join(BASE_DIR,"outputs")
os.makedirs(OUTPUTS_DIR ,exist_ok=True)

@mcp.tool()
def extract_audio(data:dict):
    video_path = data["video_path"]
    audio_format = data.get("audio_format","mp3")
    output_file = f"{OUTPUTS_DIR}/{uuid.uuid4()}.{audio_format}"

    cmd=[
        FFMPEG_EXECUTABLE,
        "-i", video_path,
        "-vn",
"-acodec", "mp3",
output_file
    ]
    subprocess.run(cmd,check=True)
    return {
        "status":"success",
        "output_audio":output_file
    }

@mcp.tool()
def convert_video(data:dict):
    """
    This is used for converting one video type to another 
    Example: mp4 to mk4 
    """
    input_path = data["video_path"]
    output_fromat= data["output_format"]
    output_file = f"{OUTPUTS_DIR}/{uuid.uuid4()}.{output_fromat}"

    cmd=[
        FFMPEG_EXECUTABLE,
        "-i",
        input_path,
        output_file

    ]

    subprocess.run(cmd, check=True)

    return {
        "status":"success",
        "output_video":output_file
    }
    
@mcp.tool()
def encode_audio_video(data:dict):
    """
    This is used for changing the encoding of video and video
    """
    input_path = data["video_path"]
    video_format = data["video_format"]
    video_encoder = data.get("video_encoder","libx264")
    audio_encoder = data.get("audio_encoder","aac")
    output_file = f"{OUTPUTS_DIR}/encoded{uuid.uuid4()}.{video_format}"

    cmd=[
        FFMPEG_EXECUTABLE,
        "-i",
        input_path,
        "-c:v",
        video_encoder,
        "-c:a",
        audio_encoder,
        output_file
    ]
    subprocess.run(cmd, check=True)

    return{
        "status":"success",
        "output_video":output_file
    }
@mcp.tool()
def preset_video(data:dict):
    """
    This is used for controlling encoding speed and compression efficiency and defined using preset 
    """
    input_path = data["video_path"]
    video_format = data["video_format"]
    video_encoder = data.get("video_encoder","libx264")
    audio_encoder = data.get("audio_encoder","aac")
    preset = data["preset"]
    output_file = f"{OUTPUTS_DIR}/preset{uuid.uuid4()}.{video_format}"

    cmd=[
        FFMPEG_EXECUTABLE,
        "-i",
        input_path,
        "-c:v",
        video_encoder,
        "-preset",
        preset,
        "-c:a",
        audio_encoder,
        output_file
    ]
    subprocess.run(cmd, check=True)

    return{
        "status":"success",
        "output_video":output_file
    }
@mcp.tool()
def control_video_quality(data:dict):
    """
    This is used for controlling video quality and defined using CRF
    """
    input_path = data["video_path"]
    video_format = data["video_format"]
    video_encoder = data.get("video_encoder","libx264")
    crf = data["crf"]
    output_file = f"{OUTPUTS_DIR}/crf{uuid.uuid4()}.{video_format}"

    cmd=[
        FFMPEG_EXECUTABLE,
        "-i",
        input_path,
        "-c:v",
        video_encoder,
        "-crf",
        crf,
        output_file
    ]
    subprocess.run(cmd, check=True)

    return{
        "status":"success",
        "output_video":output_file
    }
@mcp.tool()
def bitrate_set(data:dict):
    """
    This is used to fix the bitrate and defined uisng bitrate
   """
    input_path = data["video_path"]
    video_format = data["video_format"]
    video_encoder = data.get("video_encoder","libx264")
    bitrate=data["bitrate"] 
    output_file = f"{OUTPUTS_DIR}/bitrate{uuid.uuid4()}.{video_format}"

    cmd=[
        FFMPEG_EXECUTABLE,
        "-i",
        input_path,
        "-c:v",
        video_encoder,
        "-b:v",
        bitrate,
        output_file
    ]
    subprocess.run(cmd, check=True)

    return{
        "status":"success",
        "output_video":output_file
    }
@mcp.tool()
def framerate_set(data:dict):
    """
    This is used to provide the output with fixed frame rate
   """
    input_path = data["video_path"]
    video_format = data["video_format"]
    framerate=data["framerate"] 
    output_file = f"{OUTPUTS_DIR}/framerate{uuid.uuid4()}.{video_format}"

    cmd=[
        FFMPEG_EXECUTABLE,
        "-i",
        input_path,
       "-r", framerate,
"-c:v", "libx264",
output_file

    ]
    subprocess.run(cmd, check=True)

    return{
        "status":"success",
        "output_video":output_file
    }
@mcp.tool()
def resolution_or_scaling(data:dict):
    """
    This is used for resolution or scaling the video in fixed give size
    """
    input_path = data["video_path"]
    video_format = data["video_format"]
    scalewidth = data["scale"]["width"]
    scaleheight = data["scale"]["height"]
    output_file = f"{OUTPUTS_DIR}/scaled{uuid.uuid4()}.{video_format}"

    if(scaleheight):
        scale =f"scale={scalewidth}:{scaleheight}"
    else:
        scale=f"scale={scalewidth}:-1"

    cmd=[
        FFMPEG_EXECUTABLE,
        "-y",
        "-i",
        input_path,
        "-vf",
        scale,
        "-c:v", "libx264",

        output_file
    ]
    subprocess.run(cmd, check=True)

    return{
        "status":"success",
        "output_video":output_file
    }
@mcp.tool()
def trim_video(data:dict):

    """
    Use to trim the video providing start time and end time 
    take parameter video_path , video_format, start_time and end_time
    
    """
    input_path = data["video_path"]
    video_format = data["video_format"]
    start_time = data["start_time"]
    end_time = data["end_time"]
    output_file = f"{OUTPUTS_DIR}/trimmed{uuid.uuid4()}.{video_format}"

    cmd=[
        FFMPEG_EXECUTABLE,
        "-ss",
        start_time,
        "-i",
        input_path,
        "-to",
        end_time,
        output_file
    ]
    subprocess.run(cmd, check=True)

    return{
        "status":"success",
        "output_video":output_file
    }
@mcp.tool()
def video_merge(data:dict):
    """
    To merge the multiple videos and videos must be in some txt file written as 
    file 'video1.mp4'
    input parameters:
    txtfile_path and video_format
    """
    txtfile_path = data["txtfile_path"]
    video_format = data["video_format"]
    output_file = f"{OUTPUTS_DIR}/merged{uuid.uuid4()}.{video_format}"

    cmd = [
    FFMPEG_EXECUTABLE,
    "-fflags", "+genpts",
    "-f", "concat",
    "-safe", "0",
    "-i", txtfile_path,
    "-c", "copy",
    output_file
]

    subprocess.run(cmd, check=True)
    return{
        "status":"success",
        "output_video":output_file
    }

if __name__=="__main__":
    mcp.run(transport="stdio")

