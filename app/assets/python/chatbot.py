import sys
from transformers import DistilBertForQuestionAnswering, DistilBertTokenizer
import torch

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

if __name__ == "__main__":
    question = sys.argv[1]
    document = sys.argv[2]
    qa_engine = QAEngine()
    print(qa_engine.answer_question(question, document))
