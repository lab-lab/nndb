from __future__ import print_function
import time
import boto3

transcribe = boto3.client('transcribe')
job_name = "500_days_tr2"
job_uri = "https://s3.amazonaws.com/movietranscriptions/500_audio_track_mono.wav"

transcribe.start_transcription_job(
    TranscriptionJobName=job_name,
    Media={'MediaFileUri': job_uri},
    MediaFormat='wav',
    LanguageCode='en-US'
)

job_status = 'IN_PROGRESS'

while job_status == 'IN_PROGRESS':
    job = transcribe.get_transcription_job(
        TranscriptionJobName=job_name
    )
    job_status = job['TranscriptionJob']['TranscriptionJobStatus']
    time.sleep(5)
 
if job_status == 'FAILED':

    print('Job failed')

elif job_status == 'COMPLETED':

    print('Uri {0}'.format(job['TranscriptionJob']['Transcript']['TranscriptFileUri']))
