## speech-to-text

-- Work in progress --

After you enable the Amazon Speech Recognition API, you can start transcribing! Same for the Google Speech API.

As subtitles provide a 'gold' standard for what is said in the movie, we use Dynamic Time Warping (DTW) to align the words in the subtitles to those in the transcripts.

We then use NLTK to preprocess to words and prepare these for the context analysis.

Files needed to run the scripts available:
moviename.srt
movieaudio.wav

#### pre-requisites
You need to make sure your movieaudio.wav meets the AWS API requirements. Use `ffmpeg` to convert your audio files if needed. More info to come soon.

### scripts
`python amazon_transcribe.py` will make the calls to the Amazon API to transcribe the file desired. The output will be a link that you can enter in your browser to download the JSON file containing the transcript.

`python google_transcribe.py` will call the Google Speech API to transcribe the file desired.

`python transcript_vs_subtitle.py` will align the subtitles using a DTW algorithm.

`python get_words_for_analysis.py` will parse through the aligned transcripts and prepare words for fMRI analysis.
