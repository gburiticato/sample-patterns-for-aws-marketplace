from langchain_elasticsearch import ElasticsearchStore
from langchain_aws import BedrockEmbeddings, BedrockLLM
from langchain.chains import RetrievalQA

from dotenv import load_dotenv
from urllib.request import urlopen

import os
import boto3
import json

load_dotenv()

ELASTIC_CLOUD_ID = os.getenv('ELASTIC_CLOUD_ID')
ELASTIC_API_KEY = os.getenv('ELASTIC_API_KEY')
AWS_ACCESS_KEY = os.getenv('AWS_ACCESS_KEY')
AWS_SECRET_KEY = os.getenv('AWS_SECRET_KEY')
AWS_REGION = "us-east-1"

bedrock_client = boto3.client(
    service_name="bedrock-runtime",
    region_name=AWS_REGION
)

bedrock_embedding = BedrockEmbeddings(client=bedrock_client)

vector_store = ElasticsearchStore(
    es_cloud_id=ELASTIC_CLOUD_ID,
    es_api_key=ELASTIC_API_KEY,
    index_name="marketplace_index",
    embedding=bedrock_embedding,
)

url = "https://raw.githubusercontent.com/elastic/elasticsearch-labs/main/example-apps/chatbot-rag-app/data/data.json"

response = urlopen(url)

workplace_docs = json.loads(response.read())

from langchain.text_splitter import RecursiveCharacterTextSplitter

metadata = []
content = []

for doc in workplace_docs:
    content.append(doc["content"])
    metadata.append(
        {
            "name": doc["name"],
            "summary": doc["summary"],
            "rolePermissions": doc["rolePermissions"],
        }
    )

text_splitter = RecursiveCharacterTextSplitter.from_tiktoken_encoder(
    chunk_size=512, chunk_overlap=256
)
docs = text_splitter.create_documents(content, metadatas=metadata)

documents = vector_store.from_documents(
    docs,
    es_cloud_id=ELASTIC_CLOUD_ID,
    es_api_key=ELASTIC_API_KEY,
    index_name="marketplace_index",
    embedding=bedrock_embedding,
)

AWS_MODEL_ID = "amazon.titan-text-express-v1"

llm = BedrockLLM(
    client=bedrock_client,
    model=AWS_MODEL_ID
)

retriever = vector_store.as_retriever()

qa = RetrievalQA.from_llm(
    llm=llm,
    retriever=retriever,
    return_source_documents=True
)

question = "What job openings do we have?"
ans = qa({"query": question})
print(ans["result"] + "\n")