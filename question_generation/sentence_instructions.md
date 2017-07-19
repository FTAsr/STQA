# Neural Question Generation 

## Overview

Implementation of neural question generation system for reading comprehension tasks. Paragraph-level model and sentence-level model will be made available soon. Our implementation is adapted from [OpenNMT](http://opennmt.net).

See the [paper](https://arxiv.org/abs/1705.00106),
>"Learning to Ask: Neural Question Generation for Reading Comprehension"

>Xinya Du, Junru Shao and Claire Cardie

>ACL 2017

## Requirements

- [Torch7](https://github.com/torch/torch7)
- [tds](https://github.com/torch/tds)
    - can be installed with luarocks
- [npy4th](https://github.com/htwaijry/npy4th)
    - follow installation instructions from the github docs
- Python 2.7, numpy


## Sentence-level model

For this task, only the sentence level model was run. The paper reported
diminished performance when providing the rest of the paragraph as context. See
the paper for more details.

	cd sentence


### Preprocessing:

#### Generate src/target dictionary

	th preprocess.lua -config config-preprocess


#### Generate embedding files (.t7)

If using anaconda, here is where you switch to your python 2.7 environment with
numpy

	python preprocess_embedding.py 
	--embedding  <path to embedding txt file>
	--dict ./data/qg.{src,tgt}.dict 
	--output ./data/qg.{src,tgt}.840B.300d.npy 
    
    Both src and tgt are needed. Whether or not you even need the embedding is
    your choice, and this step can be skipped altogether. However, better
    performance was indicated in the paper when using pretrained embeddings.
    Also, you have a choice of embeddings. The version used in the paper is
    Glove 840B word, 300 dimension word vectors. This however blew up RAM usage
    so I used 6B word, 100 dimension word vectors.

    Comment out the necessary part of the data/convert.lua script to reflect
    the choice of embeddings. 

	th ./data/convert.lua

After this process completes, move the generated .t7 embedding files to
data/embs/ (create this folder)


### Training:

In the root folder, create a model directory. Edit config-train's save_model
param to something that reflects your model parameter choices. I've saved my
changes in config-train-new. Then changes I made are to the save_model and
pre_word_vecs_enc(dec) parameters.

	th train.lua -config config-train-new



### Generating:

This script generates questions from a file containing answers in the following
format:

- txt file
- no new lines
- each answer takes up one line

config-trans is where you point the model to the file containing sentences that
you want to generate questions from. I've created a new file- config-trans-new

	th translate.lua -model model/<model file name> -config config-trans-new


## Evaluation

	cd qgevalcap
	./eval.py --out_file <path to output file>


## Acknowledgment

Original code written by https://github.com/xinyadu/nqg .

This implementation is adapted from [OpenNMT](http://opennmt.net). The evaluation scripts are adapted from [coco-caption](https://github.com/tylin/coco-caption) repo.

## License

Code is released under [the MIT license](http://opensource.org/licenses/MIT).
