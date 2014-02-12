#!/usr/bin/python
# -*- coding: utf-8 -*-

from os import listdir
import os

from gensim import corpora, models, similarities
import gensim
import numpy
import math
import io

#stukjes code van Louis gekregen
# function to compute centroid of a term vector in LSA space.

#input args:  textstring, dimension=nr of lsa space dimension, 
#id2word=dictionary, lsi=slispace
def getCentroid(text, dimensions,id2word, lsi):
      words = text.split()

      centroid = None

      tempCentroid = [0]*int(dimensions)
      cFilled = False

      for word in words:
          nTuple = id2word.doc2bow(word.split())
          if nTuple:
              cFilled = True
              nId = nTuple[0][0]
              nProjection = lsi.projection.u[nId]
              tempCentroid += nProjection

      if cFilled:
          return tempCentroid
      else:
          return centroid


mypath= "/vol/bigdata/users/ihendrickx/ExpLSA/Conjs/GensimExp/Effe/"

# documents is an array of strings. 
# each string is one full document content.

documents=[]

# loop though a list of files

dirlist = listdir(mypath) 
for filename in dirlist:
    #print filename
    file = os.path.join(mypath,filename) 
    #print file
    f= io.open(file,'r',encoding='utf-8')
    #f = open(file, 'r')
    content = f.read()
    documents.append(content)
    #print content
    f.close()


#make array of arrays: all words in documents separately

texts = [[word for word in document.split()]
        for document in documents]

print texts

print "-------next in UTF8 hoop ik----------"

#dit werkt niet om utf8 probleem te verhelpen
#printabletext =  unicode(str(texts),'utf-8')
#print ",".join(texts).encode('utf8')
#maar dit helpt wel!!
for doc in texts:
        print "[" + ",".join(doc).encode('utf8') + "]"



dictionary = corpora.Dictionary(texts)
dictionary.save('/vol/bigdata/users/ihendrickx/ExpLSA/Conjs/GensimExp/effe.dict') # store the dictionary, for future reference
#print dictionary
#print dictionary.token2id


# make a sparse vector representation
corpus = [dictionary.doc2bow(text) for text in texts]
#print corpus

#make LSA space
dimensions=2
lsi = models.LsiModel(corpus, id2word=dictionary, num_topics=dimensions)
print lsi.projection.u.shape

#make a representation of Q and P in the LSA space
qpart= " goed twee betalen toilet "
ppart=" komen jaar willen verklaren goed "


qpart_vec = getCentroid(qpart, dimensions,dictionary, lsi)
ppart_vec = getCentroid(ppart, dimensions,dictionary, lsi)

print "qpart vec: ", qpart_vec
print "ppart vec: ", ppart_vec
result = 0

nom = numpy.dot(qpart_vec ,ppart_vec )
det1 = numpy.linalg.norm(qpart_vec )
det2 = numpy.linalg.norm(ppart_vec )
if math.isnan(nom) or math.isnan(det1) or math.isnan(det2) or det1 == 0 or det2 == 0 or nom == 0:
    result=0

# cosine computation
else:
    val = nom/(det1*det2)
    if not math.isnan(val):
        result = val

print "cosine=%f"%result
