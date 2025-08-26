import argparse, json, os, pathlib, glob
from config import MUSIC_DIR
from tts_piper import synthesize
from images_comfy import generate_images
from utils_audio import mix_music
from subtitles import srt_from_chunks
from assemble_video import assemble

def main(story_path, out_dir):
    pathlib.Path(out_dir).mkdir(parents=True, exist_ok=True)
    story = json.load(open(story_path, "r", encoding="utf-8"))
    beats = story["beats"]
    # 1) TTS per beat -> wavs + concat list
    chunks = []
    for i, b in enumerate(beats, 1):
        wav = os.path.join(out_dir, f"audio_beat{i}.wav")
        synthesize(b["narration_text"], wav)
        chunks.append({"text": b["narration_text"], "wav_path": wav})
    # 2) Concatenate beats with 500ms silence
    from pydub import AudioSegment
    narration_all = AudioSegment.silent(duration=0)
    for ch in chunks:
        narration_all += AudioSegment.from_file(ch["wav_path"]) + AudioSegment.silent(duration=500)
    final_narration = os.path.join(out_dir, "narration_full.wav")
    narration_all.export(final_narration, format="wav")
    # 3) Images from prompts
    prompts = [b["image_prompt"] for b in beats]
    slides = generate_images(prompts, os.path.join(out_dir, "slides"), images_per_prompt=story.get("images_per_beat", 1))
    # 4) Optional music
    music_files = []
    for ext in ("*.mp3","*.wav","*.flac","*.m4a","*.ogg"):
        music_files += glob.glob(os.path.join(MUSIC_DIR, ext))
    music_mix = final_narration
    if story.get("music_policy",{}).get("use_music") and music_files:
        music_mix = os.path.join(out_dir, "narration_with_music.wav")
        mix_music(final_narration, music_files[0], music_mix, duck_db=story.get("music_policy",{}).get("ducking_db",-12.0))
    # 5) Subtitles
    srt_path = os.path.join(out_dir, "subtitles.srt")
    srt_from_chunks(chunks, srt_path)
    # 6) Assemble video
    mp4 = os.path.join(out_dir, "final_1080p.mp4")
    assemble(slides if slides else ["./assets/fallback.jpg"], music_mix, mp4)
    print("DONE:", mp4)

if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("--story", required=True)
    ap.add_argument("--out", required=True)
    args = ap.parse_args()
    main(args.story, args.out)
