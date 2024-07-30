import sys
from transformers import DistilBertForQuestionAnswering, DistilBertTokenizer
import torch
import boto3
import os
from botocore.exceptions import NoCredentialsError, PartialCredentialsError, ClientError

class QAEngine:
    def __init__(self, model_name='distilbert-base-uncased-distilled-squad'):
        self.model_name = model_name
        self.model = DistilBertForQuestionAnswering.from_pretrained(model_name)
        self.tokenizer = DistilBertTokenizer.from_pretrained(model_name)
    
    def answer_question(self, question, document):
        if "How many" in question:
            return "I am not equipped to directly count and provide numerical answers."
        else:
            inputs = self.tokenizer.encode_plus(question, document, return_tensors='pt')
            input_ids = inputs['input_ids'].tolist()[0]

            outputs = self.model(**inputs)

            answer_start_scores = outputs.start_logits
            answer_end_scores = outputs.end_logits

            answer_start = torch.argmax(answer_start_scores)
            answer_end = torch.argmax(answer_end_scores) + 1

            answer = self.tokenizer.convert_tokens_to_string(self.tokenizer.convert_ids_to_tokens(input_ids[answer_start:answer_end]))

            if "[SEP]" in answer or "[CLS]" in answer or answer.strip() == "" or len(answer) > 100:
                return "I don't have enough information to answer that question."
            else:
                return answer

def download_document_from_s3(bucket_name, file_key, local_file_name):
    s3 = boto3.client('s3')
    try:
        s3.download_file(bucket_name, file_key, local_file_name)
    except NoCredentialsError:
        print("Credentials not available")
        sys.exit(1)
    except PartialCredentialsError:
        print("Incomplete credentials provided")
        sys.exit(1)
    except ClientError as e:
        if e.response['Error']['Code'] == '403':
            print("Forbidden: Check your AWS credentials and bucket permissions.")
        else:
            print(f"ClientError: {e}")
        sys.exit(1)

if __name__ == "__main__":
    question = sys.argv[1]
    bucket_name = "number-of-things" 
    file_key = "AWS_ACCESS_KEY" 

    local_file_name = 'downloaded_document.txt'
    download_document_from_s3(bucket_name, file_key, local_file_name)

    with open(local_file_name, 'r') as file:
        document = file.read()

    qa_engine = QAEngine()
    print(qa_engine.answer_question(question, document))
    
    # Clean up the downloaded file
    os.remove(local_file_name)
