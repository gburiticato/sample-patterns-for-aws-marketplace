import urllib.parse
import boto3
import os
from langchain_elasticsearch import ElasticsearchStore
from langchain_aws import BedrockEmbeddings
from langchain_community.document_loaders import S3FileLoader

s3 = boto3.client('s3')

elasticsearch_endpoint = os.environ['ELASTICSEARCH_ENDPOINT']
elasticsearch_user = os.environ['ELASTICSEARCH_USER']
elasticsearch_password = os.environ['ELASTICSEARCH_PASSWORD']

def get_embeddings_model():
    return BedrockEmbeddings(
        model_id="amazon.titan-embed-text-v1"
    )

def get_elasticsearch_store(url, index, user, password):
    return ElasticsearchStore(
        es_url=url,
        index_name=index,
        embedding=get_embeddings_model(),
        es_user=user,
        es_password=password
    )

def handler(event, context):
    os.environ['TMPDIR'] = '/tmp'
    os.environ['TEMP'] = '/tmp'
    os.environ['TMP'] = '/tmp'
    os.environ['NLTK_DATA'] = '/tmp'
    es_store = get_elasticsearch_store(elasticsearch_endpoint, "documents", elasticsearch_user, elasticsearch_password)
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = urllib.parse.unquote_plus(event['Records'][0]['s3']['object']['key'], encoding='utf-8')
    try:
        loader = S3FileLoader(bucket, key)
        documents = loader.load_and_split()
        es_store.add_documents(documents)
    except Exception as e:
        print(e)
        print('Error loading object {} from bucket {}.'.format(key, bucket))
        raise e
              
