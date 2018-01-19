# a nlp environment

FROM pytorch/pytorch

# this image already had contained torch and torchvision pkgs

MAINTAINER denis<denis_lton@hotmail.com>

RUN pip install torchtext && pip install spacy && python -m spacy download en

RUN pip install jieba
