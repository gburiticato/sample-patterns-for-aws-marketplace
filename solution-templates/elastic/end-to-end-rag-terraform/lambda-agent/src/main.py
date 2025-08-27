import urllib.parse
import os
from langchain.prompts import PromptTemplate
from langchain_elasticsearch import ElasticsearchStore
from langchain_aws import BedrockEmbeddings, BedrockLLM
from langchain_community.document_loaders import S3FileLoader

elasticsearch_endpoint = os.environ['ELASTICSEARCH_ENDPOINT']
elasticsearch_user = os.environ['ELASTICSEARCH_USER']
elasticsearch_password = os.environ['ELASTICSEARCH_PASSWORD']

def get_embeddings_model():
    return BedrockEmbeddings(
        model_id="amazon.titan-embed-text-v1"
    )

def get_llm():
    return BedrockLLM(
        model_id="amazon.titan-text-premier-v1:0"
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
    print("---------------")
    print(event)
    print("---------------")
    print(context)
    os.environ['TMPDIR'] = '/tmp'
    os.environ['TEMP'] = '/tmp'
    os.environ['TMP'] = '/tmp'
    
    es_store = get_elasticsearch_store(elasticsearch_endpoint, "documents", elasticsearch_user, elasticsearch_password)
    llm = get_llm()
    
    question = event.get("body")
    search_results = es_store.similarity_search(question, k=3)
    
    relevant_documents = "\n\n".join([doc.page_content for doc in search_results]) if search_results else "No relevant information found in the index."
    
    template = """
    You are a helpful assistant that answers questions based on the provided context.
    
    Context information from the Elastic Index:
    {relevant_documents}
    
    Answer the following question using the context information provided above in addition to your general 
    knowledge. Clearly specify in your answer what information you are using from the Elastic Index and
    what information you are using from your general knowledge.
    
    Question: {question}
    """
    
    prompt = PromptTemplate(template=template, input_variables=["relevant_documents", "question"])
    
    chain = prompt | llm
    response = chain.invoke({"relevant_documents": relevant_documents, "question": question})
    
    return {
        "statusCode": 200,
        "body": response
    }
