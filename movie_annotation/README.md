## Movie Annotation Tools @ LAB Lab, UCL

We've collected a series of scripts to automatically annotate information in movies, as well as extract what may be relevant for cognitive neuroscience explorations.

## general requirements
You will have to register Amazon Web Services and Google Cloud accounts. Both offer the first year of services for free (FREE) and also have free quotas that should be more than sufficient for anyone doing movie annotation in cognitive neuroscience. Even when having to pay for some of the services, the costs are very low for the amount of data that has to be analysed and any research lab would be able to afford it.

As a lot of these scripts will be running for a while, we recommend using tmux as a tool to leave your scripts running in the background of a server thatyou connect to via ssh.

## speech-to-text
Here you'll find a script that uses Amazon's Speech Transcription API to transform the whole movie audio into a transcript. Individual words have start and end timestamps down to the milisecond. Have fun.

## visual info
Here you'll find scripts to use both AWS Rekognition and Google Cloud Video Intelligence API to get information about your videos: labels, face detection, emotion recognition, celebrity detection, scene labelling.

## Other relevant packages

`pip install pyscene`
