#!/usr/bin/env sh
set -e
cache_dir=./cache/example_experiment
experiment_config=./experiment.example.yaml
speech_corpus_root=./test/data_common_voice

printf "Reading all audio files in speech corpus\n\n"
speechbox dataset $cache_dir $experiment_config \
	--verbosity --verbosity \
	--src $speech_corpus_root \
	--walk \
	--check \
	--save-state

# All valid audio files in the speech corpus have now been gathered and their paths and labels saved to the cache directory

printf "\nCreating random training-validation-test split\n\n"
speechbox dataset $cache_dir $experiment_config \
	--verbosity --verbosity \
	--load-state \
	--split by-file \
	--check-split \
	--save-state

# Audio files have now been split into 3 disjoint datagroups: training, validation, and test
# The split, defined by paths, has been saved into the cache directory

printf "\nExtracting features\n\n"
speechbox preprocess $cache_dir $experiment_config \
	--verbosity --verbosity \
	--load-state \
	--extract-features \
	--save-state

# MFCCs have now been extracted from the audio files for each datagroup, and the features have been saved as TFRecords into the cache directory

printf "\nTraining simple LSTM model\n\n"
speechbox train $cache_dir $experiment_config \
	--verbosity --verbosity \
	--load-state \
	--model-id my-simple-lstm \
	--save-model

# A simple keras model has been trained on the features extracted during the previous step and saved into the cache directory
