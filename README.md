# Short Text Question Generation and Answering 

This project aims to create an API for generating and answering
elementary-school level reading comprehension questions.

## Currently implemented methods:

- Generation
    - [Learning to Ask: Neural Question Generation](https://github.com/xinyadu/nqg)
- Answering
    - [Bidirectional Attention Flow for Machine Comprehension](https://github.com/allenai/bi-att-flow)

## Project Structure

This repository is structured into two logical components

- Question Generation
- Question Answering

Under these directories, the currently implemented methods reside not as
regular code, but as *Git submodules* ie. they point to third party
repositories which are managed separately. 

Once cloning this repository, initialize the submodules and update them using
the following command.
```
git submodule update --init --recursive
```

A git pull will only pull the code of this repository, not that of the
submodules. So, if either of the submodules are updated in the future, pull
their code using 
``` 
git submodule update --recursive 
```

For more information on submodules, read [this](https://gist.github.com/gitaarik/8735255)
guide.

## Question Generation

To generate questions given a list of answer sentences, use `translate.lua`
under `question_generation/nqg_learningtoask/sentence`.  This script generates
questions from a file containing answers in the following format:

- txt file
- no new lines
- each answer takes up one line
- lower case

config-trans contains generation options including the file containing answer 
sentences. 

Below is a sample command for using this script.

```
cd question_generation/nqg_learningtoask/sentence
th translate.lua -model model/6B.300d.600rnn_epoch15_25.99.t7 -config config-trans
```

### Requirements

- [Torch7](https://github.com/torch/torch7)
- [tds](https://github.com/torch/tds)- Install with luarocks

For more instructions on installation , how to download embedding files, as
well as training models refer to the submodule's
[README](https://github.com/agent-jay/nqg/blob/master/sentence/README.md)

## Question Answering

To run the question answering module on a paragraph and a set of questions, use
the `question_answering/qa.sh` script along with a paragraph+question file
placed in `questions_answering/tests`. A `sample_question.txt` file has been
placed there as an example of the expected format. 

```
cd question_answering
./qa.sh sample_questions.txt
```

To train the model, follow the instructions on [this](https://github.com/agent-jay/bi-att-flow) page

### Requirements

- python 3.5
- tensorflow 0.11
- nltk

Instructions on how to install these versions of Python and Tensorflow
are provided in [this](infra_setup/cluster_setup.md) document. Additionally,
run the following commands inside bi-att-flow directory to download required
embedding files and tokenizers.

```
cd bi-att-flow
chmod +x download.sh
./download.sh
```

